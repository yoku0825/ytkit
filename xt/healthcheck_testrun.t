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
no warnings "once";
use utf8;
use Test::More;

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/xTest.pl";
use Test::mysqld;

use DBI;
use Ytkit::HealthCheck;

my $test= $Ytkit::xTest::version;

my @enables_list= qw{ --autoinc-usage-enable=1 
                      --connection-count-enable=1
                      --deadlock-enable=1
                      --gtid-hole-enable=1
                      --history-list-enable=1
                      --long-query-enable=1
                      --slave-status-enable=1
                      --uptime-enable=1 };

### Put test-binaries into /usr/mysql/X.X.XX 
foreach my $version (sort(keys(%$test)))
{
  subtest "Testing via $version" => sub
  {
    $test->{$version}->{my_cnf}=
    {
      server_id => 1,
      log_bin   => "mysql-bin",
    };
    my $mysqld= Test::mysqld->new($test->{$version});
    my $server= DBI->connect($mysqld->dsn, "root", "") or die;
    $server->do("SET GLOBAL innodb_stats_on_metadata = OFF");

    my $prog= Ytkit::HealthCheck->new("--host=localhost",
                                      "--socket", $mysqld->base_dir . "/tmp/mysql.sock",
                                      "--user=root",
                                      @enables_list,
                                      "--uptime-critical=0",
                                      "--uptime-warning=0");
    $prog->print_status;
    is($prog->{status}->{exit_code}, 0);
    done_testing;
  };
}

done_testing;
