#!/usr/bin/perl

#########################################################################
# Copyright (C) 2020  yoku0825
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
use Test::mysqld;

use Ytkit::IO;
use Ytkit::AdminTool;

my $test=
{
  "5.7" => { mysqld => "/usr/mysql/5.7.30/bin/mysqld" },
  "8.0" => { mysqld => "/usr/mysql/8.0.20/bin/mysqld" },
};


foreach (sort(keys(%$test)))
{
  subtest "Testing via $_" => sub
  {
    $ENV{MYSQL_PWD}= "";
    my $mysqld= Test::mysqld->new($test->{$_});
    my $initialize= Ytkit::AdminTool->new("--host=localhost",
                                          "--socket",  $mysqld->base_dir . "/tmp/mysql.sock",
                                          "--user=root",
                                          "initialize");
  
    $initialize->run;
    my $instance= $initialize->instance;
    my $schema_count= "SELECT COUNT(*) AS c FROM information_schema.schemata WHERE schema_name IN ('admintool', 'adminview')";
    is($initialize->instance->_real_query_arrayref($schema_count)->[0]->{c}, 2, "Schema created");
  
    my $admintool_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'admintool'";
    is($instance->_real_query_arrayref($admintool_count)->[0]->{c}, 10, "Create admintool tables");
  
    ### adminview counts are different between 8.0 and others.
    my $adminview_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'adminview'";
    is($instance->_real_query_arrayref($adminview_count)->[0]->{c},
       $_ eq "8.0" ? 18 : 12, "Create adminview tables");
 
    ### Create monitor user
    $instance->exec_sql_with_croak(q{CREATE USER monitor@127.0.0.1 IDENTIFIED WITH mysql_native_password BY 'password'});
    $instance->exec_sql_with_croak(q{GRANT SELECT, REPLICATION CLIENT, PROCESS ON *.* TO monitor@127.0.0.1});

    my $port= $instance->_real_query_arrayref('SELECT @@port AS port')->[0]->{port};
  
    my $register= Ytkit::AdminTool->new("--host=localhost",
                                        "--socket",  $mysqld->base_dir . "/tmp/mysql.sock",
                                        "--user=root",
                                        "--monitor-user=monitor",
                                        "--monitor-password=password",
                                        "register", _sprintf("127.0.0.1:%d", $port));
    $register->run;
    is($instance->_real_query_arrayref("SELECT COUNT(*) AS c FROM admintool.instance_info")->[0]->{c},
       1, "Registered successfully");
    $instance->exec_sql("/*!80011 SET SESSION information_schema_stats_expiry = 0 */");
    is($instance->_real_query_arrayref("SELECT GROUP_CONCAT(table_name ORDER BY table_name) AS t " .
                                       "FROM information_schema.tables " .
                                       "WHERE table_schema = 'admintool' AND table_rows > 0")->[0]->{t},
       "grant_info,instance_info,is_innodb_metrics,ps_digest_info,ps_table_info,status_info,table_status_info,variable_info",
       "Initial collection succeeded"); ### slave_status_info is empty(single master)

    done_testing;
  };
}

done_testing;
