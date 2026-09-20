package Ytkit::TopHelper;

########################################################################
# Copyright (C) 2026  yoku0825
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


sub trim_per_sec
{
  my ($one_row, $trim_column_array)= @_;

  ### $digest_info=
  ### [
  ###   {
  ###     'last_update' => '2026-09-17 01:27:22',
  ###     'ipaddr' => 'localhost',
  ###     'port' => 3306,
  ###     'sum_timer_wait' => '410057000/s',
  ###     'schema_name.digest_text' => 'xxx',
  ###     'count_star' => '1/s'
  ###   },
  ###   {
  ###     'count_star' => '2/s',
  ###     'schema_name.digest_text' => 'NULL.SELECT ?',
  ###     'sum_timer_wait' => '208349000/s',
  ###     'port' => 3306,
  ###     'ipaddr' => 'localhost',
  ###     'last_update' => '2026-09-17 01:27:22'
  ###   }
  ### ];

  my $ret= {};
  foreach my $column (keys(%$one_row))
  {
    if (grep { $column } @$trim_column_array)
    {
      my ($value)= $one_row->{$column} =~ /(\d+)/;
      $ret->{$column}= $value;
    }
    else
    {
      $ret->{$column}= $one_row->{$column};
    }
  }
  return $ret;
}

sub sort_result_by
{
  my ($buff, $order_by)= @_;
  my $ret;

  foreach (@$buff)
  {
    if (defined($_->{$order_by}))
    {
      push(@{$ret->{$_->{$order_by}}}, $_);
    }
    else
    {
      $ret->{$_->{order_by}}= [$_];
    }
  }
  return $ret; 
}


return 1;
