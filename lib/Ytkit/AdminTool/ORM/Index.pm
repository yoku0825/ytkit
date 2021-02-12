package Ytkit::AdminTool::ORM::Index;

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
use Ytkit::IO qw{ _sprintf };


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


return 1;