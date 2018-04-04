#!/usr/bin/perl

#########################################################################
# Copyright (C) 2018  yoku0825
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
use Test::More::Color qw{foreground};

use FindBin qw{$Bin};
use lib "$Bin/../lib";
use Ytkit::MySQLServer;

no warnings "once";

### Connection failed.
my $server;
eval
{
  $server= Ytkit::MySQLServer->new({host => "localhost"});
};
ok(!(defined($server->{conn})), "Connection failed");

### Dummy instance.
$server= do { bless {} => "Ytkit::MySQLServer" };
is($server->hostname, "Can't fetch hostname", "test");
$server->{conn}= "dummy";

subtest "show_slave_status" => sub
{
  require "$Bin/data/06_show_slave_status_ok.txt";
  $server->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;
  is_deeply($server->show_slave_status, $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1, "SHOW SLAVE STATUS");
  delete($server->{_show_slave_status});
};

subtest "show_processlist" => sub
{
  require "$Bin/data/06_show_processlist.txt";
  $server->{_show_processlist}= $Ytkit::Test::SHOW_PROCESSLIST::VAR1;
  is_deeply($server->show_processlist, $Ytkit::Test::SHOW_PROCESSLIST::VAR1, "SHOW PROCESSLIST");
  delete($server->{_show_processlist});
};

subtest "show_status" => sub
{
  require "$Bin/data/06_show_status.txt";
  $server->{_show_status}   = $Ytkit::Test::SHOW_STATUS::VAR1;
  is_deeply($server->show_status, $Ytkit::Test::SHOW_STATUS::VAR1, "SHOW STATUS");
  delete($server->{_show_status});
};

subtest "show_variables" => sub
{
  require "$Bin/data/06_show_variables.txt";
  $server->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  is_deeply($server->show_variables, $Ytkit::Test::SHOW_VARIABLES::VAR1, "SHOW VARIABLES");
  delete($server->{_show_variables});
};

subtest "show_master_logs" => sub
{
  require "$Bin/data/show_master_logs.txt";
  $server->{_show_master_logs}= $Ytkit::Test::SHOW_MASTER_LOGS::VAR1;
  is_deeply($server->show_master_logs, $Ytkit::Test::SHOW_MASTER_LOGS::VAR1, "SHOW MASTER LOGS");
  delete($server->{_show_master_logs});
};

done_testing;
