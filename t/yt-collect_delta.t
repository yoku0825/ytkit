#!/usr/bin/perl

#########################################################################
# Copyright (C) 2018, 2019  yoku0825
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
use Test::More;

use Test::MockTime;
Test::MockTime::set_fixed_time("2023-06-06 12:27:34 +0900", "%Y-%m-%d %H:%M:%S %z");
$ENV{TZ}= "Asia/Tokyo";

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/Test.pl";
Ytkit::Test->import(qw{ read_file });

no warnings "once";

use_ok("Ytkit::Collect");

### Dummy connection
my $prog= Ytkit::Collect->new("--host=localhost");
$prog->{print_header}= 0;

$prog->{delta}= 1;
$prog->{delta_per_second}= 1;
$prog->{interval}= 2;
$prog->{idle_print}= 1;

### Test only Short-style.
$prog->{output}= "short";

subtest "events_statements_summary_by_digest" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

  subtest "--delta_per_second=0" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 0;
 
    $prog->instance->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::BEFORE;
    is($prog->print_query_latency, undef, "First read returns nothing");

    $prog->instance->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::AFTER;
    is_deeply(text2array($prog->print_query_latency),
              text2array(read_file("$Bin/data/r/delta_select_from_ps_digest_into_short_2s.r")),
              "Print Short style");
  };

  subtest "--delta_per_second=1" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 1;
 
    $prog->instance->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::BEFORE;
    is($prog->print_query_latency, undef, "First read returns nothing");

    $prog->instance->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::AFTER;
    is_deeply(text2array($prog->print_query_latency),
              text2array(read_file("$Bin/data/r/delta_select_from_ps_digest_into_short_1s.r")),
              "Print Short style");
  };

  $prog->clear_cache;
  done_testing;
};

subtest "table_io_waits_summary_by_table" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

  subtest "--delta_per_second=0" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 0;

    $prog->instance->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR1;
    is($prog->print_table_latency, undef, "First read returns nothing");

    $prog->instance->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR2;
    is_deeply(text2array($prog->print_table_latency),
              text2array(read_file("$Bin/data/r/delta_select_from_ps_table_into_short_2s.r")),
              "Print Short style");
  };

  subtest "--delta_per_second=1" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 1;

    $prog->instance->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR1;
    is($prog->print_table_latency, undef, "First read returns nothing");

    $prog->instance->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR2;
    is_deeply(text2array($prog->print_table_latency),
              text2array(read_file("$Bin/data/r/delta_select_from_ps_table_into_short_1s.r")),
              "Print Short style");
  };


  $prog->clear_cache;
  done_testing;
};

subtest "SHOW GLOBAL STATUS" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

  subtest "--delta_per_second=0" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 0;
    $prog->instance->{_show_status}= $Ytkit::Test::SHOW_STATUS::VAR1;
    is($prog->print_show_status, undef, "First read returns nothing");

    $prog->instance->{_show_status}= $Ytkit::Test::SHOW_STATUS::VAR2;
    is_deeply(text2array($prog->print_show_status),
              text2array(read_file("$Bin/data/r/delta_show_status_into_short_2s.r")),
              "Print Short style");
  };

  subtest "--delta_per_second=1" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 1;
    $prog->instance->{_show_status}= $Ytkit::Test::SHOW_STATUS::VAR1;
    is($prog->print_show_status, undef, "First read returns nothing");

    $prog->instance->{_show_status}= $Ytkit::Test::SHOW_STATUS::VAR2;
    is_deeply(text2array($prog->print_show_status),
              text2array(read_file("$Bin/data/r/delta_show_status_into_short_1s.r")),
              "Print Short style");
  };

  $prog->clear_cache;
  done_testing;
};

subtest "i_s.innodb_metrics" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

  subtest "--delta_per_second=0" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 0;
    $prog->instance->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR1;
    is($prog->print_innodb_metrics, undef, "First read returns nothing");

    $prog->instance->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR2;
    is_deeply(text2array($prog->print_innodb_metrics),
              text2array(read_file("$Bin/data/r/delta_select_from_is_metrics_into_short_2s.r")),
              "Print Short style");
  };

  subtest "--delta_per_second=1" => sub
  {
    delete($prog->{_previous});
    $prog->{delta_per_second}= 1;
    $prog->instance->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR1;
    is($prog->print_innodb_metrics, undef, "First read returns nothing");

    $prog->instance->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR2;
    is_deeply(text2array($prog->print_innodb_metrics),
              text2array(read_file("$Bin/data/r/delta_select_from_is_metrics_into_short_1s.r")),
              "Print Short style");
  };

  $prog->clear_cache;
  done_testing;
};


done_testing;


exit 0;


sub text2array
{
  my ($text)= @_;
  return [sort(split(/\n/, $text))];
}
