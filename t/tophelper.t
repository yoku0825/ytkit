#!/usr/bin/perl

#########################################################################
# Copyright (C) 2026  yoku0825
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
use Test::More;

use FindBin qw{$Bin};
use lib "$Bin/../lib";

no warnings "once";
use_ok("Ytkit::TopHelper");

my $example=
[
  { a => 1, b => 2, c => 3 },
  { a => 2, b => 1, c => 4 },
];

is_deeply(sort_result_by($example, "a"),
          { 1 => [ { a => 1, b => 2, c => 3 } ], 2 => [ { a => 2, b => 1, c => 4 } ] },
          "sort_result_by a");
is_deeply(sort_result_by($example, "b"),
          { 1 => [ { a => 2, b => 1, c => 4 } ], 2 => [ { a => 1, b => 2, c => 3 } ] },
          "sort_result_by b");

done_testing;
