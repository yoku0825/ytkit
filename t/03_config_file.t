#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017  yoku0825
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
use Ytkit::Config;


my $org_opt=
{
  should_not_erace => 1,
  duplicate_option => "from command-line option",
};

my $expected_opt= 
{
  long_with_equal        => "LONG_WITH_EQUAL",
  long_bool              => 1,
  quoted_long_with_equal => "QUOTED_LONG_WITH_EQUAL",
  should_not_erace       => 1,
  duplicate_option       => "from command-line option",
};

my $config_file   = "$Bin/data/03_config.txt";
my $config_section= "ytkit_test";
my $got_opt= load_config($org_opt, $config_file, $config_section);

is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::load_config");

done_testing;


exit 0;
