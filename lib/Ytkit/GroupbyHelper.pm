package Ytkit::GroupbyHelper;

########################################################################
# Copyright (C) 2014, 2025  yoku0825
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
###   transaction_length => "",
### };

use constant NEED_FULL_SORT    => 1;
use constant NO_NEED_FULL_SORT => 0;

sub make_group_by_class
{
  my ($group_by_string)= @_;
  my $group_by= sort_csv($group_by_string);

  if ($group_by eq "table")
  {
    return (NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_Table->new);
  }
  elsif ($group_by eq "statement")
  {
    return (NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_Statement->new);
  }
  elsif ($group_by eq "time")
  {
    return (NO_NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_Time->new);
  }
  elsif ($group_by eq "statement,time")
  {
    return (NO_NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_TimeStatement->new);
  }
  elsif ($group_by eq "statement,table")
  {
    return (NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_TableStatement->new);
  }
  elsif ($group_by eq "table,time")
  {
    return (NO_NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_TimeTable->new);
  }
  elsif ($group_by eq "all" || $group_by eq "statement,table,time")
  {
    return (NO_NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_TimeTableStatement->new);
  }
  elsif ($group_by eq "all,exec" || $group_by eq "exec,statement,table,time")
  {
    return (NO_NEED_FULL_SORT, Ytkit::GroupbyHelper::Groupby_TimeTableStatementExec->new);
  }
  else
  {
    return (undef, undef);
  }
}

sub sort_csv
{
  my ($csv)= @_;
  return join(",", sort(split(/,/, $csv)));
}


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
      my $tmp= sprintf("%s\t%d", $_, $hash->{$_}->{counter});
      $tmp .= sprintf("\ttotal_transaction_size: %d", $hash->{$_}->{transaction_length}) if $hash->{$_}->{transaction_length};
      $tmp .= "\n";

      push(@ret, $tmp);
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
  $self->{$event->{time_string}}->{counter}++;
  $self->{$event->{time_string}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{table}}->{counter}++;
  $self->{$event->{table}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{statement}}->{counter}++;
  $self->{$event->{statement}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{time_string}}->{$event->{statement}}->{counter}++;
  $self->{$event->{time_string}}->{$event->{statement}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{time_string}}->{$event->{table}}->{counter}++;
  $self->{$event->{time_string}}->{$event->{table}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{table}}->{$event->{statement}}->{counter}++;
  $self->{$event->{table}}->{$event->{statement}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}->{counter}++;
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}->{transaction_length} += $event->{transaction_length} // 0;
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
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}->{$event->{exec_time}}->{counter}++;
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}->{$event->{exec_time}}->{transaction_length} += $event->{transaction_length} // 0;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(4);
}
 

return 1;
