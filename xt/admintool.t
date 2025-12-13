#!/usr/bin/perl

#########################################################################
# Copyright (C) 2021, 2025  yoku0825
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
no warnings "once";
use utf8;
use Test::More;

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/xTest.pl";

use Ytkit::IO;
use Ytkit::AdminTool;
use Ytkit::AdminTool::DDL; ### For view counting
use Ytkit::Sandbox;

### Make silent without debugging
$ENV{ytkit_verbose}= $ENV{ytkit_verbose} == Ytkit::IO::NORMAL ? 
                       Ytkit::IO::SILENT : 
                       $ENV{ytkit_verbose};



foreach (@Ytkit::xTest::sandboxes)
{
  ### Only test 5.7 and 8.0
  next if $_ ne "5.7" and $_ ne "8.0";
  subtest "Testing via $_" => sub
  {
    my $sandbox= Ytkit::Sandbox->new("--mysqld", $_);
    $sandbox->prepare;
    my $ipaddr= $sandbox->info->[0];
    my $initialize= Ytkit::AdminTool->new("--host", $ipaddr,
                                          "--user=root",
                                          "initialize");
  
    $initialize->run;
    my $instance= $initialize->instance;
    my $schema_count= "SELECT COUNT(*) AS c FROM information_schema.schemata WHERE schema_name IN ('admintool', 'adminview')";
    is($initialize->instance->_real_query_arrayref($schema_count)->[0]->{c}, 2, "Schema created");
  
    my $admintool_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'admintool'";
    is($instance->_real_query_arrayref($admintool_count)->[0]->{c},
       scalar(@{Ytkit::AdminTool::DDL::admintool_schema()}),
       "Create admintool tables");
  
    ### adminview counts are different between 8.0 and others.
    my $adminview_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'adminview'";
    is($instance->_real_query_arrayref($adminview_count)->[0]->{c},
       scalar(@{Ytkit::AdminTool::DDL::adminview_schema()}) +
         ($_ eq "8.0" ? scalar(@{Ytkit::AdminTool::DDL::adminview_schema_ex()}) : 0),
       "Create adminview tables");

    subtest "Checking view definition is correct" => sub
    {
      my $adminview_name= "SELECT table_name AS table_name FROM information_schema.views WHERE table_schema = 'adminview'";

      local $SIG{__WARN__}= sub
      {
        ok(0, "Querying adminview failed.");
      };

      foreach my $row (@{$instance->_real_query_arrayref($adminview_name)})
      {
        eval
        {
          $instance->_real_query_arrayref(_sprintf("SELECT * FROM adminview.%s", $row->{table_name}));
        };
        ok(!($@), _sprintf("SELECT FROM adminview.%s succeeded", $row->{table_name})) or diag($@);
      }
      done_testing;
    };
 
    ### Create monitor user
    $instance->exec_sql_with_croak(q{CREATE USER monitor IDENTIFIED WITH mysql_native_password BY 'password'});
    $instance->exec_sql_with_croak(q{GRANT SELECT, REPLICATION CLIENT, PROCESS ON *.* TO monitor});

    my $port= $instance->_real_query_arrayref('SELECT @@port AS port')->[0]->{port};
  
    $ENV{MYSQL_PWD}= "";
    my $register= Ytkit::AdminTool->new("--host", $ipaddr,
                                        "--user=root",
                                        "--monitor-user=monitor",
                                        "--monitor-password=password",
                                        "register", _sprintf("%s:%d", $ipaddr, $port));
    $register->run;
    is_deeply($register->_fetch_instance_info,
              [{ ipaddr => $ipaddr, port => $port, healthcheck_role => "auto" }],
              "Registered successfully");
    $instance->update_stats_expiry;
    is($instance->_real_query_arrayref("SELECT GROUP_CONCAT(table_name ORDER BY table_name) AS t " .
                                       "FROM information_schema.tables " .
                                       "WHERE table_schema = 'admintool' AND table_rows > 0")->[0]->{t},
       "grant_info,instance_info,is_innodb_metrics,ps_digest_info,ps_table_info,status_info,table_status_info,variable_info",
       "Initial collection succeeded"); ### slave_status_info is empty(single master)

    ### For testing after "collect"
    my $table_rows= $instance->_real_query_arrayref("SELECT COUNT(*) AS c FROM admintool.status_info")->[0]->{c};

    $ENV{MYSQL_PWD}= "";
    my $collect= Ytkit::AdminTool->new("--host", $ipaddr,
                                       "--user=root",
                                       "--monitor-user=monitor",
                                       "--monitor-password=password",
                                       "collect");
    $collect->run;
    is($instance->_real_query_arrayref("SELECT COUNT(*) AS c FROM admintool.status_info")->[0]->{c},
       $table_rows * 2,
       "status_info collected");

    $ENV{MYSQL_PWD}= "";
    my $purge= Ytkit::AdminTool->new("--host", $ipaddr,
                                     "--user=root",
                                     "--monitor-user=monitor",
                                     "--monitor-password=password",
                                     "purge");
    $purge->run;
    ok($purge, "purge does not raise error");

    my $destroy_script= sprintf("%s/destroy_all", $sandbox->{top_directory});
    `bash $destroy_script`;
    done_testing;
  };
}

done_testing;
