#!/usr/bin/perl

#########################################################################
# Copyright (C) 2022, 2023  yoku0825
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
require "$Bin/Test.pl";

use JSON qw{ from_json };
no warnings "once";

use_ok("Ytkit::ReplTopology");

subtest "Search candidates" => sub
{
  ok(my $prog= Ytkit::ReplTopology->new("--host=test.com", "--port=33061"), "Init");
  is_deeply($prog->{_candidate_port}, [33061], "Initial candidate_port");
  is_deeply($prog->{_candidate_ipaddr}, ["test.com"], "Initial candidate_ipaddr");
  
  $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::with_channel;
  $prog->instance->{_show_slave_hosts}= $Ytkit::Test::SHOW_SLAVE_HOSTS::TWO_HOSTS;
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_gtid;
  
  $prog->search_candidate_port;
  $prog->search_candidate_ipaddr;
  
  is_deeply($prog->{_candidate_port}, [20796, 20797, 3306, 33061], "Updated candidate_port");
  is_deeply($prog->{_candidate_ipaddr}, ["172.17.0.3", "172.17.0.5", "localhost", "test.com"], "Updated candidate_ipaddr");

  done_testing;
};

subtest "Print topology" => sub
{
  ok(my $prog= Ytkit::ReplTopology->new("--host=test.com", "--port=33061"), "Init");
  $prog->{_topology}= [{ "Base_source:3306" => "Replica1:3306" },
                       { "Replica1:3306" => "Cascaded1:3307" },
                       { "Base_source:3306" => "Replica2:13306" },
                       { "Base_source:3306" => "Circular1:3306" },
                       { "Circular1:3306" => "Circular2:3306" },
                       { "Circular2:3306" => "Circular1:3306" },
                       { "Base_source:3306" => "MultiSource:3306" },
                       { "Another_source:3306" => "MultiSource:3306" }];
  my $expected_text= << "EOS";
Another_source:3306 => MultiSource:3306
Base_source:3306 => Circular1:3306
Base_source:3306 => MultiSource:3306
Base_source:3306 => Replica1:3306
Base_source:3306 => Replica2:13306
Circular1:3306 => Circular2:3306
Circular2:3306 => Circular1:3306
Replica1:3306 => Cascaded1:3307
EOS
  is(join("", $prog->print_topology_text), $expected_text, "Text style");

  my $expected_json= << "EOS";
{ "Another_source:3306": { "source": [], "replica": [ "MultiSource:3306" ] },
  "Base_source:3306": { "source": [], "replica": [ "Circular1:3306", "MultiSource:3306", "Replica1:3306", "Replica2:13306" ] },
  "Circular1:3306": { "source": [ "Base_source:3306", "Circular2:3306"], "replica": [ "Circular2:3306" ] },
  "Circular2:3306": { "source": [ "Circular1:3306" ], "replica": [ "Circular1:3306" ] },
  "Replica1:3306": { "source": [ "Base_source:3306"], "replica": [ "Cascaded1:3307" ] },
  "MultiSource:3306": { "source": [ "Another_source:3306", "Base_source:3306" ], "replica": [] },
  "Replica2:13306": { "source": [ "Base_source:3306" ], "replica": [] },
  "Cascaded1:3307": { "source": [ "Replica1:3306" ], "replica": [] } }
EOS
  is_deeply(from_json($prog->print_topology_json), from_json($expected_json), "JSON style");

  my $expected_dot= << "EOS";
digraph graph_name {
  "Another_source:3306" -> "MultiSource:3306"
  "Base_source:3306" -> "Circular1:3306"
  "Base_source:3306" -> "MultiSource:3306"
  "Base_source:3306" -> "Replica1:3306"
  "Base_source:3306" -> "Replica2:13306"
  "Circular1:3306" -> "Circular2:3306"
  "Circular2:3306" -> "Circular1:3306"
  "Replica1:3306" -> "Cascaded1:3307"
}
EOS
  is($prog->print_topology_dot, $expected_dot, "dot style");

  my $expected_member= << "EOS";
Another_source 3306
Base_source 3306
Cascaded1 3307
Circular1 3306
Circular2 3306
MultiSource 3306
Replica1 3306
Replica2 13306
EOS
  is($prog->print_topology_member, $expected_member, "member list");

  done_testing;
};

subtest "config description" => sub
{
  my $prog2= Ytkit::ReplTopology->new;
  unlike($prog2->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;

