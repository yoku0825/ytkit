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
  unset_alias             => {},
  set_default             => { alias => ["set-default"], default => "this_is_default" },
  test_array_isa_fail     => { isa => [qw{test}] },
  test_array_isa_success  => { isa => [qw{test}] },
  test_regexp_isa_fail    => { isa => qr{test} },
  test_regexp_isa_success => { isa => qr{test} },
};

my @test_argv= qw{
                    --unset_alias "parse_correctry"
                    --test_array_isa_fail="this_should_be_fail"
                    --test_array_isa_success="test"
                    --test_regexp_isa_fail="THIS_IS_FAIL_TEST"
                    --test_regexp_isa_success="this_is_success_test"
                    this_should_be_left_in_argv
                 };

my $expected_opt= 
{
  unset_alias             => "parse_correctry",
  set_default             => "this_is_default",
  test_array_isa_fail     => undef,
  test_array_isa_success  => "test",
  test_regexp_isa_fail    => undef,
  test_regexp_isa_success => "this_is_success_test",
};

my @expected_argv= qw{ this_should_be_left_in_argv };
my ($got_opt, @got_argv)= options($option_struct, @test_argv);
is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");

done_testing;


exit 0;
