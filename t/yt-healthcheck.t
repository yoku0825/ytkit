#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017, 2021  yoku0825
# Copyright (C) 2018        hacchuu0119
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
Test::MockTime::set_fixed_time("2018-06-06 12:27:34 +0900", "%Y-%m-%d %H:%M:%S %z");

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/Test.pl";
use Ytkit::HealthCheck qw{ NAGIOS_OK };

no warnings "once";

use_ok("Ytkit::HealthCheck");

my @argv= qw{ --role=auto --host=127.0.0.1 };

### Connection failed.
my $prog= Ytkit::HealthCheck->new(@argv);
is($prog->{status}->{str}, "CRITICAL", "Connection Failed");
is($prog->instance->hostname, "127.0.0.1", "Default hostname when connection has failed.");

&reset_param;

subtest "decide_role" => sub
{
  subtest "Not in Group Replication" => sub
  {
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number
    $prog->instance->{_replication_group_members}= [];  ### Not in Group Replication

    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_slave;
    is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master without slave)");
  
    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_nongtid;
    is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master with non-gtid slaves)");
    
    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_gtid;
    is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master with gtid slaves)");
  
    $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_slave;
    is($prog->decide_role, "slave", "decide_role with SHOW SLAVE STATUS / PROCESSLIST(slave)");
  
    $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_nongtid;
    is($prog->decide_role, "intermidiate", "decide_role with SHOW SLAVE STATUS / PROCESSLIST(intermidiate)");
  
    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_slave;
    is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master without slave)");

    $prog->clear_cache;
    done_testing;
  };

  subtest "In Group Replication" => sub
  {
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number
    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3;

    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_slave;
    is($prog->decide_role, "innodb_cluster",
       "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master without slave) + Group Replication");
  
    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_nongtid;
    is($prog->decide_role, "innodb_cluster",
       "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master with non-gtid slaves) + Group Replication");
    
    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_gtid;
    is($prog->decide_role, "innodb_cluster",
       "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master with gtid slaves) + Group Replication");
  
    $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_slave;
    is($prog->decide_role, "slave",
       "decide_role with SHOW SLAVE STATUS / PROCESSLIST(slave) + Group Replication");
  
    $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_nongtid;
    is($prog->decide_role, "intermidiate",
       "decide_role with SHOW SLAVE STATUS / PROCESSLIST(intermidiate) + Group Replication");
  
    $prog->instance->{_show_slave_status}= [];
    $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_slave;
    is($prog->decide_role, "innodb_cluster",
       "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master without slave) + Group Replication");

    $prog->clear_cache;
    done_testing;
  };
  done_testing;
};

subtest "check_long_query" => sub
{
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_6000;

  ### Max query time is 125 (expect of replication threads)

  $prog->{long_query}->{warning}= 10000;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "check_long_query < warning");
  &reset_param;

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "WARNING", "check_long_query between warning and critical");
  &reset_param;

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "CRITICAL", "check_long_query > critical");
  &reset_param;

  ### Excluded by host.
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_host}= ["192.168.0.1"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by host");
  &reset_param;

  ### Excluded by user.
  $prog->{long_query}->{warning}= 5000;
  $prog->{long_query}->{critical}= 5000;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_user}= ["userexclude"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by user");
  &reset_param;

  ### Excluded by SQL
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_query}= ["SELECT SLEEP"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by query");
  &reset_param;

  ### disabled by option
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{min_warning_thread}= 1;
  $prog->{long_query}->{min_critical_thread}= 1;
  $prog->{long_query}->{enable}= 0;
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Disabled by --long-query-enable=0");
  &reset_param;

  $prog->clear_cache;
};

subtest "long_query with threads" => sub
{
  $prog->{long_query}->{warning}= 900;
  $prog->{long_query}->{min_warning_thread}= 4;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{min_critical_thread}= 1000;
  $prog->{long_query}->{enable}= 1;

  ### time > long_query_warning but count < min_warning_thread
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_6000;
  $prog->check_long_query;
  ### 1000 => warn, 6000 => warn & crit, then warn_count = 2, crit_count = 1
  is($prog->{status}->{str}, "OK", "check_long_query > warning but count < min_warning_thread");

  ### time > long_query_warning and count = min_warning_thread
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_1000_6000_6000;
  $prog->check_long_query;
  ### 1000 => warn * 2, 6000 => warn & crit * 2, then warn_count = 4, crit_count = 2
  is($prog->{status}->{str}, "WARNING", "check_long_query > warning and count = min_warning_threads");

  ### time > long_query_warning and count > min_warning_thread
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_1000_1000_6000_6000_6000;
  $prog->check_long_query;
  ### 1000 => warn * 3, 6000 => warn & crit * 3, then warn_count = 6, crit_count = 3
  is($prog->{status}->{str}, "WARNING", "check_long_query > warning and count > min_warning_threads");

  &reset_param;

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{min_warning_thread}= 2;
  $prog->{long_query}->{critical}= 1500;
  $prog->{long_query}->{min_critical_thread}= 2;
  $prog->{long_query}->{enable}= 1;

  ### time > long_query_critical but count < min_critical_thread
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_6000;
  $prog->check_long_query;
  ### 1000 => warn, 6000 => warn & crit, then warn_count = 2, crit_count = 1
  is($prog->{status}->{str}, "WARNING", "check_long_query > critical but count < min_critical_thread");

  ### time > long_query_critical and count = min_critical_thread
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_1000_6000_6000;
  $prog->check_long_query;
  ### 1000 => warn * 2, 6000 => warn & crit * 2, then warn_count = 4, crit_count = 2
  is($prog->{status}->{str}, "CRITICAL", "check_long_query > critical and count = min_critical_threads");

  ### time > long_query_critical and count > min_critical_thread
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_1000_1000_6000_6000_6000;
  ### 1000 => warn * 3, 6000 => warn & crit * 3, then warn_count = 6, crit_count = 3
  $prog->check_long_query;
  is($prog->{status}->{str}, "CRITICAL", "check_long_query > critical and count > min_critical_threads");


  &reset_param;
  $prog->{long_query}->{warning}= 1000;
  $prog->{long_query}->{min_warning_thread}= 2;
  $prog->{long_query}->{critical}= 5000;
  $prog->{long_query}->{min_critical_thread}= 4;
  $prog->{long_query}->{enable}= 1;

  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_1000_6000_6000;
  $prog->check_long_query;
  is($prog->{status}->{str}, "WARNING", "warning thread= 4(warn 2 + crit 2) AND critical thread= 2");

  &reset_param;
  done_testing;
};

subtest "connection_count" => sub
{
  $prog->instance->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

  ### max_connections= 151 and Threads_connected= 102, about 67.5% used.

  $prog->{connection_count}->{warning}= 80;
  $prog->{connection_count}->{critical}= 100;
  $prog->{connection_count}->{enable}= 1;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "OK", "connections < warning");
  &reset_param;

  $prog->{connection_count}->{warning}= 60;
  $prog->{connection_count}->{critical}= 100;
  $prog->{connection_count}->{enable}= 1;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "WARNING", "connections between warning and critical");
  &reset_param;

  $prog->{connection_count}->{warning}= 60;
  $prog->{connection_count}->{critical}= 60;
  $prog->{connection_count}->{enable}= 1;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "CRITICAL", "connections > critical");
  &reset_param;

  $prog->{connection_count}->{warning}= 60;
  $prog->{connection_count}->{critical}= 60;
  $prog->{connection_count}->{enable}= 0;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "OK", "Disabled by --connection-count-enable=0");
  &reset_param;

  $prog->clear_cache;
};

subtest "autoinc_usage" => sub
{
  $prog->instance->{_show_variables}      = $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_select_autoinc_usage}= $Ytkit::Test::AUTOINC_USAGE::UNSIGNED;
 
  ### Max autoinc is 10001 on unsigned smallint(65535), about 15.2% used.
  
  $prog->{autoinc_usage}->{warning}= 50;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "OK", "autoinc_usage < warning");
  &reset_param;

  $prog->{autoinc_usage}->{warning}= 10;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "WARNING", "autoinc_usage between warning and critical");
  &reset_param;

  $prog->{autoinc_usage}->{warning}= 10;
  $prog->{autoinc_usage}->{critical}= 15;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "CRITICAL", "autoinc_usage > critical");
  &reset_param;

  $prog->{autoinc_usage}->{warning}= 10;
  $prog->{autoinc_usage}->{critical}= 15;
  $prog->{autoinc_usage}->{enable}= 0;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "OK", "Disabled by --autoinc-usage-enable=0");
  &reset_param;

  $prog->clear_cache;

  $prog->instance->{_show_variables}      = $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->instance->{_select_autoinc_usage}   = $Ytkit::Test::AUTOINC_USAGE::SIGNED;
 
  ### Max autoinc is 10001 on signed smallint(32767), about 30.5% used.
  
  $prog->{autoinc_usage}->{warning}= 30;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "WARNING", "Signed smallint is handled correctly.");
  &reset_param;

  $prog->clear_cache;

  ### Max autoinc is 10001 on signed smallint(32767), about 30.5% used but innodb_stats_on_metadata = ON
  $prog->instance->{_show_variables}      = $Ytkit::Test::SHOW_VARIABLES::STATS_ON_METADATA_IS_ON;
  $prog->instance->{_select_autoinc_usage}   = $Ytkit::Test::AUTOINC_USAGE::SIGNED;
  $prog->{autoinc_usage}->{warning}= 50;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "WARNING", "innodb_stats_on_metadata = ON");

  &reset_param;
  $prog->clear_cache;
};

subtest "read_only" => sub
{
  ### read_only= 0
  $prog->instance->{_show_variables}   = $Ytkit::Test::SHOW_VARIABLES::VAR1;
 
  $prog->{read_only}->{should_be}= 1; ### For slaves.
  $prog->check_read_only;
  is($prog->{status}->{str}, "WARNING", "Slave is expected read_only= 1 but not");
  &reset_param;

  $prog->{read_only}->{should_be}= 0; ### For master.
  $prog->check_read_only;
  is($prog->{status}->{str}, "OK", "Master is expected read_only= 0 and correct");
  &reset_param;

  $prog->clear_cache;

  ### read_only= 1
  $prog->instance->{_show_variables}   = $Ytkit::Test::SHOW_VARIABLES::read_only;
 
  $prog->{read_only}->{should_be}= 1; ### For slaves.
  $prog->check_read_only;
  is($prog->{status}->{str}, "OK", "Slave is expected read_only= 1 and correct");
  &reset_param;

  $prog->{read_only}->{should_be}= 0; ### For master.
  $prog->check_read_only;
  is($prog->{status}->{str}, "CRITICAL", "Master is expected read_only= 0 but not");
  &reset_param;

  $prog->clear_cache;
};

subtest "slave_status" => sub
{
  $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;

  ### I/O Running and SQL Running are "YES", Seconds_Behind_Master is 43.
 
  $prog->{slave_status}->{warning}= 100;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "OK", "slave_status < warning");
  &reset_param;

  $prog->{slave_status}->{warning}= 10;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "WARNING", "slave_status between warning and critical");
  &reset_param;

  $prog->{slave_status}->{warning}= 10;
  $prog->{slave_status}->{critical}= 15;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "CRITICAL", "slave_status > critical");
  &reset_param;

  $prog->clear_cache;

  $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::NG;

  ### SQL Running is "NO", always should be CRITICAL
 
  $prog->{slave_status}->{warning}= 100;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "CRITICAL", "SQL Thread is not running");
  &reset_param;

  $prog->{slave_status}->{warning}= 100;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 0;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "OK", "Disabled by --slave-status-enable=0");
  &reset_param;
  $prog->clear_cache;
};

subtest "--gtid-hole" => sub
{
  $prog->{gtid_hole}->{enable}= 1;
  $prog->instance->{_show_master_status}= $Ytkit::Test::SHOW_MASTER_STATUS::VAR1;
  $prog->check_gtid_hole;
  is($prog->{status}->{str}, "OK", "There's no gtid_hole");
  &reset_param;
  $prog->clear_cache;

  $prog->{gtid_hole}->{enable}= 1;
  $prog->instance->{_show_master_status}= $Ytkit::Test::GTID_EXECUTED_HOLE::VAR1;
  $prog->check_gtid_hole;
  is($prog->{status}->{str}, "WARNING", "There's gtid_hole");
  &reset_param;
  $prog->clear_cache;

  $prog->{gtid_hole}->{enable}= 0;
  $prog->instance->{_show_master_status}= $Ytkit::Test::GTID_EXECUTED_HOLE::VAR1;
  $prog->check_gtid_hole;
  is($prog->{status}->{str}, "OK", "--gtid-hole-enable=0");
  &reset_param;
  $prog->clear_cache;

  done_testing;
};

subtest "--role=fabric" => sub
{
  subtest "mikasafabric < 0.6.10 compatible check" => sub
  {
    $prog->{"_group.lookup_groups"}= $Ytkit::TEST::Lookup_Groups::VAR1;
    is($prog->query_fabric("group.lookup_groups", "")->[0]->{group_id}, "myfabric", "Parse group.lookup_groups");

    $prog->{"_group.health"}= $Ytkit::TEST::Group_Health::VAR1;

    foreach my $row (@{$prog->query_fabric("group.health", "myfabric")})
    {
      my $uuid= grep {$row->{uuid} eq $_} qw{bb48b5d4-f1d9-11e7-b79f-40a8f0226cd8 0604c90e-4b59-11e7-b7fb-525400101084 f9536993-4b55-11e7-8791-525400101085};
      is($uuid, 1, "Getting fabric-uuid ");
    }
    &reset_param;
    $prog->clear_cache;
    done_testing;
  };

  subtest "mikasafabric 0.6.10 and later has dump.health command" => sub
  {
    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::NO_FAULTY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "critical";
    $prog->check_fabric;
    is($prog->{status}->{str}, "OK", "Fabric OK");
    &reset_param;
    $prog->clear_cache;

    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::WITH_FAULTY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "critical";
    $prog->check_fabric;
    is($prog->{status}->{str}, "CRITICAL", "--fabric_faulty=critical and there's faulty_server");
    &reset_param;
    $prog->clear_cache;

    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::WITH_FAULTY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "warning";
    $prog->check_fabric;
    is($prog->{status}->{str}, "WARNING", "--fabric_faulty=warning and there's faulty_server");
    &reset_param;
    $prog->clear_cache;

    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::NO_PRIMARY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "warning";
    $prog->check_fabric;
    is($prog->{status}->{str}, "CRITICAL", "Group has no PRIMARY");
    &reset_param;
    $prog->clear_cache;

    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::NO_SECONDARY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "warning";
    $prog->check_fabric;
    is($prog->{status}->{str}, "CRITICAL", "Group has no SECONDARY");
    &reset_param;
    $prog->clear_cache;

    ### openfds 65/1024
    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::NO_FAULTY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "critical";
    $prog->{fabric_fd}->{warning}= 1;  ### percent.
    $prog->{fabric_fd}->{critical}= 90;  ### percent.
    $prog->check_fabric;
    is($prog->{status}->{str}, "WARNING", "OpenFDs between --fabric-fd-waning and --fabric-fd-critical");
    &reset_param;
    $prog->clear_cache;

    ### openfds 65/1024
    $prog->{"_dump.health"}   = $Ytkit::Test::DUMP_HEALTH::NO_FAULTY;
    $prog->{"_manage.openfds"}= $Ytkit::Test::MANAGE_OPENFDS::VAR1;
    $prog->{fabric_faulty}= "critical";
    $prog->{fabric_fd}->{warning}= 1;  ### percent.
    $prog->{fabric_fd}->{critical}= 2;  ### percent.
    $prog->check_fabric;
    is($prog->{status}->{str}, "CRITICAL", "OpenFDs over --fabric-fd-critical");
    &reset_param;
    $prog->clear_cache;

    done_testing;
  };
};

subtest "checking offline_mode" => sub
{
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  ok(!($prog->check_offline_mode), "offline_mode = 0");

  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::OFFLINE_MODE;
  ok($prog->check_offline_mode, "offline_mode = 1");
  &reset_param;
  $prog->clear_cache;

  done_testing;
};

subtest "Parse SHOW ENGINE INNODB STATUS" => sub
{

  $prog->instance->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql57;
  $prog->{deadlock}->{enable}= 1;
  $prog->{deadlock}->{warning}= 300;
  $prog->{deadlock}->{critical}= 60;

  ### Test data LATEST DEADLOCK is "2019-07-11 18:33:38"

  Test::MockTime::set_fixed_time("2019-07-11 18:34:37 +0900", "%Y-%m-%d %H:%M:%S %z");
  $prog->check_latest_deadlock;
  is($prog->{status}->{str}, "CRITICAL", "LATEST DETECTED DEADLOCK occurs last 60 seconds");
  &reset_param;

  Test::MockTime::set_fixed_time("2019-07-11 18:34:39 +0900", "%Y-%m-%d %H:%M:%S %z");
  $prog->check_latest_deadlock;
  is($prog->{status}->{str}, "WARNING", "LATEST DETECTED DEADLOCK occurs last 300 seconds");
  &reset_param;

  Test::MockTime::set_fixed_time("2019-07-12 18:34:39 +0900", "%Y-%m-%d %H:%M:%S %z");
  $prog->check_latest_deadlock;
  is($prog->{status}->{str}, "OK", "LATEST DETECTED DEADLOCK does not occur last 300 seconds");
  &reset_param;

  Test::MockTime::set_fixed_time("2019-07-11 18:34:37 +0900", "%Y-%m-%d %H:%M:%S %z");
  $prog->{deadlock}->{enable}= 0;
  $prog->check_latest_deadlock;
  is($prog->{status}->{str}, "OK", "LATEST DETECTED DEADLOCK occur last 60 seconds but deadlock_enable is OFF");
  &reset_param;

  $prog->{deadlock}->{enable}= 1;
  $prog->instance->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql57_no_deadlock;
  Test::MockTime::set_fixed_time("2019-07-11 18:34:37 +0900", "%Y-%m-%d %H:%M:%S %z");
  $prog->check_latest_deadlock;
  is($prog->{status}->{str}, "OK", "LATEST DETECTED DEADLOCK does not occur");
  &reset_param;

  $prog->clear_cache;

  done_testing;
};

subtest "check uptime" => sub
{
  ### uptime = 404684
  $prog->instance->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;

  $prog->{uptime}->{warning}= 10000000;
  $prog->{uptime}->{critical}= 1000000;
  $prog->{uptime}->{enable}= 1;
  $prog->check_uptime;
  is($prog->{status}->{str}, "CRITICAL", "uptime < critical");
  &reset_param;

  $prog->{uptime}->{warning}= 10000000;
  $prog->{uptime}->{critical}= 400000;
  $prog->{uptime}->{enable}= 1;
  $prog->check_uptime;
  is($prog->{status}->{str}, "WARNING", "uptime < warning");
  &reset_param;

  $prog->{uptime}->{warning}= 80;
  $prog->{uptime}->{critical}= 100;
  $prog->{uptime}->{enable}= 1;
  $prog->check_uptime;
  is($prog->{status}->{str}, "OK", "uptime > critical and warning");
  &reset_param;

  done_testing;
};

subtest "check history_list_length" => sub
{
  ### history_list_length = 21
  $prog->instance->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR1;
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1; ### For version number

  $prog->{history_list}->{warning}= 10000000;
  $prog->{history_list}->{critical}= 1000000;
  $prog->{history_list}->{enable}= 1;
  $prog->check_history_list_length;
  is($prog->{status}->{str}, "OK", "history_list_length < warning");
  &reset_param;

  $prog->{history_list}->{warning}= 10;
  $prog->{history_list}->{critical}= 1000000;
  $prog->{history_list}->{enable}= 1;
  $prog->check_history_list_length;
  is($prog->{status}->{str}, "WARNING", "history_list_length > warning");
  &reset_param;

  $prog->{history_list}->{warning}= 10;
  $prog->{history_list}->{critical}= 20;
  $prog->{history_list}->{enable}= 1;
  $prog->check_history_list_length;
  is($prog->{status}->{str}, "CRITICAL", "history_list_length > critical");
  &reset_param;

  $prog->{history_list}->{warning}= 10;
  $prog->{history_list}->{critical}= 20;
  $prog->{history_list}->{enable}= 0;
  $prog->check_history_list_length;
  is($prog->{status}->{str}, "OK", "Disabled");
  &reset_param;

  done_testing;
};

subtest "--role=innodb_cluster" => sub 
{
  $prog->instance->{_version}= undef; ### Clear cache
  subtest "check_innodb_cluster_node_count" => sub
  {
    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "OK", "Group Replication 3 ONLINE nodes.");
    &reset_param;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online2_unreach1;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "WARNING", "Group Replication 2 ONLINE nodes.");
    &reset_param;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online2;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "WARNING", "Group Replication 2 ONLINE nodes.");
    &reset_param;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online1_unreach2;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "CRITICAL", "Group Replication 1 ONLINE nodes.");
    &reset_param;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::offline1;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "CRITICAL", "Group Replication 1 ONLINE nodes.");
    &reset_param;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3_recovering1;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "WARNING", "Group Replication 3 ONLINE nodes but I'm RECOVERING state.");
    &reset_param;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online1_recovering2;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number

    $prog->check_innodb_cluster_node_count;
    is($prog->{status}->{str}, "CRITICAL", "Group Replication 1 ONLINE nodes (+ I'm RECOVERING state.)");
    &reset_param;

    done_testing;
  };

  subtest "check_innodb_cluster_replica_lag" => sub
  {
    $prog->{group_replication_lag_enable}= 1;
    $prog->{group_replication_lag_seconds}->{warning}= 10;
    $prog->{group_replication_lag_seconds}->{critical}= 20;
    $prog->{group_replication_lag_transactions}->{warning}= 1000;
    $prog->{group_replication_lag_transactions}->{critical}= 2000;

    $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3;
    $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number
    subtest "transactions OK" => sub
    {
      $prog->instance->{_replication_group_member_stats}= $Ytkit::Test::SELECT_FROM_ps_repl_group_member_stats::all_synced;

      subtest "group_replication_recovery not working" => sub
      {
        $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_working_fine;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "OK", "Trx: OK, Recovery: OK, Applier: OK");
        &reset_param;

        $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_11s_lag;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "WARNING", "Trx: OK, Recovery: OK, Applier: WARNING");
        &reset_param;
  
        $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_21s_lag;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "CRITICAL", "Trx: OK, Recovery: OK, Applier: CRITICAL");
        &reset_param;
  
        $prog->{group_replication_lag_enable}= 0;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "OK", "--group-replication-lag-enable=0");
        &reset_param;
  
        $prog->{group_replication_lag_enable}= 1;
        done_testing;
      };

      subtest "group_replication_recovery working" => sub
      {
        $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::recovery_1s_lag;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "OK", "Trx: OK, Recovery: OK, Applier: OK");
        &reset_param;

        $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::recovery_11s_lag;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "WARNING", "Trx: OK, Recovery: OK, Applier: WARNING");
        &reset_param;
  
        $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::recovery_21s_lag;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "CRITICAL", "Trx: OK, Recovery: OK, Applier: CRITICAL");
        &reset_param;
  
        $prog->{group_replication_lag_enable}= 0;
        $prog->check_innodb_cluster_replica_lag;
        is($prog->{status}->{str}, "OK", "--group-replication-lag-enable=0");
        &reset_param;
  
        $prog->{group_replication_lag_enable}= 1;
        done_testing;
      };

      done_testing;
    };

    subtest "transactions WARNING" => sub
    {
      $prog->instance->{_replication_group_member_stats}= $Ytkit::Test::SELECT_FROM_ps_repl_group_member_stats::behind_1001;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_working_fine;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "WARNING", "Trx: WARNING, Recovery: OK, Applier: OK");
      &reset_param;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_11s_lag;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "WARNING", "Trx: WARNING, Recovery: OK, Applier: WARNING");
      &reset_param;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_21s_lag;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "CRITICAL", "Trx: WARNING, Recovery: OK, Applier: CRITICAL");
      &reset_param;

      $prog->{group_replication_lag_enable}= 0;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "OK", "--group-replication-lag-enable=0");
      &reset_param;

      $prog->{group_replication_lag_enable}= 1;
      done_testing;
    };

    subtest "transactions CRITICAL" => sub
    {
      $prog->instance->{_replication_group_member_stats}= $Ytkit::Test::SELECT_FROM_ps_repl_group_member_stats::behind_2001;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_working_fine;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "CRITICAL", "Trx: CRITICAL, Recovery: OK, Applier: OK");
      &reset_param;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_11s_lag;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "CRITICAL", "Trx: CRITICAL, Recovery: OK, Applier: WARNING");
      &reset_param;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_21s_lag;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "CRITICAL", "Trx: CRITICAL, Recovery: OK, Applier: CRITICAL");
      &reset_param;

      $prog->{group_replication_lag_enable}= 0;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "OK", "--group-replication-lag-enable=0");
      &reset_param;

      $prog->{group_replication_lag_enable}= 1;
      done_testing;
    };

    subtest "WARNING if RECOVERING state" => sub
    {
      $prog->instance->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3_recovering1;
      $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80; ### For version number
      $prog->instance->{_replication_group_member_stats}= $Ytkit::Test::SELECT_FROM_ps_repl_group_member_stats::all_synced;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_working_fine;
      $prog->check_innodb_cluster_replica_lag;
      ### check_innodb_cluster_replica_lag itself does not depend on RECOVERING state.
      is($prog->{status}->{str}, "OK", "Trx: OK, Recovery: OK, Applier: OK, state: RECOVERING");
      &reset_param;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_11s_lag;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "WARNING", "Trx: OK, Recovery: OK, Applier: WARNING, state: RECOVERING");
      &reset_param;

      $prog->instance->{_replication_applier_status}= $Ytkit::Test::SELECT_FROM_ps_repl_applier_status::applier_21s_lag;
      $prog->check_innodb_cluster_replica_lag;
      ### Falling back WARNING
      is($prog->{status}->{str}, "WARNING", "Trx: OK, Recovery: OK, Applier: CRITICAL, state: RECOVERING");
      &reset_param;

      $prog->{group_replication_lag_enable}= 0;
      $prog->check_innodb_cluster_replica_lag;
      is($prog->{status}->{str}, "OK", "--group-replication-lag-enable=0");
      &reset_param;

      $prog->{group_replication_lag_enable}= 1;
      done_testing;
    };

    done_testing;
  };
  &reset_param;
  done_testing;
};

subtest "Issue 40" => sub
{
  $prog->instance->{_version}= undef;
  $prog->instance->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on; ### For version number
  $prog->{autoinc_usage}->{warning}= 50;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;

  ### MySQL 8.0.18 and earlier, "bigint(20) unsigned" style.
  $prog->instance->{_select_autoinc_usage}= $Ytkit::Test::ISSUE40::before8019;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "OK", "8.0.18 and earlier style");

  ### MySQL 8.0.19 and later, "bigint unsigned" style.
  $prog->instance->{_select_autoinc_usage}= $Ytkit::Test::ISSUE40::after8019;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "OK", "8.0.19 and later style");

  &reset_param;
  done_testing;
};


subtest "config description" => sub
{
  unlike($prog->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;


exit 0;

sub reset_param
{
  $prog->{status}= Ytkit::HealthCheck::NAGIOS_OK;
  $prog->{output}= "";

  foreach (qw{long_query connection_count autoinc_usage read_only slave_status gtid_hole history_list})
  {
    delete($prog->{$_});
  }
}

