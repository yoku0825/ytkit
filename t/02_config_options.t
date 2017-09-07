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

my $option_struct=
{
  long_with_equal            => { alias => ["long-with-equal"] },
  long_without_equal         => { alias => ["long-without-equal"] },
  long_bool                  => { alias => ["long-bool"] },
  short_with_equal           => { alias => ["E"] },
  short_without_equal        => { alias => ["N"] },
  short_bool                 => { alias => ["A"] },
  quoted_long_with_equal     => { alias => ["quoted-long-with-equal"] },
  quoted_long_without_equal  => { alias => ["quoted-long-without-equal"] },
  quoted_short_with_equal    => { alias => ["Q"] },
  quoted_short_without_equal => { alias => ["R"] },
};

my @test_argv= qw{
                    --long-with-equal=LONG_WITH_EQUAL
                    --long-without-equal LONG_WITHOUT_EQUAL
                    --long-bool
                    -E=SHORT_WITH_EQUAL
                    -N SHORT_WITHOUT_EQUAL
                    -A
                    --quoted-long-with-equal="QUOTED_LONG_WITH_EQUAL"
                    --quoted-long-without-equal "QUOTED_LONG_WITHOUT_EQUAL"
                    -Q="QUOTED_SHORT_WITH_EQUAL"
                    -R "QUOTED_SHORT_WITHOUT_EQUAL"
                    this_should_be_left_in_argv
                    this_should_be_left_in_argv_too
                 };

my $expected_opt= 
{
  long_with_equal            => "LONG_WITH_EQUAL",
  long_without_equal         => "LONG_WITHOUT_EQUAL",
  long_bool                  => 1,
  short_with_equal           => "SHORT_WITH_EQUAL",
  short_without_equal        => "SHORT_WITHOUT_EQUAL",
  short_bool                 => 1,
  quoted_long_with_equal     => "QUOTED_LONG_WITH_EQUAL",
  quoted_long_without_equal  => "QUOTED_LONG_WITHOUT_EQUAL",
  quoted_short_with_equal    => "QUOTED_SHORT_WITH_EQUAL",
  quoted_short_without_equal => "QUOTED_SHORT_WITHOUT_EQUAL",
};

my @expected_argv= qw{ this_should_be_left_in_argv this_should_be_left_in_argv_too };
my ($got_opt, @got_argv)= options($option_struct, @test_argv);
is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");

done_testing;


exit 0;
