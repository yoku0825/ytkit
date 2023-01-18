#!/usr/bin/perl

#########################################################################
# Copyright (C) 2023  yoku0825
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

use DBI;
use Clone qw{ clone };
use Ytkit::ReplTopology;
use Ytkit::IO qw{ _debugf _notef };

my $source= clone($Ytkit::xTest::version->{$Ytkit::xTest::mysql80});

$source->{my_cnf}=
{
  server_id => 1,
  port => 13306,
  log_bin   => "mysql-bin",
  default_authentication_plugin => "mysql_native_password",
};
my $source_mysqld= Test::mysqld->new($source);
my $source_conn= DBI->connect($source_mysqld->dsn, "root", "");
$source_conn->do("CREATE USER watcher");
$source_conn->do("GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE, PROCESS ON *.* TO watcher");

subtest "Issue #80" => sub
{
  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  my $prog= Ytkit::ReplTopology->new("--host=localhost",
                                     "--socket", $source_mysqld->base_dir . "/tmp/mysql.sock",
                                     "--user=watcher");
  $prog->run;
  is($warn_count, 0, "Success");
};

$source_conn->do("CREATE USER replicator");
$source_conn->do("GRANT REPLICATION SLAVE ON *.* TO replicator");

my $replica= clone($Ytkit::xTest::version->{$Ytkit::xTest::mysql80});
$replica->{my_cnf}=
{
  server_id => 2,
  port => 13307,
  log_bin   => "mysql-bin",
  default_authentication_plugin => "mysql_native_password",
};
my $replica_mysqld= Test::mysqld->new($replica);
my $replica_conn= DBI->connect($replica_mysqld->dsn, "root", "");

$replica_conn->do("CHANGE REPLICATION SOURCE TO source_host = '127.0.0.1', source_port = 13306, source_user= 'replicator', source_log_file= 'mysql-bin.000001', source_log_pos = 1");
$replica_conn->do("START REPLICA");
$replica_conn->do("SELECT SOURCE_POS_WAIT('mysql-bin.000002', 1313)");

subtest "Issue #79" => sub
{
  my $prog= Ytkit::ReplTopology->new("--host=localhost",
                                     "--socket", $source_mysqld->base_dir . "/tmp/mysql.sock",
                                     "--user=watcher");
  $prog->run;
  is(join("", $prog->topology), "150-95-141-50:13306 => 150-95-141-50:13307\n", "Successfully using --socket");
  done_testing;
};


done_testing;
