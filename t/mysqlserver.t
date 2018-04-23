#!/usr/bin/perl

#########################################################################
# Copyright (C) 2018  yoku0825
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
use Ytkit::MySQLServer;
require "$Bin/Test.pl";

no warnings "once";

### Connection failed.
my $server;
eval
{
  $server= Ytkit::MySQLServer->new({host => "localhost"});
};
ok(!(defined($server->{conn})), "Connection failed");

### Dummy instance.
$server= do { bless {} => "Ytkit::MySQLServer" };
is($server->hostname, "Can't fetch hostname", "test");
$server->{conn}= "dummy";

subtest "show_slave_status" => sub
{
  $server->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;
  is_deeply($server->show_slave_status, $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1, "SHOW SLAVE STATUS");
  $server->clear_cache;
};

subtest "show_slave_hosts" => sub
{
  $server->{_show_slave_hosts}= $Ytkit::Test::SHOW_SLAVE_HOSTS::VAR1;
  is_deeply($server->show_slave_hosts, $Ytkit::Test::SHOW_SLAVE_HOSTS::VAR1, "SHOW SLAVE HOSTS");
  $server->clear_cache;
};

subtest "show_processlist" => sub
{
  $server->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::VAR1;
  is_deeply($server->show_processlist, $Ytkit::Test::SHOW_PROCESSLIST::VAR1, "SHOW PROCESSLIST");
  $server->clear_cache;
};

subtest "show_status" => sub
{
  $server->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;
  is_deeply($server->show_status, $Ytkit::Test::SHOW_STATUS::VAR1, "SHOW STATUS");
  $server->clear_cache;
};

subtest "show_variables" => sub
{
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  is_deeply($server->show_variables, $Ytkit::Test::SHOW_VARIABLES::VAR1, "SHOW VARIABLES");
  is($server->hostname, "163-44-175-117", "Fetch hostname");
  is($server->mysqld_version, 50719, "Fetch version-string");
  is($server->port, 64057, "Fetch port-number");
  $server->clear_cache;
};

subtest "select_autoinc_usage" => sub
{
  $server->{_select_autoinc_usage}= $Ytkit::Test::AUTOINC_USAGE::VAR1;
  is_deeply($server->select_autoinc_usage, $Ytkit::Test::AUTOINC_USAGE::VAR1, "SELECT FROM i_s.columns");
  $server->clear_cache;
};

subtest "show_master_logs" => sub
{
  $server->{_show_master_logs}= $Ytkit::Test::SHOW_MASTER_LOGS::VAR1;
  is_deeply($server->show_master_logs, $Ytkit::Test::SHOW_MASTER_LOGS::VAR1, "SHOW MASTER LOGS");
  $server->clear_cache;
};

subtest "select_ps_digest" => sub
{
  $server->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::VAR1;
  is_deeply($server->select_ps_digest, $Ytkit::Test::SELECT_FROM_ps_digest::VAR1,
            "SELECT FROM p_s.events_statements_summary_by_digest");
  $server->clear_cache;
};

subtest "select_ps_table" => sub
{
  $server->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR1;
  is_deeply($server->select_ps_table, $Ytkit::Test::SELECT_FROM_ps_table::VAR1,
            "SELECT FROM p_s.table_io_waits_summary_by_table");
  $server->clear_cache;
};

subtest "select_is_table_by_size" => sub
{
  $server->{_select_is_table_by_size}= $Ytkit::Test::SELECT_FROM_is_table::VAR1;
  is_deeply($server->select_is_table_by_size, $Ytkit::Test::SELECT_FROM_is_table::VAR1,
            "SELECT FROM i_s.tables");
  $server->clear_cache;
};

subtest "select_user_list" => sub
{
  $server->{_select_user_list}= $Ytkit::Test::SELECT_user_list::VAR1;
  is_deeply($server->select_user_list, $Ytkit::Test::SELECT_user_list::VAR1,
            "SELECT FROM mysql.user");
  $server->clear_cache;
};

subtest "show_grants" => sub
{
  $server->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  is_deeply($server->show_grants("mysql.sys", "localhost"),
            [ { grants => q{GRANT USAGE ON *.* TO 'mysql.sys'@'localhost'} },
              { grants => q{GRANT TRIGGER ON `sys`.* TO 'mysql.sys'@'localhost'} },
              { grants => q{GRANT SELECT ON `sys`.`sys_config` TO 'mysql.sys'@'localhost'} }, ],
            "SHOW GRANTS");
  $server->clear_cache;
};


done_testing;
