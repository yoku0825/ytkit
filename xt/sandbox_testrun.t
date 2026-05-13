#!/usr/bin/perl

#########################################################################
# Copyright (C) 2025, 2026  yoku0825
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
use File::Temp qw{ tempdir };

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/xTest.pl";
use Ytkit::Sandbox;
use Ytkit::IO qw{ _croakf };

### Make silent without debugging
$ENV{ytkit_verbose}= $ENV{ytkit_verbose} == Ytkit::IO::NORMAL ? 
                       Ytkit::IO::SILENT : 
                       $ENV{ytkit_verbose};

## [[Note, 1759, Sending passwords in plain text without SSL/TLS is extremely insecure.],
## [Note, 1760, Storing MySQL user name or password information in the master info repository is not secure and is therefore not recommended. Please consider using the USER and PASSWORD connection options for START SLAVE; see the 'START SLAVE Syntax' in the MySQL Manual for more information.]]
$ENV{ytkit_ignore_warning}= "1759,1760";
use Carp::Always;

subtest "single" => sub
{
  foreach my $version (@Ytkit::xTest::sandboxes)
  {
    my $sandbox_home= tempdir(DIR => $Ytkit::xTest::sandbox_tmp);
    my $sandbox= Ytkit::Sandbox->new("--topology", "single",
                                     "--servers", 1,
                                     "--mysqld", $version,
                                     "--no-persist",
                                     "--sandbox_home", $sandbox_home);
    $sandbox->prepare;
    $sandbox->setup_replication;

    while (my ($node, $server) = each(%{$sandbox->{_members}}))
    {
      ok($server->{ipaddr}, "${version}-single startup") or _croakf("die to diagnostics");
    }

    $sandbox->delete_sandbox;
  }
  done_testing;
};

subtest "replication" => sub
{
  foreach my $version (@Ytkit::xTest::sandboxes)
  {
    my $sandbox_home= tempdir(DIR => $Ytkit::xTest::sandbox_tmp);
    my $sandbox= Ytkit::Sandbox->new("--topology", "replication",
                                     "--servers", 2,
                                     "--mysqld", $version,
                                     "--no-persist",
                                     "--sandbox_home", $sandbox_home);
    $sandbox->prepare;
    $sandbox->setup_replication;

    while (my ($node, $server) = each(%{$sandbox->{_members}}))
    {
      ok($server->{ipaddr}, "${version}-replication-${node} startup");
    }
      
    if ($sandbox->{_version_int} ge 80400)
    {
      my $repl= $sandbox->{_members}->{node2}->{instance}->query_arrayref("SHOW REPLICA STATUS")->[0];
      is($repl->{Replica_IO_Running}, "Yes", "Replica_IO_Running");
      is($repl->{Replica_SQL_Running}, "Yes", "Replica_SQL_Running");
    }
    else
    {
      my $repl= $sandbox->{_members}->{node2}->{instance}->query_arrayref("SHOW SLAVE STATUS")->[0];
      is($repl->{Slave_IO_Running}, "Yes", "Slave_IO_Running");
      is($repl->{Slave_SQL_Running}, "Yes", "Slave_SQL_Running");
    }

    $sandbox->delete_sandbox;
  }
  done_testing;
};

subtest "group_replication" => sub
{
  foreach my $version (@Ytkit::xTest::sandboxes)
  {
    next if $version eq "5.5" or $version eq "5.6" or $version eq "5.7";  ### Doesn't support Group Replication
    my $sandbox_home= tempdir(DIR => $Ytkit::xTest::sandbox_tmp);
    my $sandbox= Ytkit::Sandbox->new("--topology", "gr",
                                     "--servers", 2,
                                     "--mysqld", $version,
                                     "--no-persist",
                                     "--sandbox_home", $sandbox_home);
    $sandbox->prepare;
    $sandbox->setup_replication;

    while (my ($node, $server) = each(%{$sandbox->{_members}}))
    {
      ok($server->{ipaddr}, "${version}-group_replication-${node} startup");
    }
      
    my $gr_count= scalar(@{$sandbox->get_first_instance->replication_group_members});
    is($gr_count, 2, "Group Replication has 2 nodes") or _croakf("die to diagnostics");

    $sandbox->delete_sandbox;
  }
  done_testing;
};


done_testing;
