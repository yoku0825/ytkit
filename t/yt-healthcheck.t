#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017, 2018  yoku0825
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
use Test::More::Color qw{foreground};

use FindBin qw{$Bin};
use lib "$Bin/../lib";
use Ytkit::HealthCheck;

no warnings "once";

my @argv= qw{--role=auto};

### Connection failed.
my $prog=Ytkit::HealthCheck->new(@argv);
is($prog->{status}->{str}, "CRITICAL", "Connection Failed");
is($prog->hostname, "Can't fetch hostname", "Default hostname when connection has failed.");

### Imitate "connection is alive"
&clear_status;

subtest "decide_role" => sub
{
  $prog->{_show_slave_status}= [];
  is($prog->decide_role, "master", "decide_role with blank SHOW SLAVE STATUS");
  
  require "$Bin/data/06_show_slave_status_ok.txt";
  $prog->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;
  is($prog->decide_role, "slave", "decide_role with SHOW SLAVE STATUS");
};

subtest "check_long_query" => sub
{
  require "$Bin/data/06_show_processlist.txt";
  $prog->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::VAR1;

  ### Max query time is 125 (expect of replication threads)

  $prog->{long_query}->{warning}= 10000;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "check_long_query < warning");
  &clear_status;
  delete($prog->{long_query});

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 10000;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "WARNING", "check_long_query between warning and critical");
  &clear_status;
  delete($prog->{long_query});

  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 1;
  $prog->check_long_query;
  is($prog->{status}->{str}, "CRITICAL", "check_long_query > critical");
  &clear_status;
  delete($prog->{long_query});

  ### Excluded by host.
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_host}= ["localhost"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by host");
  &clear_status;
  delete($prog->{long_query});

  ### Excluded by SQL
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 1;
  $prog->{long_query}->{exclude_query}= ["SELECT SLEEP"];
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Time was exceeded but excluded by query");
  &clear_status;
  delete($prog->{long_query});

  ### disabled by option
  $prog->{long_query}->{warning}= 100;
  $prog->{long_query}->{critical}= 100;
  $prog->{long_query}->{enable}= 0;
  $prog->check_long_query;
  is($prog->{status}->{str}, "OK", "Disabled by --long-query-enable=0");
  &clear_status;
  delete($prog->{long_query});

  delete($prog->{_show_processlist});
};

subtest "connection_count" => sub
{
  require "$Bin/data/06_show_status.txt";
  require "$Bin/data/06_show_variables.txt";
  $prog->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;
  $prog->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;

  ### max_connections= 151 and Threads_connected= 102, about 67.5% used.

  $prog->{connection_count}->{warning}= 80;
  $prog->{connection_count}->{critical}= 100;
  $prog->{connection_count}->{enable}= 1;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "OK", "connections < warning");
  &clear_status;
  delete($prog->{connection_count});

  $prog->{connection_count}->{warning}= 60;
  $prog->{connection_count}->{critical}= 100;
  $prog->{connection_count}->{enable}= 1;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "WARNING", "connections between warning and critical");
  &clear_status;
  delete($prog->{connection_count});

  $prog->{connection_count}->{warning}= 60;
  $prog->{connection_count}->{critical}= 60;
  $prog->{connection_count}->{enable}= 1;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "CRITICAL", "connections > critical");
  &clear_status;
  delete($prog->{connection_count});

  $prog->{connection_count}->{warning}= 60;
  $prog->{connection_count}->{critical}= 60;
  $prog->{connection_count}->{enable}= 0;
  $prog->check_connection_count;
  is($prog->{status}->{str}, "OK", "Disabled by --connection-count-enable=0");
  &clear_status;
  delete($prog->{connection_count});

  delete($prog->{_show_status});
  delete($prog->{_show_variables});
};

subtest "autoinc_usage" => sub
{
  require "$Bin/data/06_select_autoinc_usage.txt";
  $prog->{_select_autoinc_usage}   = $Ytkit::Test::AUTOINC_USAGE::VAR1;
 
  ### Max autoinc is 10001 on unsigned smallint(65535), about 15.2% used.
  
  $prog->{autoinc_usage}->{warning}= 50;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "OK", "autoinc_usage < warning");
  &clear_status;
  delete($prog->{autoinc_usage});

  $prog->{autoinc_usage}->{warning}= 10;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "WARNING", "autoinc_usage between warning and critical");
  &clear_status;
  delete($prog->{autoinc_usage});

  $prog->{autoinc_usage}->{warning}= 10;
  $prog->{autoinc_usage}->{critical}= 15;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "CRITICAL", "autoinc_usage > critical");
  &clear_status;
  delete($prog->{autoinc_usage});

  $prog->{autoinc_usage}->{warning}= 10;
  $prog->{autoinc_usage}->{critical}= 15;
  $prog->{autoinc_usage}->{enable}= 0;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "OK", "Disabled by --autoinc-usage-enable=0");
  &clear_status;
  delete($prog->{autoinc_usage});


  delete($prog->{_select_autoinc_usage});

  require "$Bin/data/06_select_autoinc_usage_signed.txt";
  $prog->{_select_autoinc_usage}   = $Ytkit::Test::AUTOINC_USAGE_SIGNED::VAR1;
 
  ### Max autoinc is 10001 on signed smallint(32767), about 30.5% used.
  
  $prog->{autoinc_usage}->{warning}= 30;
  $prog->{autoinc_usage}->{critical}= 90;
  $prog->{autoinc_usage}->{enable}= 1;
  $prog->check_autoinc_usage;
  is($prog->{status}->{str}, "WARNING", "Signed smallint is handled correctly.");
  &clear_status;
  delete($prog->{autoinc_usage});

  delete($prog->{_select_autoinc_usage});
};

subtest "read_only" => sub
{
  ### read_only= 0
  require "$Bin/data/06_show_variables.txt";
  $prog->{_show_variables}   = $Ytkit::Test::SHOW_VARIABLES::VAR1;
 
  $prog->{read_only}->{should_be}= 1; ### For slaves.
  $prog->check_read_only;
  is($prog->{status}->{str}, "WARNING", "Slave is expected read_only= 1 but not");
  &clear_status;
  delete($prog->{read_only});

  $prog->{read_only}->{should_be}= 0; ### For master.
  $prog->check_read_only;
  is($prog->{status}->{str}, "OK", "Master is expected read_only= 0 and correct");
  &clear_status;
  delete($prog->{read_only});

  delete($prog->{_show_variables});

  ### read_only= 1
  require "$Bin/data/06_show_variables_read_only.txt";
  $prog->{_show_variables}   = $Ytkit::Test::SHOW_VARIABLES_READ_ONLY::VAR1;
 
  $prog->{read_only}->{should_be}= 1; ### For slaves.
  $prog->check_read_only;
  is($prog->{status}->{str}, "OK", "Slave is expected read_only= 1 and correct");
  &clear_status;
  delete($prog->{read_only});

  $prog->{read_only}->{should_be}= 0; ### For master.
  $prog->check_read_only;
  is($prog->{status}->{str}, "CRITICAL", "Master is expected read_only= 0 but not");
  &clear_status;
  delete($prog->{read_only});

  delete($prog->{_show_variables});
};

subtest "slave_status" => sub
{
  require "$Bin/data/06_show_slave_status_ok.txt";
  $prog->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;

  ### I/O Running and SQL Running are "YES", Seconds_Behind_Master is 43.
 
  $prog->{slave_status}->{warning}= 100;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "OK", "slave_status < warning");
  &clear_status;
  delete($prog->{slave_status});

  $prog->{slave_status}->{warning}= 10;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "WARNING", "slave_status between warning and critical");
  &clear_status;
  delete($prog->{slave_status});

  $prog->{slave_status}->{warning}= 10;
  $prog->{slave_status}->{critical}= 15;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "CRITICAL", "slave_status > critical");
  &clear_status;
  delete($prog->{slave_status});

  delete($prog->{_show_slave_status});

  require "$Bin/data/06_show_slave_status_ng.txt";
  $prog->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_NG::VAR1;

  ### SQL Running is "NO", always should be CRITICAL
 
  $prog->{slave_status}->{warning}= 100;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 1;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "CRITICAL", "SQL Thread is not running");
  &clear_status;
  delete($prog->{slave_status});

  $prog->{slave_status}->{warning}= 100;
  $prog->{slave_status}->{critical}= 1000;
  $prog->{slave_status}->{enable}= 0;
  $prog->check_slave_status;
  is($prog->{status}->{str}, "OK", "Disabled by --slave-status-enable=0");
  &clear_status;
  delete($prog->{slave_status});



  delete($prog->{_show_slave_status});
};

done_testing;


exit 0;

sub clear_status
{
  $prog->{status}= Ytkit::HealthCheck::NAGIOS_OK;
  $prog->{output}= "";
}
