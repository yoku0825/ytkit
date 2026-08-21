#!/usr/bin/perl

#########################################################################
# Copyright (C) 2020, 2026  yoku0825
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

use Ytkit::HealthCheck;
use Ytkit::Sandbox;

my @enables_list= qw{ --autoinc-usage-enable=1 
                      --connection-count-enable=1
                      --deadlock-enable=1
                      --gtid-hole-enable=1
                      --history-list-enable=1
                      --long-query-enable=1
                      --slave-status-enable=1
                      --uptime-enable=1 };

foreach my $version (@Ytkit::xTest::sandboxes)
{
  subtest "Testing via $version" => sub
  {
    my $sandbox_home= tempdir(DIR => $Ytkit::xTest::sandbox_tmp);
    my $sandbox= Ytkit::Sandbox->new("--mysqld", $version, "--sandbox_home", $sandbox_home);
    $sandbox->prepare;
    $sandbox->setup_replication;

    $sandbox->get_first_instance->exec_sql("SET GLOBAL innodb_stats_on_metadata = OFF");

    my $prog= Ytkit::HealthCheck->new("--host", $sandbox->info->[0],
                                      "--user=root",
                                      @enables_list,
                                      "--uptime-critical=0",
                                      "--uptime-warning=0");
    $prog->print_status;
    is($prog->{status}->{exit_code}, 0);
    $sandbox->delete_sandbox;
    done_testing;
  };
}

done_testing;
