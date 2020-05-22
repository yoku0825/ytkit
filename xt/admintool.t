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

use Ytkit::AdminTool;

my $test=
{
  "5.7" => { mysqld => "/usr/mysql/5.7.30/bin/mysqld" },
  "8.0" => { mysqld => "/usr/mysql/8.0.20/bin/mysqld" },
};

subtest "Testing via 8.0" => sub
{
  my $mysqld= Test::mysqld->new($test->{"8.0"});
  my $admin= Ytkit::AdminTool->new("--host=localhost",
                                   "--socket",  $mysqld->base_dir . "/tmp/mysql.sock",
                                   "--user=root",
                                   "initialize");
  my $schema_count= "SELECT COUNT(*) AS c FROM information_schema.schemata WHERE schema_name IN ('admintool', 'adminview')";
  is($admin->instance->query_arrayref($schema_count)->[0]->{c}, 2, "Schema created");
$DB::single= 1;
  my $admintool_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'admintool'";
  is($admin->instance->query_arrayref($admintool_count)->[0]->{c}, 9, "admintool tables");

  my $adminview_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'adminview'";
  is($admin->instance->query_arrayref($admintool_count)->[0]->{c}, 15, "adminview tables");

  done_testing;
};

subtest "Testing via 5.7" => sub
{
  my $mysqld= Test::mysqld->new($test->{"5.7"});
  my $admin= Ytkit::AdminTool->new("--host=localhost",
                                   "--socket",  $mysqld->base_dir . "/tmp/mysql.sock",
                                   "--user=root",
                                   "initialize");
  my $schema_count= "SELECT COUNT(*) AS c FROM information_schema.schemata WHERE schema_name IN ('admintool', 'adminview')";
  is($admin->instance->query_arrayref($schema_count)->[0]->{c}, 2, "Schema created");

  my $admintool_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'admintool'";
  is($admin->instance->query_arrayref($admintool_count)->[0]->{c}, 9, "admintool tables");

  my $adminview_count= "SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = 'adminview'";
  is($admin->instance->query_arrayref($admintool_count)->[0]->{c}, 11, "adminview tables");

  done_testing;
};


done_testing;
