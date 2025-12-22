#!/usr/bin/perl

#########################################################################
# Copyright (C) 2020, 2025  yoku0825
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

use constant
{
  QUERY_SUCCESS => "SELECT 1",
  QUERY_WARNING => "SET profiling = 1 /* Verified at 8.0.20 */",
  QUERY_ERROR   => "SELECT Syntax-error",
};

my $sandbox= Ytkit::Sandbox->new("--mysqld", "8.0");
$sandbox->prepare();
my $server= Ytkit::MySQLServer->new({ host   => $sandbox->info->[0],
                                      user   => "root" });
$server->conn;
ok(!($server->error), "Connect to mysqld");

subtest "Query without error" => sub
{
  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  eval
  {
    $server->exec_sql(QUERY_SUCCESS);
    $server->exec_sql_with_croak(QUERY_SUCCESS);
    $server->exec_sql_with_carp(QUERY_SUCCESS);
  };

  ok(!($@), "Didn't croak");
  is($warn_count, 0, "Carp should not be called");

  done_testing;
};

subtest "Query with warnings" => sub
{
  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  eval
  {
    $server->exec_sql(QUERY_WARNING);
    $server->exec_sql_with_croak(QUERY_WARNING);
    $server->exec_sql_with_carp(QUERY_WARNING);
  };

  ok(!($@), "Didn't croak");
  is($warn_count, 2, "Carp was called from exec_sql_with_croak and exec_sql_with_carp");

  done_testing;
};

subtest "Query with error" => sub
{
  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  eval
  {
    $server->exec_sql(QUERY_ERROR);
  };
  ok(!($@), "Didn't croak");

  eval
  {
    $server->exec_sql_with_croak(QUERY_ERROR);
  };
  ok($@, "Should be croak");

  eval
  {
    $server->exec_sql_with_carp(QUERY_ERROR);
  };

  ok(!($@), "Didn't croak");
  is($warn_count, 1, "Carp was called from exec_sql_with_carp");

  done_testing;
};

$sandbox->delete_sandbox;

done_testing;
