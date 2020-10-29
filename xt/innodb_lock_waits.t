#!/usr/bin/perl

#########################################################################
# Copyright (C) 2019, 2020  yoku0825
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
use Test::mysqld;

use Ytkit::MySQLServer;

my $test= $Ytkit::xTest::version;

foreach ($Ytkit::xTest::mysql55, $Ytkit::xTest::mysql56)
{
  subtest "Testing via $_" => sub
  {
    my $mysqld= Test::mysqld->new($test->{$_});
    my $server= Ytkit::MySQLServer->new({ host   => "localhost",
                                          socket => $mysqld->base_dir . "/tmp/mysql.sock",
                                          user   => "root", });
    $server->conn;
    ok(!($server->error), "Connect to mysqld");
    is_deeply($server->fetch_innodb_lock_waits, [], "fetch_innodb_lock_waits returns empty arrayref");
    ok(!($server->error), "Query is succeeded");
  
    ### sys.innodb_lock_waits does NOT exists.
    eval
    {
      $server->_fetch_sys_innodb_lock_waits;
    };
    is($server->errno, Ytkit::MySQLServer::ER_NO_SUCH_TABLE, "_fetch_sys_innodb_lock_waits is failed.");
  
    done_testing;
  };
}

foreach ($Ytkit::xTest::mysql57, $Ytkit::xTest::mysql80)
{
  subtest "Testing via $_" => sub
  {
    my $mysqld= Test::mysqld->new($test->{$_});
    my $server= Ytkit::MySQLServer->new({ host   => "localhost",
                                          socket => $mysqld->base_dir . "/tmp/mysql.sock",
                                          user   => "root", });
    $server->conn;
    ok(!($server->error), "Connect to mysqld");
    is_deeply($server->fetch_innodb_lock_waits, [], "fetch_innodb_lock_waits returns empty arrayref");
    ok(!($server->error), "Query is succeeded");
  
    ### sys.innodb_lock_waits exists.
    eval
    {
      $server->_fetch_sys_innodb_lock_waits;
    };
    ok(!($server->errno), "_fetch_sys_innodb_lock_waits is succeeded.");
  
    done_testing;
  };
}


done_testing;
