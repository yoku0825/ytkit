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
use JSON qw{ from_json };

use Test::MockTime;
Test::MockTime::set_fixed_time("2018-06-06 12:27:34 +0900", "%Y-%m-%d %H:%M:%S %z");
$ENV{TZ}= "Asia/Tokyo";

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/Test.pl";
Ytkit::Test->import(qw{ read_file });

no warnings "once";

use_ok("Ytkit::Collect");

### Dummy connection
ok(my $prog= Ytkit::Collect->new("--host=localhost"), "Create new");
$prog->{print_header}= 0;

### Fix output-tablename
$prog->{query_latency}->{output_name}= "ps_digest_info";
$prog->{table_latency}->{output_name}= "ps_table_info";
$prog->{table_size}->{output_name}   = "is_table_info";
$prog->{show_grants}->{output_name}  = "user_grants";
$prog->{show_slave}->{output_name} = "slave_status";
$prog->{host}= "163-44-175-117";
$prog->{port}= 64057;


subtest "checking requirements" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  is($prog->is_satisfied_requirement, 1, "Accept MySQL 5.7 && performance_schema = ON");
  $prog->clear_cache;

  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_off;
  is($prog->is_satisfied_requirement, 0, "Reject MySQL 5.7 && performance_schema = OFF");
  $prog->clear_cache;

  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql55_ps_on;
  is($prog->is_satisfied_requirement, 0, "Reject MySQL 5.5 && performance_schema = ON");
  $prog->clear_cache;

  done_testing;
};

subtest "Handling --sql-update, --sql-ignore and --sql-replace by fix_sql_options()" => sub
{
  ### Dummy instance.
  my $prog3= {};
  bless $prog3 => "Ytkit::Collect";

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (1, 0, 0);
  $prog3->fix_sql_options;
  ok($prog3->{sql_update} && !($prog3->{sql_ignore}) && !($prog3->{sql_replace}),
     "Handle only --sql-update");
  $prog3->clear_cache;

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (0, 1, 0);
  $prog3->fix_sql_options;
  ok(!($prog3->{sql_update}) && $prog3->{sql_ignore} && !($prog3->{sql_replace}),
     "Handle only --sql-ignore");
  $prog3->clear_cache;

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (0, 0, 1);
  $prog3->fix_sql_options;
  ok(!($prog3->{sql_update}) && !($prog3->{sql_ignore}) && $prog3->{sql_replace},
     "Handle only --sql-replace");
  $prog3->clear_cache;

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (1, 1, 0);
  $prog3->fix_sql_options;
  ok(!($prog3->{sql_update}) && !($prog3->{sql_ignore}) && !($prog3->{sql_replace}),
     "--sql-update --sql-ignore falls back to simple INSERT INTO");
  $prog3->clear_cache;

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (1, 0, 1);
  $prog3->fix_sql_options;
  ok(!($prog3->{sql_update}) && !($prog3->{sql_ignore}) && !($prog3->{sql_replace}),
     "--sql-update --sql-replace falls back to simple INSERT INTO");
  $prog3->clear_cache;

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (0, 1, 1);
  $prog3->fix_sql_options;
  ok(!($prog3->{sql_update}) && !($prog3->{sql_ignore}) && !($prog3->{sql_replace}),
     "--sql-ignore --sql-replace falls back to simple INSERT INTO");
  $prog3->clear_cache;

  @{$prog3}{qw(sql_update sql_ignore sql_replace)}= (1, 1, 1);
  $prog3->fix_sql_options;
  ok(!($prog3->{sql_update}) && !($prog3->{sql_ignore}) && !($prog3->{sql_replace}),
     "--sql-update --sql-ignore --sql-replace falls back to simple INSERT INTO");
  $prog3->clear_cache;
  done_testing;
};

subtest "events_statements_summary_by_digest" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_query_latency, read_file("$Bin/data/r/select_from_ps_digest_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_query_latency, read_file("$Bin/data/r/select_from_ps_digest_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is_deeply(from_json($prog->print_query_latency),
            from_json(read_file("$Bin/data/r/select_from_ps_digest_into_json.r")),
            "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_query_latency, read_file("$Bin/data/r/select_from_ps_digest_into_sql.r"), "Print SQL style");

  $prog->{output}= "short";
  is($prog->print_query_latency, read_file("$Bin/data/r/select_from_ps_digest_into_short.r"), "Print Short style");

  ### Turn off performance_schema.
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_off;
  is($prog->print_query_latency, undef, "No output when performance_schema = 0");

  $prog->clear_cache;
  done_testing;
};

subtest "table_io_waits_summary_by_table" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_table_latency, read_file("$Bin/data/r/select_from_ps_table_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_table_latency, read_file("$Bin/data/r/select_from_ps_table_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is_deeply(from_json($prog->print_table_latency),
            from_json(read_file("$Bin/data/r/select_from_ps_table_into_json.r")),
            "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_table_latency, read_file("$Bin/data/r/select_from_ps_table_into_sql.r"), "Print SQL style");

  subtest "--output=sql variations" => sub
  {
    my $sql_replace= my $sql_ignore= read_file("$Bin/data/r/select_from_ps_table_into_sql.r");

    $prog->{sql_ignore}= 1;
    $sql_ignore =~ s/INSERT INTO/INSERT IGNORE INTO/;
    is($prog->print_table_latency, $sql_ignore, "Print SQL style with IGNORE");
    delete($prog->{sql_ignore});

    $prog->{sql_replace}= 1;
    $sql_replace =~ s/INSERT INTO/REPLACE INTO/;
    is($prog->print_table_latency, $sql_replace, "Print SQL style with REPLACE");
    delete($prog->{sql_replace});

    $prog->{sql_update}= 1;
    is($prog->print_table_latency,
       read_file("$Bin/data/r/select_from_ps_table_into_sql_dup_key.r"),
       "Print SQL stype with ON DUPLICATE KEY UPDATE");
    delete($prog->{sql_update});

    done_testing;
  };

  $prog->{output}= "short";
  is($prog->print_table_latency, read_file("$Bin/data/r/select_from_ps_table_into_short.r"), "Print Short style");

  ### Turn off performance_schema.
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_off;
  is($prog->print_table_latency, undef, "No output when performance_schema = 0");

  $prog->clear_cache;
  done_testing;
};

subtest "i_s.tables" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_select_is_table_by_size}= $Ytkit::Test::SELECT_FROM_is_table::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_table_size, read_file("$Bin/data/r/select_from_is_table_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_table_size, read_file("$Bin/data/r/select_from_is_table_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is_deeply(from_json($prog->print_table_size),
            from_json(read_file("$Bin/data/r/select_from_is_table_into_json.r")),
            "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_table_size, read_file("$Bin/data/r/select_from_is_table_into_sql.r"), "Print SQL style");

  $prog->{output}= "short";
  is($prog->print_table_size, undef, "Print Short style is unsupported.");

  ### innodb_stats_on_metadata = ON
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::STATS_ON_METADATA_IS_ON;
  is($prog->print_table_size, undef, "No output when innodb_stats_on_metadata = 1");
  $prog->clear_cache;
  done_testing;
};

#subtest "SHOW GLOBAL STATUS" => sub
#{
#  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
#  $prog->instance->{_show_status}= $Ytkit::Test::SHOW_STATUS::VAR1;
#
#  $prog->clear_cache;
#  done_testing;
#};

#subtest "i_s.innodb_metrics" => sub
#{
#  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
#  $prog->instance->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR1;
#
#  $prog->clear_cache;
#  done_testing;
#};

subtest "user_grants" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_select_user_list}= $Ytkit::Test::SELECT_user_list::one_user;

  ### show_grants clears cache each time.
  $prog->instance->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "tsv";
  is($prog->print_show_grants, read_file("$Bin/data/r/show_grants_into_tsv.r"), "Print TSV style");

  $prog->instance->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "csv";
  is($prog->print_show_grants, read_file("$Bin/data/r/show_grants_into_csv.r"), "Print CSV style");

  $prog->instance->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "json";
  is_deeply(from_json($prog->print_show_grants),
            from_json(read_file("$Bin/data/r/show_grants_into_json.r")),
            "Print JSON style");

  $prog->instance->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "sql";
  is($prog->print_show_grants, read_file("$Bin/data/r/show_grants_into_sql.r"), "Print SQL style");

  $prog->instance->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "short";
  is($prog->print_show_grants, undef, "Print SQL style is unsupported.");
};

#subtest "SHOW GLOBAL VARIABLES" => sub
#{
#  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
#
#  $prog->clear_cache;
#  done_testing;
#};

subtest "SHOW SLAVE STATUS" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;

  $prog->{output}= "tsv";
  is($prog->print_show_slave, read_file("$Bin/data/r/show_slave_status_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_show_slave, read_file("$Bin/data/r/show_slave_status_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is_deeply(from_json($prog->print_show_slave),
            from_json(read_file("$Bin/data/r/show_slave_status_into_json.r")),
            "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_show_slave, read_file("$Bin/data/r/show_slave_status_into_sql.r"), "Print SQL style");

  $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::with_channel;
  is($prog->print_show_slave,
     read_file("$Bin/data/r/show_slave_status_with_channel_into_sql.r"),
     "Print SQL style (With channel)");

  $prog->{output}= "short";
  is($prog->print_show_slave, undef, "Print Short style is unsupported.");

  $prog->clear_cache;
  done_testing;
};

subtest "config description" => sub
{
  my $prog2= Ytkit::Collect->new;
  unlike($prog2->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;


exit 0;
