package Ytkit::AdminTool::ORM::Column;

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
use Ytkit::IO qw{ _croakf };

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
  string   => { name => "VARCHAR(64)", dummy => "''" },
  clob     => { name => "TEXT", dummy => "('')" },   ### Functional DEFAULT (because TEXT type can't have Literal DEFAULT)
  uulong   => { name => "BIGINT UNSIGNED", dummy => 0 },
  datetime => { name => "DATETIME", dummy => "'1999-12-31 00:00:00'" },
  autoinc  => { name => "BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT", dummy => undef },
};

my $column_data_fix_map=
{
  varchar  => "string",
  char     => "string",
  int      => "int",
  smallint => "int",
  bigint   => "uulong",
  datetime => "datetime",
  dummy    => "clob",  ### If not matched above
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

  ### autoinc specific
  if ($self->{data_type} eq "autoinc")
  {
    ### Only not_null=1, default=undef, no_default=1 are acceptable.
    _croakf("--data_type=autoinc only supports --not_null=1 --no_default=1 (you can't specify --default)")
      if !($self->{no_default} == 1 && $self->{not_null} == 1);
  }

  return $self;
}

sub new_from_row
{
  my ($class, $one_row_hashref)= @_;
  return undef if !($one_row_hashref->{column_name});

  if ($one_row_hashref->{column_extra} eq "auto_increment")
  {
    return Ytkit::AdminTool::ORM::Column->new("--column_name", $one_row_hashref->{column_name},
                                              "--data_type=autoinc");
  }
  else
  {
    my $fixed_data_type= $column_data_fix_map->{$one_row_hashref->{data_type}};
    $fixed_data_type //= $column_data_fix_map->{dummy}; ### Fallback to clob

    my ($default, $no_default)= defined($one_row_hashref->{column_default}) ?
                                  (_handle_default($one_row_hashref->{column_default}, $fixed_data_type), 0) :
                                  (undef, 1);

    return Ytkit::AdminTool::ORM::Column->new("--column_name", $one_row_hashref->{column_name},
                                              "--data_type", $fixed_data_type,
                                              "--not_null", $one_row_hashref->{is_nullable} eq "NO" ? 1 : 0,
                                              defined($default) ? qq{--default="$default"} : "",
                                              "--no-default=$no_default");
  }
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
      return $self->modify if ($self->{$_} // "") ne ($target->{$_} // "");
    }

    ### 2 objects are same, nothing to do.
    return { pre => undef, after => undef };
  }
}

sub init
{
  my ($self)= @_;

  if ($self->{data_type} eq "autoinc")
  {
    ### AUTO_INCREMENT special handle..
    return { pre   => sprintf(q{`%s` %s}, $self->{column_name}, $data_type_map->{$self->{data_type}}->{name}),
             after => undef };
  }

  my $sql_part= sprintf(q{`%s` %s %s %s},
                        $self->{column_name},
                        $data_type_map->{$self->{data_type}}->{name},
                        $self->{not_null} ? "NOT NULL" : "",
                        $self->{no_default} || !(defined($self->{default})) ? "" :
                          sprintf("DEFAULT %s", $self->{default}));
  return { pre => $sql_part, after => undef };
}

sub modify
{
  my ($self)= @_;

  if ($self->{data_type} eq "autoinc")
  {
    ### AUTO_INCREMENT doesn't support MODIFY(in my module)
    return { pre => undef, after => undef };
  }
 
  my $sql_part= sprintf(q{MODIFY `%s` %s %s %s},
                        $self->{column_name},
                        $data_type_map->{$self->{data_type}}->{name},
                        $self->{not_null} ? "NOT NULL" : "",
                        $self->{no_default} || !(defined($self->{default})) ? "" :
                          sprintf("DEFAULT %s", $self->{default}));
  return { pre => $sql_part, after => undef };
}

sub add
{
  my ($self)= @_;

  if ($self->{data_type} eq "autoinc")
  {
    ### AUTO_INCREMENT doesn't support MODIFY(in my module)
    return { pre => undef, after => undef };
  }

  if ($self->{not_null} && ($self->{no_default} || !(defined($self->{default}))))
  {
    ### When adding NOT NULL && don't have DEFAULT column to existent table, use 2-phase ALTER.
    ### 1. add NOT NULL with dummy DEFAULT
    ### 2. remove DEFAULT
    my $sql_part= sprintf(q{ADD `%s` %s NOT NULL DEFAULT %s},
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
                            sprintf("DEFAULT %s", $self->{default}));
    return { pre => $sql_part, after => undef };
  }
}

sub drop
{
  my ($self)= @_;
  my $sql_part= sprintf(q{DROP `%s`}, $self->{column_name});
  return { pre => $sql_part, after => undef };
}

sub _handle_default
{
  my ($default, $data_type)= @_;

  if (!(defined($default)) || $default eq "")
  {
    return $data_type_map->{$data_type}->{dummy};
  }
}


return 1;
