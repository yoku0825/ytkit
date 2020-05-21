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
require "$Bin/Test.pl";

use_ok("Ytkit::RenameDatabase");
use Ytkit::IO;

ok(my $prog= Ytkit::RenameDatabase->new("--to=d2", "--from=d1"), "aaa");

subtest "config description" => sub
{
  unlike($prog->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;

