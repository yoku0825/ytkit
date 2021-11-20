#!/usr/bin/perl

#########################################################################
# Copyright (C) 2021  yoku0825
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

use JSON qw{ to_json };
use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/Test.pl";
no warnings "once";

use_ok("Ytkit::Config::CLI");

subtest "Basic usage" => sub
{
  my $option=
  {
    MYSQL_PWD => { alias => ["password", "p"] },
    MYSQL_HOST => { alias => ["host", "h"] },
    MYSQL_PORT => { alias => ["port", "P"], default => 3306 },
  };
  ok(my $variable_parser= Ytkit::Config::CLI->new("--json", to_json($option), "--output=variable", "--host=127.0.0.1", "--no-defined=999"), "--output=variable");
  is($variable_parser->print, "export MYSQL_HOST=127.0.0.1 MYSQL_PORT=3306 MYSQL_PWD=", "variable compare");

  ok(my $command_parser= Ytkit::Config::CLI->new("--json", to_json($option), "--output=command", "--host=127.0.0.1", "--no-defined=999", "--program=mysql"), "--output=command");
  is($command_parser->print, "MYSQL_HOST=127.0.0.1 MYSQL_PORT=3306 MYSQL_PWD= mysql --no-defined=999", "command compare");

  done_testing;
};

done_testing;

exit 0;
