#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017, 2018  yoku0825
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

use FindBin qw{$Bin};
use lib "$Bin/../lib";
use Ytkit::HealthCheck;
require "$Bin/Test.pl";

no warnings "once";

my @argv= qw{--role=auto};

### Connection failed.
my $prog= Ytkit::HealthCheck->new(@argv);
is($prog->{status}->{str}, "CRITICAL", "Connection Failed");
is($prog->hostname, "Can't fetch hostname", "Default hostname when connection has failed.");

&reset_param;

subtest "decide_role" => sub
{
  $prog->{instance}->{_show_slave_status}= [];
  $prog->{instance}->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::VAR1;
  is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master without slave)");

  $prog->{instance}->{_show_slave_status}= [];
  $prog->{instance}->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST_WITH_NONGTID_SLAVE::VAR1;
  is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master with non-gtid slaves)");
  
  $prog->{instance}->{_show_slave_status}= [];
  $prog->{instance}->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST_WITH_GTID_SLAVE::VAR1;
  is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS / PROCESSLIST(master with gtid slaves)");

  $prog->{instance}->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;
  $prog->{instance}->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::VAR1;
  is($prog->decide_role, "slave", "decide_role with SHOW SLAVE STATUS / PROCESSLIST(slave)");

  $prog->{instance}->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;
  $prog->{instance}->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST_WITH_NONGTID_SLAVE::VAR1;
  is($prog->decide_role, "intermidiate", "decide_role with SHOW SLAVE STATUS / PROCESSLIST(intermidiate)");

  $prog->clear_cache;
};

subtest "check_long_query" => sub
{
  $prog->{instance}->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::VAR1;

  ### Max query time is 125 (expect of replication threads)

  $prog->{long_query}->{warning}= 10000;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "check_long_query < warning");
  &reset_param;

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "WARNING", "check_long_query between warning and critical");
  &reset_param;

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "CRITICAL", "check_long_query > critical");
  &reset_param;

  ### Excluded by host.
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_host}= ["192.168.0.1"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by host");
  &reset_param;

  ### Excluded by user.
  $prog->{long_query}->{warning}= 5000;
  $prog->{long_query}->{critical}= 5000;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_user}= ["userexclude"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by user");
  &reset_param;

  ### Excluded by SQL
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_query}= ["SELECT SLEEP"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by query");
  &reset_param;

  ### disabled by option
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 0;
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Disabled by --long-query-enable=0");
  &reset_param;

  $prog->clear_cache;
};

subtest "connection_count" => sub
{
  $prog->{instance}->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

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
  $prog->{instance}->{_select_autoinc_usage}   = $Ytkit::Test::AUTOINC_USAGE::VAR1;
 
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

  $prog->{instance}->{_select_autoinc_usage}   = $Ytkit::Test::AUTOINC_USAGE_SIGNED::VAR1;
 
  ### Max autoinc is 10001 on signed smallint(32767), about 30.5% used.
  
  $prog->{autoinc_usage}->{warning}= 30;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "WARNING", "Signed smallint is handled correctly.");
  &reset_param;

  $prog->clear_cache;
};

subtest "read_only" => sub
{
  ### read_only= 0
  $prog->{instance}->{_show_variables}   = $Ytkit::Test::SHOW_VARIABLES::VAR1;
 
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
  $prog->{instance}->{_show_variables}   = $Ytkit::Test::SHOW_VARIABLES_READ_ONLY::VAR1;
 
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
  $prog->{instance}->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;

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

  $prog->{instance}->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_NG::VAR1;

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

subtest "--role=fabric" => sub
{
  $prog->{_query_fabric}= $Ytkit::TEST::Lookup_Groups::VAR1;
  is($prog->query_fabric("lookup_groups", "")->[0]->{group_id}, "myfabric", "Parse group.lookup_groups");

  $prog->{_query_fabric}= $Ytkit::TEST::Group_Health::VAR1;

  foreach my $row (@{$prog->query_fabric("group_health", "myfabric")})
  {
    my $uuid= grep {$row->{uuid} eq $_} qw{bb48b5d4-f1d9-11e7-b79f-40a8f0226cd8 0604c90e-4b59-11e7-b7fb-525400101084 f9536993-4b55-11e7-8791-525400101085};
    is($uuid, 1, "Getting fabric-uuid ");
  }
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

  foreach (qw{long_query connection_count autoinc_usage read_only slave_status})
  {
    delete($prog->{$_});
  }
}

