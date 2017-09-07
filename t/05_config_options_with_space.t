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
  doublequoted_space_with_equal    => {},
  doublequoted_space_without_equal => {},
  singlequoted_space_with_equal    => {},
  singlequoted_space_without_equal => {},
};

my @test_argv= (qq{--doublequoted_space_with_equal="s p a c e 1"},
                qq{--doublequoted_space_without_equal}, qq{"s p a c e 2"},
                qq{--singlequoted_space_with_equal="s p a c e 3"},
                qq{--singlequoted_space_without_equal}, qq{"s p a c e 4"},
                "this_should_be_left_in_argv",);

my $expected_opt= 
{
  doublequoted_space_with_equal    => "s p a c e 1",
  doublequoted_space_without_equal => "s p a c e 2",
  singlequoted_space_with_equal    => "s p a c e 3",
  singlequoted_space_without_equal => "s p a c e 4",
};

my @expected_argv= qw{ this_should_be_left_in_argv };
my ($got_opt, @got_argv)= options($option_struct, @test_argv);
is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");

done_testing;


exit 0;
