#!/usr/bin/perl

#########################################################################
# Copyright (C) 2022  yoku0825
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

no warnings "once";

use_ok("Ytkit::ReplTopology");

subtest "Basic behavior" => sub
{
  ok(my $prog= Ytkit::ReplTopology->new("--host=test.com", "--port=33061"), "Init");
  is_deeply($prog->{_candidate_port}, [33061], "Initial candidate_port");
  is_deeply($prog->{_candidate_ipaddr}, ["test.com"], "Initial candidate_port");
  
  $prog->instance->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS::with_channel;
  $prog->instance->{_show_slave_hosts}= $Ytkit::Test::SHOW_SLAVE_HOSTS::TWO_HOSTS;
  $prog->instance->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::processlist_at_master_gtid;
  
  $prog->search_candidate_port;
  $DB::single= 1;
  $prog->search_candidate_ipaddr;
  
  is_deeply($prog->{_candidate_port}, [20796, 20797, 3306, 33061], "Updated candidate_port");
  is_deeply($prog->{_candidate_ipaddr}, ["172.17.0.3", "172.17.0.5", "localhost", "test.com"], "Updated candidate_port");

  done_testing;
};

subtest "config description" => sub
{
  my $prog2= Ytkit::ReplTopology->new;
  unlike($prog2->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;

