#!/usr/bin/perl

#########################################################################
# Copyright (C) 2020, 2021  yoku0825
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

use_ok("Ytkit::AdminTool");

is(scalar(@{Ytkit::AdminTool::DDL::admintool_schema()}), 10, "10 tables in admintool");
is(scalar(@{Ytkit::AdminTool::DDL::adminview_schema()}), 17, "17 views in adminview");
is(scalar(@{Ytkit::AdminTool::DDL::adminview_schema_ex()}), 13, "13 views in adminview(8.0 only)");


done_testing;

