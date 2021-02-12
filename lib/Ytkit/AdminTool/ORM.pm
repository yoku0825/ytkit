package Ytkit::AdminTool::ORM;

########################################################################
# Copyright (C) 2021  yoku0825
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
########################################################################

use strict;
use warnings;
use utf8;

use Ytkit::Config;


package Ytkit::AdminTool::ORM::Column;

use strict;
use warnings;
use utf8;

use Ytkit::Config;
use Ytkit::IO qw{ _croakf };
use base "Exporter";
our @EXPORT= qw{ make_column };

my $column_option=
{
  column_name => { mandatory => 1 },
  data_type   => { isa => ["int", "string", "clob", "uulong", "datetime", "autoinc"],
                   mandatory => 1 },
  not_null    => { isa => [0, 1],
                   default => 1 },
  default     => { default => undef },
  no_default  => { isa => [0, 1],
                   default => 1 },
};

my $data_type_map=
{
  int      => { name => "INT", dummy => 0 },
  string   => { name => "VARCHAR(64)", dummy => '' },
  clob     => { name => "TEXT", dummy => q{('')} },   ### Functional DEFAULT (because TEXT type can't have Literal DEFAULT)
  uulong   => { name => "BIGINT UNSIGNED", dummy => 0 },
  datetime => { name => "DATETIME", dummy => '1999-12-31 00:00:00' },
  autoinc  => { name => "BIGINT UNSIGNED NOT NULL AUTO_INCREMENT", dummy => undef },
};


sub new
{
  my ($class, @orig_argv)= @_;

  my $config= Ytkit::Config->new($column_option);
  $config->{_allow_extra_argv}= 0;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}}, };
  bless $self => $class;

  ### validation
  if ($self->{no_default} && defined($self->{default}))
  {
    _croakf("--no-default=1 but --default is specified.");
  }
  elsif (!($self->{no_default}) && !(defined($self->{default})))
  {
    _croakf("--no-default=0 but --default is NOT specified.");
  }

  return $self;
}

sub new_from_row
{
  ### Expected $one_row_hashref is generated from following query
  ### --- 
  ### SELECT column_name AS column_name,
  ###        data_type AS data_type,
  ###        is_nullable AS is_nullable,
  ###        column_default AS column_default
  ### FROM information_schema.columns
  ### WHERE (table_schema, table_name, column_name)= (?, ?, ?)

  my ($class, $one_row_hashref)= @_;
  return undef if !($one_row_hashref->{column_name});

  my $fixed_data_type= $one_row_hashref->{data_type} eq "varchar" ? "string" : 
                       $one_row_hashref->{data_type} eq "char" ? "string" :
                       $one_row_hashref->{data_type} eq "int" ? "int" :
                       $one_row_hashref->{data_type} eq "bigint" ? "uulong" :
                       "clob"; ### not matched varchar, int, bigint

  my ($default, $no_default)= defined($one_row_hashref->{column_default}) ?
                                ($one_row_hashref->{column_default}, 0) :
                                (undef, 1);

  return Ytkit::AdminTool::ORM::Column->new("--column_name", $one_row_hashref->{column_name},
                                            "--data_type", $fixed_data_type,
                                            "--not_null", $one_row_hashref->{is_nullable} eq "NO" ? 1 : 0,
                                            defined($default) ? "--default='$default'" : "",
                                            "--no-default=$no_default");
}

sub compare
{
  my ($self, $target)= @_;

  if (!(defined($target)))
  {
    ### target is not there, ADD operation
    return $self->add;
  }
  elsif ($target->{column_name} ne $self->{column_name})
  {
    _croakf("Column names are different. %s / %s", $self->{column_name}, $target->{column_name});
  }
  else
  {
    foreach (sort(keys(%$column_option)))
    {
      return $self->modify if $self->{$_} ne $target->{$_};
    }

    ### 2 objects are same, nothing to do.
    return { pre => undef, after => undef };
  }
}

sub init
{
  my ($self)= @_;

  my $sql_part= sprintf(q{`%s` %s %s %s},
                        $self->{column_name},
                        $data_type_map->{$self->{data_type}}->{name},
                        $self->{not_null} ? "NOT NULL" : "",
                        $self->{no_default} || !(defined($self->{default})) ? "" :
                          sprintf("DEFAULT '%s'", $self->{default}));
  return { pre => $sql_part, after => undef };
}

sub modify
{
  my ($self)= @_;
  my $sql_part= sprintf(q{MODIFY `%s` %s %s %s},
                        $self->{column_name},
                        $data_type_map->{$self->{data_type}}->{name},
                        $self->{not_null} ? "NOT NULL" : "",
                        $self->{no_default} || !(defined($self->{default})) ? "" :
                          sprintf("DEFAULT '%s'", $self->{default}));
  return { pre => $sql_part, after => undef };
}

sub add
{
  my ($self)= @_;

  if ($self->{not_null} && ($self->{no_default} || !(defined($self->{default}))))
  {
    ### When adding NOT NULL && don't have DEFAULT column to existent table, use 2-phase ALTER.
    ### 1. add NOT NULL with dummy DEFAULT
    ### 2. remove DEFAULT
    my $sql_part= sprintf(q{ADD `%s` %s NOT NULL DEFAULT '%s'},
                          $self->{column_name},
                          $data_type_map->{$self->{data_type}}->{name},
                          $data_type_map->{$self->{data_type}}->{dummy});
    return { pre => $sql_part, after => $self->modify->{pre} };
  }
  else
  {
    my $sql_part= sprintf(q{ADD `%s` %s %s %s},
                          $self->{column_name},
                          $data_type_map->{$self->{data_type}}->{name},
                          $self->{not_null} ? "NOT NULL" : "",
                          $self->{no_default} || !(defined($self->{default})) ? "" :
                            sprintf("DEFAULT '%s'", $self->{default}));
    return { pre => $sql_part, after => undef };
  }
}

sub drop
{
  my ($self)= @_;
  my $sql_part= sprintf(q{DROP `%s`}, $self->{column_name});
  return { pre => $sql_part, after => undef };
}

sub make_column
{
  return Ytkit::AdminTool::ORM::Column->new(@_);
}


package Ytkit::AdminTool::ORM::Index;

use strict;
use warnings;
use utf8;

use Ytkit::Config;
use Ytkit::IO qw{ _sprintf };
use base "Exporter";
our @EXPORT= qw{ make_index };


my $index_option=
{
  column_name => { mandatory => 1, multi => 1 },
  is_primary  => { isa => [0, 1], default => 0 },
  is_unique   => { isa => [0, 1], default => 0 },
};

sub new
{
  my ($class, @orig_argv)= @_;

  my $config= Ytkit::Config->new($index_option);
  $config->{_allow_extra_argv}= 0;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}}, };
  bless $self => $class;

  if ($self->{is_primary})
  {
    $self->{index_name}= "PRIMARY";
  }
  else
  {
    ### Create index name without specification(always auto-creation)
    $self->{index_name}= _sprintf("%sidx_%s", $self->{is_unique} ? "u" : "",
                                              join("_", @{$self->{column_name}}));
  }

  return $self;
}

sub new_from_row
{
  ### SELECT index_name AS index_name,
  ###        non_unique AS non_unique,
  ###        GROUP_CONCAT(column_name ORDER BY seq_in_index) AS _columns 
  ### FROM information_schema.statistics
  ### WHERE (table_schema, table_name, index_name)= (?, ?, ?) AND 
  ###       index_name NOT IN (SELECT constraint_name
  ###                          FROM information_schema.referential_constraints
  ###                          WHERE (constraint_schema, table_name, constraint_name)= (table_schema, table_name, index_name))
  ### GROUP BY index_name, non_unique;
  my ($class, $one_row_hashref)= @_;
  return undef if !($one_row_hashref->{index_name});

  my @columns= split(",", $one_row_hashref->{_columns});
  return Ytkit::AdminTool::ORM::Index->new($one_row_hashref->{non_unique} == 0 ? "--is_unique=1" : "",
                                           $one_row_hashref->{index_name} eq "PRIMARY" ? "--is_primary=1" : "",
                                           map { sprintf("--column_name=%s", $_) } @columns);
}

sub init
{
  my ($self)= @_;

  my $column_list= join(", ", map { _sprintf(q{`%s`}, $_) } @{$self->{column_name}});
  if ($self->{is_primary})
  {
    return { pre   => _sprintf(q{PRIMARY KEY (%s)}, $column_list),
             after => undef };
  }
  else
  {
    return { pre   => _sprintf(q{%s KEY `%s` (%s)},
                               $self->{is_unique} ? "UNIQUE" : "",
                               $self->{index_name}, $column_list),
             after => undef };
  }
}

sub add
{
  my ($self)= @_;

  my $column_list= join(", ", map { _sprintf(q{`%s`}, $_) } @{$self->{column_name}});
  if ($self->{is_primary})
  {
    return { pre   => _sprintf(q{ADD PRIMARY KEY (%s)}, $column_list),
             after => undef };
  }
  else
  {
    return { pre   => _sprintf(q{ADD %s KEY `%s` (%s)},
                               $self->{is_unique} ? "UNIQUE" : "",
                               $self->{index_name}, $column_list),
             after => undef };
  }
}

sub drop
{
  my ($self)= @_;

  if ($self->{is_primary})
  {
    return { pre   => "DROP PRIMARY KEY", after => undef };
  }
  else
  {
    return { pre   => _sprintf(q{DROP KEY `%s`}, $self->{index_name}),
             after => undef };
  }
}

sub modify
{
  my ($self)= @_;

  ### Index can't be modified, re-create.
  return { pre   => $self->drop->{pre},
           after => $self->create->{pre} };
}

sub make_index
{
  return Ytkit::AdminTool::ORM::Index->new(@_);
}

package Ytkit::AdminTool::ORM::ForeignKey;

use strict;
use warnings;
use utf8;

use Ytkit::Config;
use Ytkit::IO qw{ _sprintf };
use base "Exporter";
our @EXPORT= qw{ make_fk };

my $foreignkey_option=
{
  column_name => { mandatory => 1, multi => 1 },
  reference_table => { alias => ["reference", "references", "reference_table"], mandatory => 1 },
  ### cascade means both of ON UPDATE CASCADE ON DELETE CASCADE
  action => { default => "restrict", isa => ["restrict", "cascade" ] },
  ### Now we don't support FK between other names.
};

sub new
{
  my ($class, @orig_argv)= @_;

  my $config= Ytkit::Config->new($foreignkey_option);
  $config->{_allow_extra_argv}= 0;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}}, };
  bless $self => $class;

  ### Create index name without specification(always auto-creation)
  $self->{index_name}= _sprintf("fidx_%s", join("_", @{$self->{column_name}}));

  return $self;
}

sub new_from_row
{
  ...;
}

sub init
{
  my ($self)= @_;

  my $column_list= join(", ", map { _sprintf(q{`%s`}, $_) } @{$self->{column_name}});
  return { pre   => _sprintf(q{CONSTRAINT `%s` FOREIGN KEY `%s` (%s) REFERENCES `%s` (%s) %s},
                               $self->{index_name}, $self->{index_name}, $column_list,
                               $self->{reference_table}, $column_list,
                               $self->{action} eq "restrict" ? "ON UPDATE RESTRICT ON DELETE RESTRICT" :
                                 $self->{action} eq "cascade" ? "ON UPDATE CASCADE ON DELETE CASCADE" : ""),
           after => undef };
}

sub add
{
  my ($self)= @_;

  my $column_list= join(", ", map { _sprintf(q{`%s`}, $_) } @{$self->{column_name}});

  return { pre   => _sprintf(q{ADD CONSTRAINT `%s` FOREIGN KEY `%s` (%s) REFERENCES `%s` (%s) %s},
                               $self->{index_name}, $self->{index_name}, $column_list,
                               $self->{reference_table}, $column_list,
                               $self->{action} eq "restrict" ? "ON UPDATE RESTRICT ON DELETE RESTRICT" :
                                 $self->{action} eq "cascade" ? "ON UPDATE CASCADE ON DELETE CASCADE" : ""),
           after => undef };
}

sub drop
{
  my ($self)= @_;

  return { pre   => _sprintf(q{DROP FOREIGN KEY `%s`}, $self->{index_name}),
           after => undef };
}

sub modify
{
  my ($self)= @_;

  ### Index can't be modified, re-create.
  return { pre   => $self->drop->{pre},
           after => $self->create->{pre} };
}

sub make_fk
{
  return Ytkit::AdminTool::ORM::ForeignKey->new(@_);
}

package Ytkit::AdminTool::ORM::Table;

use strict;
use warnings;
use utf8;
use Ytkit::IO qw{ _croakf };
use base "Exporter";
our @EXPORT= qw{ make_table };

### Expected structure
### $table=
### {
###   table_name    => "table_name",
###   column        => [Ytkit::AdminTool::ORM::Column, ..],
###   primary_key   => Ytkit::AdminTool::ORM::Index,
###   secondary_key => [Ytkit::AdminTool::ORM::Index, ..],
###   foreign_key   => [Ytkit::AdminTool::ORM::ForeignKey, ..],
### }

sub new
{
  my ($class, $self)= @_;
  bless $self => $class;

  ### Validation
  _croakf("Ytkit::AdminTool::ORM::Table must have 1 or more column.") if !(@{$self->{column}});
  #_croakf("Ytkit::AdminTool::ORM::Table must have PRIMARY KEY.") if !($self->{primary_key});
  return $self;
}

sub new_from_row
{
  ...;
}

sub init
{
  ...;
}

sub compare
{
  ...;
}

sub make_table
{
  return Ytkit::AdminTool::ORM::Table->new(@_);
}


return 1;
