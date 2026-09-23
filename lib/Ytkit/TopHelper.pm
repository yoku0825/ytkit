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

use base "Exporter";
our @EXPORT= qw{ trim_per_sec sort_result_by trim_for_terminal_size repeat_term_size sprint_top_header };

use JSON qw{ from_json };
use Ytkit::IO;
use Term::ReadKey;

my ($width, $height, $width_pixels, $height_pixels) = GetTerminalSize();

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
      $ret->{$_->{$order_by}}= [$_];
    }
  }
  return $ret; 
}

sub trim_for_terminal_size
{
  my ($string)= @_;

  ### Trim if not --verbose
  return substr($string, 0, $ENV{ytkit_verbose} >= Ytkit::IO::VERBOSE ? length($string) : $width - int($width / 10));
}

sub repeat_term_size
{
  my ($char)= @_;

  return join("", map { $_ } $char x $width);
}

sub sprint_top_header
{
  my ($collect)= @_;

  my $status_json= $collect->print_show_status;
  if (!($status_json))
  {
    ### $status_json is Empty means there's no delta
    delete $collect->instance->{_show_status};   ### Remove cache
    $status_json= $collect->print_show_status;
  }
  my $qps = 0;
  foreach (@{from_json($status_json)->{status_info}})
  {
    if ($_->{variable_name} eq "Queries")
    {
      $qps = $_->{value};
      last;
    }
  }

  return sprintf("%s (%s)\t%d / %d connections\tQPS %s\t%d Threads_running",
                 $collect->instance->hostname, $collect->instance->valueof("read_only") eq "ON" ? "READ-ONLY" : "READ-WRITE", 
                 $collect->instance->valueof("Threads_connected"), $collect->instance->valueof("max_connections"),
                 $qps,
                 $collect->instance->valueof("Threads_running"));
  
}

return 1;
