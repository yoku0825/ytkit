#!/usr/bin/perl

#########################################################################
# Copyright (C) 2018, 2019  yoku0825
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

use_ok("Ytkit", "use Ytkit");

subtest "Output message functions" => sub
{
  my $ytkit= {};
  bless $ytkit => "Ytkit";

  subtest "no --silent and no --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (0, 0);
    ok(!($ytkit->fix_common_options), "Not adjust");
    ok($ytkit->infof("TEST"), "infof vs default should be printed");
    ok($ytkit->notef("TEST"), "notef vs default should be printed");
    ok($ytkit->carpf("TEST"), "carpf vs default should be printed");
    ok(!($ytkit->debugf("TEST")), "debugf vs default should not be printed");

    eval
    {
      $ytkit->croakf("TEST");
    };
    ok($@, "croakf vs default should be croaked");

    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (1, 0);
    ok(!($ytkit->fix_common_options), "Not adjust");
    ok(!($ytkit->infof("TEST")), "infof vs --silent should not be printed");
    ok(!($ytkit->notef("TEST")), "notef vs --silent should not be printed");
    ok(!($ytkit->carpf("TEST")), "carpf vs --silent should not be printed");
    ok(!($ytkit->debugf("TEST")), "debugf vs --silent should not be printed");

    eval
    {
      $ytkit->croakf("TEST");
    };
    ok($@, "croakf vs --silent should be croaked");

    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (0, 1);
    ok(!($ytkit->fix_common_options), "Not adjust");
    ok($ytkit->infof("TEST"), "infof vs --verbose should be printed");
    ok($ytkit->notef("TEST"), "notef vs --verbose should be printed");
    ok($ytkit->carpf("TEST"), "carpf vs --verbose should be printed");
    ok($ytkit->debugf("TEST"), "debugf vs --verbose should be printed");

    eval
    {
      $ytkit->croakf("TEST");
    };
    ok($@, "croakf vs --verbose should be croaked");

    done_testing;
  };

  subtest "--silent and --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (1, 1);
    ok($ytkit->fix_common_options, "Adjust to no --silent and --verbose");
    is($ytkit->{silent}, 0, "Turn off --silent");
    is($ytkit->{verbose}, 1, "Keep --verbose");
    ### After that, as same as "no --silent and --verbose"
    done_testing;
  };
  done_testing;
};

subtest "Issue #31" => sub
{
  my $ytkit= {};
  bless $ytkit => "Ytkit";

  local $SIG{__WARN__}= sub
  {
    ok(0, "Include \% character should not raise warnings");
  };
  ok($ytkit->infof("%s:%d", "%Y", 3306));
  done_testing;
};

subtest "Issue #34" => sub
{
  my $ret= `$Bin/../bin/yt-binlog-groupby -h 2>&1`;
  chomp($ret);
  unlike($ret, qr{Can't locate object method});
  done_testing; 
};


my $basedir= "$Bin/../";
my @db_single= `grep -r DB::single --exclude=ytkit.t --exclude=HEAD --exclude=COMMIT_EDITMSG --exclude=master $basedir`;
ok(!(@db_single), "DB::single has been removed.");

done_testing;

