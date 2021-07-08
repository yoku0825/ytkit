package Ytkit::GroupbyHelper;

########################################################################
# Copyright (C) 2014, 2021  yoku0825
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

### my $event=
### {
###   time_string => "",
###   table => "",
###   statement => "",
###   exec_time => "",
### };

package Ytkit::GroupbyHelper::Groupby_Base;

use strict;
use warnings;
use utf8;

sub new
{
  my ($class)= @_;
  return bless {} => $class;
}

sub clear
{
  my ($self)= @_;
  foreach (keys(%$self))
  {
    delete($self->{$_})
  }
}

sub increment
{
  ### This should be implemented in each class.
}

sub _print_n_element
{
  my ($hash, $n)= @_;
  my @ret;

  if ($n == 1)
  {
    foreach (sort(keys(%$hash)))
    {
      push(@ret, sprintf("%s\t%d\n", $_, $hash->{$_}));
    }
  }
  else
  {
    foreach (sort(keys(%$hash)))
    {
      foreach my $buff (@{_print_n_element($hash->{$_}, $n - 1)})
      {
        push(@ret, sprintf("%s\t%s", $_, $buff));
      }
    }
  }
  return \@ret;
}

package Ytkit::GroupbyHelper::Groupby_Time;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(1);
}
 
package Ytkit::GroupbyHelper::Groupby_Table;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{table}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(1);
}
 
package Ytkit::GroupbyHelper::Groupby_Statement;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(1);
}
 
package Ytkit::GroupbyHelper::Groupby_TimeStatement;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(2);
}

package Ytkit::GroupbyHelper::Groupby_TimeTable;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{table}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(2);
}

package Ytkit::GroupbyHelper::Groupby_TableStatement;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{table}}->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(2);
}

package Ytkit::GroupbyHelper::Groupby_TimeTableStatement;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(3);
}
 
package Ytkit::GroupbyHelper::Groupby_TimeTableStatementExec;

use base "Ytkit::GroupbyHelper::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}->{$event->{exec_time}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(4);
}
 

return 1;
