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

use Ytkit::MySQLServer;
use Ytkit::Sandbox;

foreach (@Ytkit::xTest::sandboxes)
{
  subtest "Testing via $_" => sub
  {
    my $sandbox= Ytkit::Sandbox->new("--mysqld", $_);
    $sandbox->prepare;
    my $ipaddr= $sandbox->info;
    my $server= Ytkit::MySQLServer->new({ host   => $ipaddr->[0],
                                          user   => "root", });
    $server->conn;
    ok(!($server->error), "Connect to mysqld") or diag($server->error);
    is_deeply($server->fetch_innodb_lock_waits, [], "fetch_innodb_lock_waits returns empty arrayref");
    ok(!($server->error), "Query is succeeded");
    $sandbox->delete_sandbox;
  
    done_testing;
  };
}

done_testing;
