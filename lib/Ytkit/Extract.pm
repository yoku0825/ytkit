package Ytkit::Extract;

########################################################################
# Copyright (C) 2020  yoku0825
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
use base "Ytkit";

use Ytkit::IO;
use Ytkit::MySQLServer;

my $synopsis= q{  $ yt-extract --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password --table=mysql.user};
my $script= sprintf("%s - Show SELECT statement which is extracted '*'", $0);
my $description= << "EOS";
yt-extract transforms '*' to select_list such as

SELECT * FROM d1.t1 => SELECT col1, col2, .. FROM d1.t1
EOS
my $allow_extra_arvg= 0;
my $config= _config();


sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
              _orig_column_list => undef, ### Reserve for ResultSet arrayref
              _filtered_column_list => undef, ### Reserve for ResultSet arrayref
            };
  bless $self => $class;
  $self->handle_help;

  return $self;
}

sub extract
{
  my ($self)= @_;

  if ($self->{output} eq "select")
  {
    return $self->extract_as_select;
  }
  elsif ($self->{output} eq "insert")
  {
    return $self->extract_as_insert;
  }
  elsif ($self->{output} eq "insert-set")
  {
    return $self->extract_as_insert_set;
  }
  elsif ($self->{output} eq "insert-select")
  {
    return $self->extract_as_insert_select;
  }
  elsif ($self->{output} eq "replace")
  {
    return $self->extract_as_replace;
  }
  elsif ($self->{output} eq "update")
  {
    return $self->extract_as_update;
  }
  else
  {
    ### Unexpected output...
    _croakf("Unknown --output=%s", $self->{output});
  }
}

sub extract_as_select
{
  my ($self)= @_;
  return sprintf("SELECT %s FROM %s;\n",
                 $self->column_list_string,
                 $self->{table});
}

sub extract_as_insert
{
  my ($self)= @_;
  return sprintf("INSERT INTO %s (%s) VALUES (%s);\n",
                 $self->{table},
                 $self->column_list_string,
                 _placeholders($self->column_list));
}

sub extract_as_insert_set
{
  my ($self)= @_;
  return sprintf("INSERT INTO %s SET %s;\n",
                 $self->{table},
                 _set_type_placeholders($self->column_list));
}

sub extract_as_insert_select
{
  my ($self)= @_;
  return sprintf("INSERT INTO %s (%s) SELECT %s FROM %s WHERE %s;\n",
                 $self->{table},
                 $self->column_list_string,
                 $self->column_list_string,
                 $self->{table},
                 _primary_key_placeholders($self->{_orig_column_list}));
}

sub extract_as_replace
{
  my ($self)= @_;
  return sprintf("REPLACE INTO %s (%s) VALUES (%s);\n",
                 $self->{table},
                 $self->column_list_string,
                 _placeholders($self->column_list));
}

sub extract_as_update
{
  my ($self)= @_;
  return sprintf("UPDATE %s SET %s WHERE %s;\n",
                 $self->{table},
                 _set_type_placeholders($self->column_list),
                 _primary_key_placeholders($self->{_orig_column_list})); ### PK choise should not be filtered
}

sub _placeholders
{
  my ($column_list_arrayref)= @_;
  my $count= scalar(@{$column_list_arrayref});
  return join(", ", map { "?" } (1..$count));
}

sub _set_type_placeholders
{
  my ($column_list_arrayref)= @_;
  return join(", ", map { sprintf("%s = ?", $_->{Field}) } @$column_list_arrayref);
}

sub _primary_key_placeholders
{
  my ($column_list_arrayref)= @_;
  my @tmp= grep { $_->{Key} eq "PRI" } @$column_list_arrayref;
  _croakf("There's no PK, can't use --output=update") if !(@tmp);
  return join(" AND ", map { sprintf("%s = ?", $_->{Field}) } @tmp);
}

sub column_list_string
{
  my ($self)= @_;
  return join(", ", map { $_->{Field} } @{$self->column_list});
}

sub column_list
{
  my ($self)= @_;

  $self->{_orig_column_list} //= $self->instance->describe_table($self->{table});
  
  if (!($self->{_filtered_column_list}))
  {
    my $ret= $self->{_orig_column_list};
    $ret= _filter_nullable_column($ret) if $self->{only_not_null};
    $ret= _filter_default_column($ret) if $self->{only_no_default};
    $ret= _filter_exclude_column($self->{exclude_column}, $ret);
    $self->{_filtered_column_list}= $ret;
  }
  _croakf("select_list is Empty, please check column excluding options.") if !(@{$self->{_filtered_column_list}});
  return $self->{_filtered_column_list};
}

sub _filter_exclude_column
{
  my ($exclude_column, $column_list)= @_;
  return $column_list if !(@$exclude_column);

  my @ret;
  foreach my $column (@$column_list)
  {
    my $ignore= grep { lc($column->{Field}) eq lc($_) } @$exclude_column;
    push(@ret, $column) if !($ignore);
  }
  return \@ret;
}

sub _filter_nullable_column
{
  my ($column_list)= @_;
  my @ret= grep { $_->{Null} eq "NO" } @$column_list;
  return \@ret;
}

sub _filter_default_column
{
  my ($column_list)= @_;
  my @ret= grep { !(defined($_->{Default})) } @$column_list;
  return \@ret;
}

sub _config
{
  my $own_option=
  {
    "table" => { alias => ["table", "t", "tables"],
                 text => q{Fully qualified table name(like d1.t1) for extract.} },
    "exclude_column" => { alias => ["exclude", "exclude_column", "without", "exclude_columns" ],
                          text  => "Column name which is excluded from select_list",
                          multi => 1},
    "output" => { alias => ["output"],
                  isa => ["select", "insert", "replace", "update", "insert-set", "insert-select"],
                  default => "select",
                  text => "Output type of SELECT, INSERT, REPLACE, UPDATE" },
    "only_not_null" => { alias => ["only_not_null"],
                         noarg => 1,
                         default => 0,
                         text => "Exclude column which is NULLABLE", },
    "only_no_default" => { alias => ["only_no_default"],
                           noarg => 1,
                           default => 0,
                           text => "Exclude column which has DEFAULT value" },
  };

  my $config= Ytkit::Config->new({ %$own_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
}

return 1;
