#!/usr/bin/perl

#########################################################################
# Copyright (C) 2020, 2022  yoku0825
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

use Ytkit::IO;
no warnings "once";

subtest "Output message functions without --force" => sub
{
  subtest "no --silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(!(_infof("test")), "infof vs default should not be printed");
    ok(_notef("test"), "notef vs default should be printed");
    ok(_carpf("test"), "carpf vs default should be printed");
    ok(!(_debugf("test")), "debugf vs default should not be printed");

    eval
    {
      _croakf("test");
    };
    ok($@, "croakf vs default should be croaked");

    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::SILENT;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(!(_infof("test")), "infof vs --silent should not be printed");
    ok(!(_notef("test")), "notef vs --silent should not be printed");
    ok(!(_carpf("test")), "carpf vs --silent should not be printed");
    ok(!(_debugf("test")), "debugf vs --silent should not be printed");

    eval
    {
      _croakf("test");
    };
    ok($@, "croakf vs --silent should be croaked");

    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::VERBOSE;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(_infof("test"), "infof vs --verbose should be printed");
    ok(_notef("test"), "notef vs --verbose should be printed");
    ok(_carpf("test"), "carpf vs --verbose should be printed");
    ok(!(_debugf("test")), "debugf vs --verbose should not be printed");

    eval
    {
      _croakf("test");
    };
    ok($@, "croakf vs --verbose should be croaked");

    done_testing;
  };

  subtest "--verbose --verbose (twice)" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::DEBUG;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(_infof("test"), "infof vs --verbose should be printed");
    ok(_notef("test"), "notef vs --verbose should be printed");
    ok(_carpf("test"), "carpf vs --verbose should be printed");
    ok(_debugf("test"), "debugf vs --verbose should be printed");

    eval
    {
      _croakf("test");
    };
    ok($@, "croakf vs --verbose --verbose should be croaked");

    done_testing;
  };
};

subtest "Output message functions with --force(only effects _croakf)" => sub
{
  $ENV{ytkit_force}= 1;
  subtest "no --silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(!(_infof("test")), "infof vs default should not be printed");
    ok(_notef("test"), "notef vs default should be printed");
    ok(_carpf("test"), "carpf vs default should be printed");
    ok(!(_debugf("test")), "debugf vs default should not be printed");
    ok(_croakf("test"), "croakf treats as carp");

    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::SILENT;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(!(_infof("test")), "infof vs --silent should not be printed");
    ok(!(_notef("test")), "notef vs --silent should not be printed");
    ok(!(_carpf("test")), "carpf vs --silent should not be printed");
    ok(!(_debugf("test")), "debugf vs --silent should not be printed");
    ok(_croakf("test"), "croakf treats as carp(Not die but printed)");

    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::VERBOSE;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(_infof("test"), "infof vs --verbose should be printed");
    ok(_notef("test"), "notef vs --verbose should be printed");
    ok(_carpf("test"), "carpf vs --verbose should be printed");
    ok(!(_debugf("test")), "debugf vs --verbose should not be printed");
    ok(_croakf("test"), "croakf treats as carp");

    done_testing;
  };

  subtest "--verbose --verbose (twice)" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::DEBUG;
    ok(_printf("test"), "printf is not affected any verbose level");
    ok(_infof("test"), "infof vs --verbose should be printed");
    ok(_notef("test"), "notef vs --verbose should be printed");
    ok(_carpf("test"), "carpf vs --verbose should be printed");
    ok(_debugf("test"), "debugf vs --verbose should be printed");
    ok(_croakf("test"), "croakf treats as carp");

    done_testing;
  };
  $ENV{ytkit_force}= 0;
};

subtest "Extract ARRAYref and HASHref" => sub
{
  my $simple_arrayref= ["a", "b", "c", "d"];
  is(Ytkit::IO::__extract_ref($simple_arrayref), q|[a, b, c, d]|, "Simple ARRAYref");

  my $simple_hashref= { a => "b", c => "d" };
  is(Ytkit::IO::__extract_ref($simple_hashref), q|{a => b, c => d}|, "Simple HASHref");

  my $nested_arrayref= ["a", "b", "c", "d", ["e", "f", ["g"]]];
  is(Ytkit::IO::__extract_ref($nested_arrayref), q|[a, b, c, d, [e, f, [g]]]|, "Nested ARRAYref");

  my $nested_hashref= { a => "b", c => { d => { e => "f", g => "h" }, i => "j" } };
  is(Ytkit::IO::__extract_ref($nested_hashref), q|{a => b, c => {d => {e => f, g => h}, i => j}}|, "Nested HASHref");

  my $mixed= { a => "b", c => ["d", "e", "f"], g => "h" };
  is(Ytkit::IO::__extract_ref($mixed), q|{a => b, c => [d, e, f], g => h}|, "Mixed reference");

  is(_printf("bbb%sqqq", $mixed), qq|bbb{a => b, c => [d, e, f], g => h}qqq\n|, "Print via _printf");

  subtest "Issue #45" => sub
  {
    bless $mixed => "Ytkit::IO";
    is(Ytkit::IO::__extract_ref($mixed), q|{a => b, c => [d, e, f], g => h}|, "Blessed reference");
    done_testing;
  };

  done_testing;
};

subtest "Issue #31" => sub
{
  $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;

  local $SIG{__WARN__}= sub
  {
    ok(0, "Include \% character should not raise warnings");
  };
  ok(_notef("%s:%d", "%Y", 3306));
  done_testing;
};

subtest "split_host_port" => sub
{
  my ($host, $port);
  ($host, $port)= split_host_port("127.0.0.1:3309");
  is($host, "127.0.0.1", "host:port type host");
  is($port, 3309, "host:port type port");

  ($host, $port)= split_host_port("192.168.0.1");
  is($host, "192.168.0.1", "host type host");
  is($port, 3306, "host type port(default)");

  ($host, $port)= split_host_port("fe80::42:bdff:fe9a:f71e:3306");
  is($host, undef, "ipv6 should not parse");
  is($port, undef, "ipv6 should not parse");

  done_testing;
};

subtest "Output format" => sub
{
  is(_printf("test"), "test\n", "Without trailing-LF, add LF");
  is(_printf("test\n"), "test\n", "With trailing-LF, leave it");
  is(_printf("test\n\n"), "test\n", "With duplicated trailing-LF, remove duplicated LF(s)");

  $ENV{ytkit_force}= 0;
  $ENV{ytkit_verbose}= Ytkit::IO::DEBUG;

  is(_infof("test"), "INFO: test\n", "_infof adds INFO:");
  is(_infof("test\ntest2"), "INFO: test\nINFO: test2\n", "_infof adds INFO: each line");
  is(_notef("test"), "NOTE: test\n", "_notef adds NOTE:");
  is(_notef("test\ntest2"), "NOTE: test\nNOTE: test2\n", "_notef adds NOTE: each line");
  is(_carpf("test"), "WARNING: test\n", "_carpf adds WARNING:");
  is(_carpf("test\ntest2"), "WARNING: test\nWARNING: test2\n", "_carpf adds WARNING: each line");
  is(_debugf("test"), "DEBUG: test\n", "_debugf adds DEBUG:");
  is(_debugf("test\ntest2"), "DEBUG: test\nDEBUG: test2\n", "_debugf adds DEBUG: each line");

  eval
  {
    _croakf("test");
  };
  like($@, qr{ERROR: test\n}, "_croakf adds ERROR:");

  eval
  {
    _croakf("test\ntest2");
  };
  like($@, qr{ERROR: test\nERROR: test2\n}, "_croakf adds ERROR: each line");


  done_testing;
};

subtest "uniq_push_arrayref" => sub
{
  is_deeply(uniq_push_arrayref([1, 2, 3], (1, 2)), [1, 2, 3], "Same element was not pushed");
  is_deeply(uniq_push_arrayref([1, 2, 3], (1, 9)), [1, 2, 3, 9], "Different element was pushed");
  is_deeply(uniq_push_arrayref([3, 2, 1], (9, 8, 7)), [1, 2, 3, 7, 8, 9], "Result are sorted (as char)");
  is_deeply(uniq_push_arrayref([1], 2), [1, 2], "Push scalar");
  is_deeply(uniq_push_arrayref([1], ()), [1], "Push empty array");
  is_deeply(uniq_push_arrayref([1], undef), [1], "Push undef") or diag _infof uniq_push_arrayref([1], undef);
  is_deeply(uniq_push_arrayref([1], (2, undef)), [1, 2], "Push including undef") or diag _infof uniq_push_arrayref([1], (2, undef));

  done_testing;
};

done_testing;

