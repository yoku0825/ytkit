#!/usr/bin/perl

#########################################################################
# Copyright (C) 2025  yoku0825
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
use Ytkit::Sandbox;
use Ytkit::IO qw{ _croakf };

my @target_container= qw{ 5.5.62 5.6.51 5.7.40 8.0.43 8.4.6 9.4.0 };

$ENV{ytkit_verbose}= 2;

## [[Note, 1759, Sending passwords in plain text without SSL/TLS is extremely insecure.],
## [Note, 1760, Storing MySQL user name or password information in the master info repository is not secure and is therefore not recommended. Please consider using the USER and PASSWORD connection options for START SLAVE; see the 'START SLAVE Syntax' in the MySQL Manual for more information.]]
$ENV{ytkit_ignore_warning}= "1759,1760";
use Carp::Always;

subtest "single" => sub
{
  foreach my $version (@target_container)
  {
    my $sandbox= Ytkit::Sandbox->new("--topology", "single", "servers", 1, "--mysqld", $version);
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
  foreach my $version (@target_container)
  {
    my $sandbox= Ytkit::Sandbox->new("--topology", "replication", "--servers", 2, "--mysqld", $version);
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
  foreach my $version (@target_container)
  {
    next if $version eq "5.5.62" or $version eq "5.6.51" or $version eq "5.7.40";  ### Doesn't support Group Replication
    my $sandbox= Ytkit::Sandbox->new("--topology", "gr", "--servers", 2, "--mysqld", $version);
    $sandbox->prepare;
    $sandbox->setup_replication;

    while (my ($node, $server) = each(%{$sandbox->{_members}}))
    {
      ok($server->{ipaddr}, "${version}-group_replication-${node} startup");
    }
      
    my $gr_count= scalar(@{$sandbox->{_members}->{node1}->{instance}->replication_group_members});
    is($gr_count, 2, "Group Replication has 2 nodes") or _croakf("die to diagnostics");

    $sandbox->delete_sandbox;
  }
  done_testing;
};


done_testing;
