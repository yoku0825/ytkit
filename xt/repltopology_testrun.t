#!/usr/bin/perl

#########################################################################
# Copyright (C) 2023, 2026  yoku0825
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
use File::Temp qw{ tempdir };

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/xTest.pl";

use Ytkit::ReplTopology;
use Ytkit::Sandbox;
use Ytkit::Sandbox::Node;

subtest "Issue #80" => sub
{
  my $sandbox_home= tempdir(DIR => "/home/yoku0825/git/ytkit/xt/tmp");
  my $sandbox= Ytkit::Sandbox->new("--mysqld", "8.0", "--sandbox_home", $sandbox_home,
                                   "--additional_config", '{"default_authentication_plugin":"mysql_native_password"}');
  $sandbox->prepare;
  my $ipaddr= $sandbox->info->[0];

  ### Not super user.
  $sandbox->{_members}->{node1}->{instance}->exec_sql("CREATE USER watcher");
  $sandbox->{_members}->{node1}->{instance}->exec_sql("GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE, PROCESS ON *.* TO watcher");
  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  my $prog= Ytkit::ReplTopology->new("--socket", sprintf("%s/alpha/node1/datadir/mysql.sock", $sandbox_home),
                                     "--user", "watcher");
  $prog->run;
  is($warn_count, 0, "Success");
  $sandbox->delete_sandbox;
  done_testing;
};

subtest "Issue #79" => sub
{
  my $sandbox_home= tempdir(DIR => "/home/yoku0825/git/ytkit/xt/tmp");
  my $sandbox= Ytkit::Sandbox->new("--mysqld", "8.0", "--sandbox_home", $sandbox_home,
                                   "--topology", "replication",
                                   "--servers", "2",
                                   "--additional_config", '{"default_authentication_plugin":"mysql_native_password"}');
  $sandbox->prepare;
  $sandbox->setup_replication;
  my $source_ip= $sandbox->info->[0];

  ### Not super user.
  $sandbox->{_members}->{node1}->{instance}->exec_sql("CREATE USER watcher");
  $sandbox->{_members}->{node1}->{instance}->exec_sql("GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE, PROCESS ON *.* TO watcher");
  $sandbox->wait_replication_conversion(30);
  my $prog= Ytkit::ReplTopology->new("--socket", sprintf("%s/alpha/node1/datadir/mysql.sock", $sandbox_home),
                                     "--user=watcher");
  $prog->run;
  is(join("", $prog->topology), "alpha-1:3306 => alpha-2:3306\n", "Successfully using --socket");
  $sandbox->delete_sandbox;
  done_testing;
};


done_testing;
