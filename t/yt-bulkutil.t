#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017  yoku0825
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
use Test::More;
use Test::More::Color qw{foreground};

use FindBin qw{$Bin};
use lib "$Bin/../lib";
use Ytkit::BulkUtil;

no warnings "once";

subtest "connecting master" => sub
{
  my $prog;
  $prog= Ytkit::BulkUtil->new({silent => 1});
  is($prog->master_conn, 0, "master_user and master_host didn't specify");
  is($prog->{monitor_user}, "yt_bulkutil", "Auto-generated monitor_user");
  $prog->{monitor_password} =~ /^([A-Z]{16})$/;
  ok($1, "Auto-generated monitor_password");

  $prog= Ytkit::BulkUtil->new({master_user => "root", monitor_user => "Sushi", monitor_password => "Beer", silent => 1});
  is($prog->master_conn, 0, "master_user was specified but  master_host didn't specify");
  is($prog->{monitor_user}, "Sushi", "Specified monitor_user");
  is($prog->{monitor_password}, "Beer", "Specified monitor_password");

  $prog= Ytkit::BulkUtil->new({master_user => "root", master_host => "localhost", monitor_password => "Yakiniku", silent => 1});
  is($prog->master_conn, 0, "Master connection failed.");

  ### Fake connection.
  $prog->{_master_conn}= "dummy";
  my @sql= $prog->add_monitor_user_sql;
  is($sql[0], q{CREATE USER /*!50708 IF NOT EXISTS */ 'yt_bulkutil'@'%' IDENTIFIED BY 'Yakiniku'}, "Generate CREATE USER statement");
  is($sql[1], q{GRANT REPLICATION CLIENT ON *.* TO 'yt_bulkutil'@'%'}, "Generate GRANT statement");
  is($prog->add_monitor_user, 0, "CREATE USER failed (Connection unavailable)");
  is($prog->drop_monitor_user_sql, q{DROP USER 'yt_bulkutil'@'%'}, "Generate DROP USER statement");
  is($prog->drop_monitor_user, 0, "DROP USER failed (Connection unavailable)");

  ### TODO: When --monitor_user / password / ip include a "'" character.
};

subtest "Detect slaves" => sub
{
  my $prog;
  $prog= Ytkit::BulkUtil->new({slaves => "127.10.0.1:3306,127.10.0.2:3307,127.10.0.10", silent => 1});
  is_deeply($prog->slave_list, [["127.10.0.1", "3306"], ["127.10.0.2", "3307"], ["127.10.0.10"]],
            "--slaves passed manually");

  $prog= Ytkit::BulkUtil->new({silent => 1});
  require "$Bin/data/show_slave_hosts.txt";
  $prog->{_show_slave_hosts}= $Ytkit::Test::SHOW_SLAVE_HOSTS::VAR1;
  is_deeply($prog->search_slave, "SBslave1:20796,SBslave2:20797", "Search slaves by SHOW SLAVE HOSTS");
  $prog->set_slave_via_search;
  is_deeply($prog->slave_list, [["SBslave1", "20796"], ["SBslave2", "20797"]], "--slaves picked automatically");
  is($prog->check_slave_connectivity, 0, "Connection failed to (at least, one of) slave(s)");

  done_testing;
};

done_testing;
