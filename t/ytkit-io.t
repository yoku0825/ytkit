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
no warnings "once";

subtest "Output message functions" => sub
{
  subtest "no --silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;
    ok(!(_infof("TEST")), "infof vs default should not be printed");
    ok(_notef("TEST"), "notef vs default should be printed");
    ok(_carpf("TEST"), "carpf vs default should be printed");
    ok(!(_debugf("TEST")), "debugf vs default should not be printed");

    eval
    {
      _croakf("TEST");
    };
    ok($@, "croakf vs default should be croaked");

    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::SILENT;
    ok(!(_infof("TEST")), "infof vs --silent should not be printed");
    ok(!(_notef("TEST")), "notef vs --silent should not be printed");
    ok(!(_carpf("TEST")), "carpf vs --silent should not be printed");
    ok(!(_debugf("TEST")), "debugf vs --silent should not be printed");

    eval
    {
      _croakf("TEST");
    };
    ok($@, "croakf vs --silent should be croaked");

    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::VERBOSE;
    ok(_infof("TEST"), "infof vs --verbose should be printed");
    ok(_notef("TEST"), "notef vs --verbose should be printed");
    ok(_carpf("TEST"), "carpf vs --verbose should be printed");
    ok(!(_debugf("TEST")), "debugf vs --verbose should not be printed");

    eval
    {
      _croakf("TEST");
    };
    ok($@, "croakf vs --verbose should be croaked");

    done_testing;
  };

  subtest "--verbose --verbose (twice)" => sub
  {
    $ENV{ytkit_verbose}= Ytkit::IO::DEBUG;
    ok(_infof("TEST"), "infof vs --verbose should be printed");
    ok(_notef("TEST"), "notef vs --verbose should be printed");
    ok(_carpf("TEST"), "carpf vs --verbose should be printed");
    ok(_debugf("TEST"), "debugf vs --verbose should be printed");

    eval
    {
      _croakf("TEST");
    };
    ok($@, "croakf vs --verbose --verbose should be croaked");

    done_testing;
  };
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


  done_testing;
};

subtest "Issue #31" => sub
{
  $ENV{ytkit_verbose}= 1;

  local $SIG{__WARN__}= sub
  {
    ok(0, "Include \% character should not raise warnings");
  };
  ok(_notef("%s:%d", "%Y", 3306));
  done_testing;
};

done_testing;

