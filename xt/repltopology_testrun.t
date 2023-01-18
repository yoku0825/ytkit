#!/usr/bin/perl

#########################################################################
# Copyright (C) 2023  yoku0825
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
use Ytkit::ReplTopology;

my $source= $Ytkit::xTest::version->{$Ytkit::xTest::mysql80};

$source->{my_cnf}=
{
  server_id => 1,
  log_bin   => "mysql-bin",
};
my $source_mysqld= Test::mysqld->new($source);

subtest "Issue #80" => sub
{
  my $warn_count= 0;
  local $SIG{__WARN__}= sub
  {
    $warn_count++;
  };

  my $prog= Ytkit::ReplTopology->new("--host=localhost",
                                     "--socket", $source_mysqld->base_dir . "/tmp/mysql.sock",
                                     "--user=root");
  $prog->run;
  is($warn_count, 0, "Success");
};


done_testing;
