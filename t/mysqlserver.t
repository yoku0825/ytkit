#!/usr/bin/perl

#########################################################################
# Copyright (C) 2018, 2021  yoku0825
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
require "$Bin/Test.pl";
Ytkit::Test->import(qw{ read_file });

no warnings "once";

use_ok("Ytkit::MySQLServer");

sub server_reset
{
  my ($server)= @_;
  $server->clear_cache;
}

### Connection failed.
my $server= Ytkit::MySQLServer->new({ host => "localhost" });
ok(!($server->conn), "Connection failed");
ok($server->error, "Catch error message");
is($server->hostname, "localhost", "Failed show_variables then hostname is --host argument itself");

### Dummy connection.
$server->{_conn}= 1;

subtest "show_slave_status" => sub
{
  $server->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::OK;
  is_deeply($server->show_slave_status, $Ytkit::Test::SHOW_SLAVE_STATUS::OK, "SHOW SLAVE STATUS");
  server_reset($server);
};

subtest "show_slave_hosts" => sub
{
  $server->{_show_slave_hosts}= $Ytkit::Test::SHOW_SLAVE_HOSTS::TWO_HOSTS;
  is_deeply($server->show_slave_hosts, $Ytkit::Test::SHOW_SLAVE_HOSTS::TWO_HOSTS, "SHOW SLAVE HOSTS");
  server_reset($server);
};

subtest "show_processlist" => sub
{
  $server->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_6000;
  is_deeply($server->show_processlist, $Ytkit::Test::SHOW_PROCESSLIST::time_1_0_1000_6000, "SHOW PROCESSLIST");
  server_reset($server);
};

subtest "show_status" => sub
{
  $server->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;
  is_deeply($server->show_status, $Ytkit::Test::SHOW_STATUS::VAR1, "SHOW STATUS");
  server_reset($server);
};

subtest "show_variables" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  is_deeply($server->show_variables, $Ytkit::Test::SHOW_VARIABLES::VAR1, "SHOW VARIABLES");
  is($server->hostname, "163-44-175-117", "Fetch hostname");
  is($server->mysqld_version, 50719, "Fetch version-string");
  is($server->port, 64057, "Fetch port-number");
  server_reset($server);
};

subtest "select_autoinc_usage" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on; ### For mysqld_version
  $server->{_select_autoinc_usage}= $Ytkit::Test::AUTOINC_USAGE::VAR1;
  is_deeply($server->select_autoinc_usage, $Ytkit::Test::AUTOINC_USAGE::VAR1, "SELECT FROM i_s.columns");
  server_reset($server);
};

subtest "show_master_logs" => sub
{
  $server->{_show_master_logs}= $Ytkit::Test::SHOW_MASTER_LOGS::VAR1;
  is_deeply($server->show_master_logs, $Ytkit::Test::SHOW_MASTER_LOGS::VAR1, "SHOW MASTER LOGS");
  server_reset($server);
};

subtest "select_ps_digest" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on; ### For mysqld_version
  $server->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::VAR1;
  is_deeply($server->select_ps_digest, $Ytkit::Test::SELECT_FROM_ps_digest::VAR1,
            "SELECT FROM p_s.events_statements_summary_by_digest");
  server_reset($server);
};

subtest "select_ps_table" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on; ### For mysqld_version
  $server->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR1;
  is_deeply($server->select_ps_table, $Ytkit::Test::SELECT_FROM_ps_table::VAR1,
            "SELECT FROM p_s.table_io_waits_summary_by_table");
  server_reset($server);
};

subtest "select_is_table_by_size" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on; ### For mysqld_version
  $server->{_select_is_table_by_size}= $Ytkit::Test::SELECT_FROM_is_table::VAR1;
  is_deeply($server->select_is_table_by_size, $Ytkit::Test::SELECT_FROM_is_table::VAR1,
            "SELECT FROM i_s.tables");
  server_reset($server);
};

subtest "select_user_list" => sub
{
  $server->{_select_user_list}= $Ytkit::Test::SELECT_user_list::one_user;
  is_deeply($server->select_user_list, $Ytkit::Test::SELECT_user_list::one_user,
            "SELECT FROM mysql.user");
  server_reset($server);
};

subtest "show_grants" => sub
{
  $server->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  is_deeply($server->show_grants("mysql.sys", "localhost"),
            [ { grants => q{GRANT USAGE ON *.* TO 'mysql.sys'@'localhost'} },
              { grants => q{GRANT TRIGGER ON `sys`.* TO 'mysql.sys'@'localhost'} },
              { grants => q{GRANT SELECT ON `sys`.`sys_config` TO 'mysql.sys'@'localhost'} }, ],
            "SHOW GRANTS");
  server_reset($server);
};

subtest "show_master_status" => sub
{
  $server->{_show_master_status}= $Ytkit::Test::SHOW_MASTER_STATUS::VAR1;
  is_deeply($server->show_master_status, $Ytkit::Test::SHOW_MASTER_STATUS::VAR1, "SHOW MASTER STATUS");
  is($server->gtid, "0604c90e-4b59-11e7-b7fb-525400101084:1-9473,0ce790cd-4d07-11e8-9c10-06621cb53d46:1-1293146,19b26900-fcef-11e7-82fa-063fb69985da:1-37128417,1a34192d-fcef-11e7-8595-062147627228:1-164886,2dbe69ea-fcf1-11e7-9d9d-06e9e866376c:1-9520469,2dc9ee8e-fcf1-11e7-a0b5-063446ecbea8:1-627502,39e654ff-fcd4-11e7-8c43-06c109ddbd54:1-1933987,39e66f01-fcd4-11e7-8b39-06bafc31ddaa:1-18474,4873fe37-553b-11e6-a000-00163e101065:1-3253609,4bc34a43-553b-11e6-a3e1-00163e101068:1-115562065,530afaf4-0235-11e7-8d29-525400101060:1-29153937,532bb6e3-631b-11e8-9a49-06ffbe912614:1-74871,5cf27cc1-ecf5-11e6-b34d-525400101053:1-23916786,67db7046-ecf5-11e6-af24-525400101051:1-2,78d2f4ce-70e4-11e7-883c-525400357c3c:1-31320573,7a3770b6-70e4-11e7-a5c0-525400cef58d:1-461,7c42f667-fcd8-11e7-8a07-061709b49a88:1-4744216,84ae5745-022d-11e7-a586-525400101059:1-1489972,a47d2ef7-54a2-11e6-8665-00163e101064:1-3334686,acb97e92-57bf-11e6-8db0-e83935b85c80:1,b5989019-548e-11e6-b767-00163e101065:1-2,b5b1251b-548e-11e6-8c48-00163e101068:1-10,bd7d8b42-fcf2-11e7-afd2-066adb890798:1-130727030,bd8a1e0e-fcf2-11e7-9abd-063d77248c82:1-3482158,c26a9bf2-fcec-11e7-95a2-06e48450d818:1-5922,c28a6437-fcec-11e7-930b-06413a0e1bb0:1,cff18bdf-54a2-11e6-92c6-00163e101063:1-6407745", "Get GTID");
  server_reset($server);
};

subtest "innodb_stats_on_metadata" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  ok(!($server->stats_on_metadata), "innodb_stats_on_metadata = OFF");
  server_reset($server);

  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::STATS_ON_METADATA_IS_ON;
  ok($server->stats_on_metadata, "innodb_stats_on_metadata = ON");
  server_reset($server);

  done_testing;
};

subtest "pseudo_thread_id" => sub
{
  $server->{_thread_id}= $Ytkit::Test::SHOW_VARIABLES::show_session_variables_like_pseudo_thread_id;
  is($server->thread_id, 72, "pseudo_thread_id");
  server_reset($server);
  done_testing;
};

subtest "Set information_schema_stats_expiry" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on;
  $server->{_should_set_stats_expiry}= $Ytkit::Test::SHOW_VARIABLES::stats_expiry_empty;
  ok(!($server->should_set_stats_expiry), "5.7 doesn't have information_schema_stats_expiry.");
  server_reset($server);

  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80;
  $server->{_should_set_stats_expiry}= $Ytkit::Test::SHOW_VARIABLES::stats_expiry_nonzero;
  ok($server->should_set_stats_expiry, "8.0 and information_schema_stats_expiry <> 0.");
  server_reset($server);

  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80;
  $server->{_should_set_stats_expiry}= $Ytkit::Test::SHOW_VARIABLES::stats_expiry_zero;
  ok(!($server->should_set_stats_expiry), "8.0 and information_schema_stats_expiry = 0.");
  server_reset($server);
 
  done_testing;
};

subtest "Parse SHOW ENGINE INNODB STATUS" => sub
{
  subtest "MySQL 5.0" => sub
  {
    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql50;
    is($server->latest_deadlock->epoch, 1562551919, "Parse LATEST DETECTED DEADLOCK");
    server_reset($server);
    done_testing;
  };

  subtest "MySQL 5.1(InnoDB Plugin Only" => sub
  {
    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql51;
    is($server->latest_deadlock->epoch, 1562563203, "Parse LATEST DETECTED DEADLOCK");
    server_reset($server);
    done_testing;
  };

  subtest "MySQL 5.5" => sub
  {
    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql55;
    is($server->latest_deadlock->epoch, 1562563601, "Parse LATEST DETECTED DEADLOCK");
    server_reset($server);
    done_testing;
  };
 
  subtest "MySQL 5.6" => sub
  {
    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql56;
    is($server->latest_deadlock->epoch, 1562563782, "Parse LATEST DETECTED DEADLOCK");
    server_reset($server);
    done_testing;
  };
 
  subtest "MySQL 5.7" => sub
  {
    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql57;
    is($server->latest_deadlock->epoch, 1562837618, "Parse LATEST DETECTED DEADLOCK");
    server_reset($server);

    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql57_no_deadlock;
    is($server->latest_deadlock->epoch, 0, "Parse LATEST DETECTED DEADLOCK but doesn't exist");
    server_reset($server);
 
    done_testing;
  };
 
  subtest "MySQL 8.0" => sub
  {
    $server->{_show_engine_innodb_status}= $Ytkit::Test::SHOW_ENGINE_INNODB_STATUS::mysql80;
    is($server->latest_deadlock->epoch, 1562838160, "Parse LATEST DETECTED DEADLOCK");
    server_reset($server);
    done_testing;
  };
 
  done_testing;
};

#subtest "InnoDB Locking Information" => sub
#{
#  ### Move to xt/innodb_locking_information.t
#  done_testing;
#};

subtest "Resultset format functions" => sub
{
  is(Ytkit::MySQLServer::_print_table($Ytkit::Test::SHOW_SLAVE_HOSTS::TWO_HOSTS),
     read_file("$Bin/data/r/print_table.r"), "print_table");
  is(Ytkit::MySQLServer::_print_vtable($Ytkit::Test::SHOW_SLAVE_HOSTS::TWO_HOSTS),
     read_file("$Bin/data/r/print_vtable.r"), "print_vtable");
  done_testing;
};

subtest "SHOW WARNINGS" => sub
{
  $server->{__test_show_warnings}= $Ytkit::Test::SHOW_WARNINGS::WARNING;
  is(scalar(@{$server->check_warnings}), 7, "SHOW WARNINGS without filtering");

  $ENV{ytkit_ignore_warning}= "1287";
  is(scalar(@{$server->check_warnings}), 5, "Warning filtering");

  $ENV{ytkit_ignore_warning}= "1287,1292";
  is(scalar(@{$server->check_warnings}), 0, "Multiple warning filtering");
  done_testing;
};

subtest "Supported version handling" => sub
{
  server_reset($server);
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql57_ps_on; ### For mysqld_version

  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  is($server->mysqld_version, 50719, "5.7.19 is set.");
  is($warn_count, 0, "No warnings yet.");

  ok($server->support_version(50632), "Compare vs. 5.6.32");
  is($warn_count, 0, "No warnings");

  ok($server->support_version(50719), "Compare vs. 5.7.19");
  is($warn_count, 0, "No warnings");

  ok(!($server->support_version(80022)), "Compare vs. 8.0.22");
  is($warn_count, 1, "Raise warning");

  $server->{_ignore_unsupport_version}= 1;
  ok(!($server->support_version(80022)), "Compare vs. 8.0.22 again");
  is($warn_count, 1, "No warning increment when _ignore_unsupport_version is set.");

  server_reset($server);
  done_testing;
};

subtest "i_am_group_replication_primary" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80;
  $server->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3;
  is($server->i_am_group_replication_primary, 1, "Group Replication PRIMARY Server");
  server_reset($server);

  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80_another_uuid;
  $server->{_replication_group_members}= $Ytkit::Test::SELECT_FROM_ps_repl_group_members::online3;
  is($server->i_am_group_replication_primary, 0, "Group Replication SECONDARY Server");
  server_reset($server);

  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::mysql80_another_uuid;
  $server->{_replication_group_members}= [];
  is($server->i_am_group_replication_primary, undef, "I'm not in Group Replication");
  server_reset($server);

  done_testing;
};


done_testing;
