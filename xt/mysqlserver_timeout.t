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
my $mysqld= Test::mysqld->new;

my $server= Ytkit::MySQLServer->new({ host   => "localhost",
                                      socket => $mysqld->base_dir . "/tmp/mysql.sock",
                                      user   => "root" });
$server->conn;
ok(!($server->error), "Connect to mysqld");

subtest "Queries should be succeeded" => sub
{
  ok($server->query_arrayref("SELECT SLEEP(1)"), "No i_s, 1sec");
  $server->clear_cache;
  ok($server->query_arrayref("SELECT SLEEP(1) FROM information_schema.tables LIMIT 1"), "i_s, 1sec");
  $server->clear_cache;
  ok($server->query_arrayref("SELECT SLEEP(5)"), "No i_s, 5sec");
  $server->clear_cache;

  done_testing;
};

subtest "Queries should be time-outed" => sub
{
  eval
  {
    $server->query_arrayref("SELECT SLEEP(5) FROM information_schema.tables LIMIT 1");
  };
  is(substr($server->error, 0, length(Ytkit::MySQLServer::ALRM_MSG)),
     Ytkit::MySQLServer::ALRM_MSG, "i_s, 5sec should be error");
  $server->clear_cache;

  eval
  {
    $server->query_arrayref("SELECT SLEEP(1) FROM information_schema.tables LIMIT 1");
  };
  is($server->error, Ytkit::MySQLServer::ABORT_I_S, "_do_not_query_i_s turned on and aborting query");
  $server->clear_cache;

  ok($server->query_arrayref("SELECT SLEEP(1)"), "No i_s query doesn't affect by _do_not_query_i_s");
  $server->clear_cache;

  done_testing;
};


done_testing;
