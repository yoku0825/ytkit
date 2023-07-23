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

use_ok("Ytkit");
use Ytkit::IO;

subtest "Adjust between --silent and --verbose" => sub
{
  my $ytkit= {};
  bless $ytkit => "Ytkit";

  subtest "No --silent and no --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (0, 0);
    $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;
    ok(!($ytkit->fix_common_options), "Not adjust options");
    is($ENV{ytkit_verbose}, Ytkit::IO::NORMAL, "Not adjust ENV{ytkit_verbose}");
    done_testing;
  };

  subtest "--silent and no --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (1, 0);
    $ENV{ytkit_verbose}= Ytkit::IO::SILENT;
    ok(!($ytkit->fix_common_options), "Not adjust");
    is($ENV{ytkit_verbose}, Ytkit::IO::SILENT, "Not adjust ENV{ytkit_verbose}");
    done_testing;
  };

  subtest "no --silent and --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (0, 1);
    $ENV{ytkit_verbose}= Ytkit::IO::VERBOSE;
    ok(!($ytkit->fix_common_options), "Not adjust");
    is($ENV{ytkit_verbose}, Ytkit::IO::VERBOSE, "Not adjust ENV{ytkit_verbose}");
    done_testing;
  };

  subtest "--silent and --verbose" => sub
  {
    @{$ytkit}{"silent", "verbose"}= (1, 1);
    $ENV{ytkit_verbose}= Ytkit::IO::NORMAL;
    ok($ytkit->fix_common_options, "Adjust to no --silent and --verbose");
    is($ENV{ytkit_verbose}, Ytkit::IO::VERBOSE, "Adjust ENV{ytkit_verbose} (same as --verbose)");
    ### After that, as same as "no --silent and --verbose"
    done_testing;
  };
  done_testing;
};

subtest "Issue #34" => sub
{
  my $ret= `$Bin/../bin/yt-binlog-groupby -h 2>&1`;
  chomp($ret);
  unlike($ret, qr{Can't locate object method});
  done_testing; 
};

subtest "copy_connect_param" => sub
{
  my $ytkit= {};
  bless $ytkit => "Ytkit";

  $ytkit->{user}= "ytkituser";
  $ytkit->{host}= "ytkithost";
  $ytkit->{port}= undef;  ### should be ignored
  $ytkit->{not_connect_param}= "test";      ### should be ignored

  is(join(" ", $ytkit->copy_connect_param),
     "--host='ytkithost' --password='' --timeout='1' --user='ytkituser'",
     "user, host, password, timeout");

  $ytkit->{ask_pass}= 0;
  is(join(" ", $ytkit->copy_connect_param),
     "--host='ytkithost' --password='' --timeout='1' --user='ytkituser'",
     "--ask_pass is noarg option, skipped");

  $ytkit->{ask_pass}= 1;
  is(join(" ", $ytkit->copy_connect_param),
     "--ask_pass --host='ytkithost' --password='' --timeout='1' --user='ytkituser'",
     "--ask_pass is noarg option, but specified, appear in copy");

  done_testing;
};

my $basedir= "$Bin/../";
my @db_single= `grep -r DB::single --exclude=ytkit.t --exclude-dir=.git $basedir`;
ok(!(@db_single), "DB::single has been removed.");

done_testing;

