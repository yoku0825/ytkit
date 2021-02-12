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

return 1;