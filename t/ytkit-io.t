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

use Ytkit::IO;
use constant TEST_STR => "TEST\n";
use constant DEBUG_STR => "DEBUG: TEST\n";
no warnings "once";

subtest "Output message functions without --force" => sub
{
  subtest "no --silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), undef, "infof vs default should not be printed");
    is(_notef(TEST_STR), TEST_STR, "notef vs default should be printed");
    is(_carpf(TEST_STR), TEST_STR, "carpf vs default should be printed");
    is(_debugf(TEST_STR), undef, "debugf vs default should not be printed");

    eval
    {
      _croakf(TEST_STR);
    };
    ok($@, "croakf vs default should be croaked");

    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::SILENT;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), undef, "infof vs --silent should not be printed");
    is(_notef(TEST_STR), undef, "notef vs --silent should not be printed");
    is(_carpf(TEST_STR), undef, "carpf vs --silent should not be printed");
    is(_debugf(TEST_STR), undef, "debugf vs --silent should not be printed");

    eval
    {
      _croakf(TEST_STR);
    };
    ok($@, "croakf vs --silent should be croaked");

    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::VERBOSE;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), TEST_STR, "infof vs --verbose should be printed");
    is(_notef(TEST_STR), TEST_STR, "notef vs --verbose should be printed");
    is(_carpf(TEST_STR), TEST_STR, "carpf vs --verbose should be printed");
    is(_debugf(TEST_STR), undef, "debugf vs --verbose should not be printed");

    eval
    {
      _croakf(TEST_STR);
    };
    ok($@, "croakf vs --verbose should be croaked");

    done_testing;
  };

  subtest "--verbose --verbose (twice)" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::DEBUG;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), TEST_STR, "infof vs --verbose should be printed");
    is(_notef(TEST_STR), TEST_STR, "notef vs --verbose should be printed");
    is(_carpf(TEST_STR), TEST_STR, "carpf vs --verbose should be printed");
    is(_debugf(TEST_STR), DEBUG_STR, "debugf vs --verbose should be printed");

    eval
    {
      _croakf(TEST_STR);
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
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), undef, "infof vs default should not be printed");
    is(_notef(TEST_STR), TEST_STR, "notef vs default should be printed");
    is(_carpf(TEST_STR), TEST_STR, "carpf vs default should be printed");
    is(_debugf(TEST_STR), undef, "debugf vs default should not be printed");
    is(_croakf(TEST_STR), TEST_STR, "croakf treats as carp");

    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::SILENT;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), undef, "infof vs --silent should not be printed");
    is(_notef(TEST_STR), undef, "notef vs --silent should not be printed");
    is(_carpf(TEST_STR), undef, "carpf vs --silent should not be printed");
    is(_debugf(TEST_STR), undef, "debugf vs --silent should not be printed");
    is(_croakf(TEST_STR), TEST_STR, "croakf treats as carp(Not die but printed)");

    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::VERBOSE;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), TEST_STR, "infof vs --verbose should be printed");
    is(_notef(TEST_STR), TEST_STR, "notef vs --verbose should be printed");
    is(_carpf(TEST_STR), TEST_STR, "carpf vs --verbose should be printed");
    is(_debugf(TEST_STR), undef, "debugf vs --verbose should not be printed");
    is(_croakf(TEST_STR), TEST_STR, "croakf treats as carp");

    done_testing;
  };

  subtest "--verbose --verbose (twice)" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::DEBUG;
    is(_printf(TEST_STR), TEST_STR, "printf is not affected any verbose level");
    is(_infof(TEST_STR), TEST_STR, "infof vs --verbose should be printed");
    is(_notef(TEST_STR), TEST_STR, "notef vs --verbose should be printed");
    is(_carpf(TEST_STR), TEST_STR, "carpf vs --verbose should be printed");
    is(_debugf(TEST_STR), DEBUG_STR, "debugf vs --verbose should be printed");
    is(_croakf(TEST_STR), TEST_STR, "croakf treats as carp");

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

  is(_notef("bbb%sqqq", $mixed), qq|bbb{a => b, c => [d, e, f], g => h}qqq\n|, "Print via _notef");

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

done_testing;

