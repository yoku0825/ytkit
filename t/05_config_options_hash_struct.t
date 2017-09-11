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
  parent => { child1 => { default => "aaa" },
              child2 => { default => "bbb" },
              child3 => { alias => ["c"], default => "ddd" }, },

};

my @test_argv= qw{
                   --parent-child1="ccc"
                   this_should_be_left_in_argv
                   -c eee
                 };

my $expected_opt= 
{
  parent_child1 => "ccc",
  parent_child2 => "bbb",
  parent_child3 => "eee",
};

my @expected_argv= qw{ this_should_be_left_in_argv };
my ($got_opt, @got_argv)= options($option_struct, @test_argv);
is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");

done_testing;


exit 0;
