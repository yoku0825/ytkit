#!/usr/bin/perl

#########################################################################
# Copyright (C) 2019  yoku0825
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

use Ytkit::MySQLServer;

my $test=
{
  "5.0" => { mysqld => "/usr/mysql/5.0.96/libexec/mysqld", mysql_install_db => "/usr/mysql/5.0.96/bin/mysql_install_db" },
  "5.1" => { mysqld => "/usr/mysql/5.1.73/libexec/mysqld", mysql_install_db => "/usr/mysql/5.1.73/bin/mysql_install_db" },
  "5.5" => { mysqld => "/usr/mysql/5.5.62/bin/mysqld", mysql_install_db => "/usr/mysql/5.5.62/scripts/mysql_install_db" },
  "5.6" => { mysqld => "/usr/mysql/5.6.46/bin/mysqld", mysql_install_db => "/usr/mysql/5.6.46/scripts/mysql_install_db" },
  "5.7" => { mysqld => "/usr/mysql/5.7.28/bin/mysqld" },
  "8.0" => { mysqld => "/usr/mysql/8.0.18/bin/mysqld" },
};

subtest "Testing via 5.0" => sub
{
  plan skip_all => "libmysqlclient21 doesn't support MySQL 5.0 connection..";

  my $mysqld= Test::mysqld->new($test->{"5.0"});
  my $server= Ytkit::MySQLServer->new({ host   => "localhost",
                                        socket => $mysqld->base_dir . "/tmp/mysql.sock",
                                        user   => "root", });
  $server->conn;
  ok(!($server->error), "Connect to mysqld");
  ok(!(defined($server->fetch_innodb_lock_waits)), "fetch_innodb_lock_waits returns undef");
  is($server->error, "Unsupported version for fetch_innodb_lock_waits", "Unsupported Error message");
  done_testing;
};

subtest "Testing via 5.1" => sub
{
  plan skip_all => "libmysqlclient21 doesn't support MySQL 5.1 connection..";

  my $mysqld= Test::mysqld->new($test->{"5.1"});
  my $server= Ytkit::MySQLServer->new({ host   => "localhost",
                                        socket => $mysqld->base_dir . "/tmp/mysql.sock",
                                        user   => "root", });
  $server->conn;
  ok(!($server->error), "Connect to mysqld");
  ok(!(defined($server->fetch_innodb_lock_waits)), "fetch_innodb_lock_waits returns undef");
  is($server->error, "Unsupported version for fetch_innodb_lock_waits", "Unsupported Error message");
  done_testing;
};

foreach (qw{ 5.5 5.6 })
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

foreach (qw{ 5.7 8.0 })
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
