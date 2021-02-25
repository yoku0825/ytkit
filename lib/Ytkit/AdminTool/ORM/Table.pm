package Ytkit::AdminTool::ORM::Table;

use strict;
use warnings;
use utf8;
use Ytkit::IO qw{ _croakf };

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

  if (_check_autoinc($self->{column}))
  {
    ### Table has autoinc, can't specify PRIMARY KEY
    _croakf("Can't specify primary_key, when using AUTO_INCREMENT column") if $self->{primary_key};
  }
  else
  {
    _croakf("Ytkit::AdminTool::ORM::Table must have PRIMARY KEY.") if !($self->{primary_key});
  }
  return $self;
}

sub new_from_row
{
  my ($self, $column_rows, $index_rows)= @_;
  return undef if !($column_rows->[0]->{table_name}) || !($index_rows->[0]->{table_name});

  my $table;
  my $has_autoinc= 0;
  ### table_name is derived from i_s.tables, they have same value in all row.
  $table->{table_name}= $column_rows->[0]->{table_name};
  
  my @column_list;
  foreach (@$column_rows)
  {
    push(@column_list, Ytkit::AdminTool::ORM::Column->new_from_row($_));
    $has_autoinc= 1 if $_->{column_extra} eq "auto_increment";
  }
  $table->{column}= \@column_list;

  my @index_list;
  foreach (@$index_rows)
  {
    if ($has_autoinc == 1 && $_->{index_name} eq "PRIMARY")
    {
      ### autoinc column includes PRIMARY KEY word in its column definition.
      next;
    }

    if ($_->{index_name} eq "PRIMARY")
    {
      $table->{primary_key}= Ytkit::AdminTool::ORM::Index->new_from_row($_);
    }
    else
    {
      push(@index_list, Ytkit::AdminTool::ORM::Index->new_from_row($_));
    }
  }
  $table->{secondary_key}= \@index_list;

  return Ytkit::AdminTool::ORM::Table->new($table);
}

sub init
{
  my ($self)= @_;

  ### Columns
  my @buff= map { $_->init->{pre} } @{$self->{column}};

  ### Indexes
  push(@buff, $self->{primary_key}->init->{pre}) if $self->{primary_key};
  push(@buff, map { $_->init->{pre} } @{$self->{secondary_key}});
  push(@buff, map { $_->init->{pre} } @{$self->{foreign_key}});

  return sprintf('CREATE TABLE `%s` (%s)', $self->{table_name},
                 join(", ", @buff));
}

sub compare
{
  my ($self, $target)= @_;

  if (!(defined($target)))
  {
    ### target is not there, CREATE TABLE by init
    return $self->init;
  }
  elsif ($target->{table_name} ne $self->{table_name})
  {
    _croakf("Table names are different. %s / %s", $self->{table_name}, $target->{table_name});
  }

  my (@pre, @after);

  ### Compare columns
  foreach my $self_column (@{$self->{column}})
  {
    my $exists= 0;
    foreach my $target_column (@{$target->{column}})
    {
      if ($self_column->{column_name} eq $target_column->{column_name})
      {
        my $ret= $self_column->compare($target_column);
        push(@pre, $ret->{pre});
        push(@after, $ret->{after});
        $exists= 1;
        last; ### Go to next $self_column
      }
    }

    if (!($exists))
    {
      my $ret= $self_column->add;
      push(@pre, $ret->{pre});
      push(@after, $ret->{after});
    }
  }

  foreach my $target_column (@{$target->{column}})
  {
    if (!(grep { $target_column->{column_name} eq $_->{column_name} } @{$self->{column}}))
    {
      ### column exists in $target but not $self, should be dropped.
      my $ret= $target_column->drop;
      push(@pre, $ret->{pre});
      push(@after, $ret->{after});
    }
  }

  ### Comparing PRIMARY KEY is not supported.
  ### PRIMARY KEY must be create by CREATE TABLE and must not be modified (in this module)

  ### Compare SECONDARY KEY
  foreach my $self_index (@{$self->{secondary_key}})
  {
    ### We only distinct index by name(generated automatically)
    if (!(grep { $self_index->{index_name} eq $_->{index_name} } @{$target->{secondary_key}}))
    {
      my $ret= $self_index->add;
      push(@pre, $ret->{pre});
      push(@after, $ret->{after});
    }
  }
  ### We don't care the index which is $target but not $self,
  ### those maybe created by DBA.

  ### Comparing FOREIGN KEY is not supported eigher.
  ### FOREIGN KEY must be create by CREATE TABLE and must not be modified (in this module)

  ### Trim undef element.
  @pre  = grep { defined($_) } @pre;
  @after= grep { defined($_) } @after;

  my $buff;
  $buff = sprintf('ALTER TABLE `%s` %s;', $self->{table_name}, join(", ", @pre)) if @pre;
  $buff.= sprintf('ALTER TABLE `%s` %s;', $self->{table_name}, join(", ", @after)) if @after;
  return $buff;
}

sub _check_autoinc
{
  my ($column)= @_;
  my $has_autoinc= "";

  foreach (@$column)
  {
    if ($_->{data_type} eq "autoinc")
    {
      ### only 1 column
      _croakf("Table cannot have more than 1 autoinc column.") if $has_autoinc ne "";
      $has_autoinc= $_->{column_name};
    }
  }
  return $has_autoinc;
}

return 1;
