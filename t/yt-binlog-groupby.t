#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017, 2018  yoku0825
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
use Ytkit::BinlogGroupby;

subtest "--group-by=all" => sub
{
  run_test("01_parse_sbr_57.txt", "01_parse_sbr_57.r", qw{--group-by=all --cell=1m --output=tsv});
  run_test("01_parse_rbr_57.txt", "01_parse_rbr_57.r", qw{--group-by=all --cell=1m --output=tsv});
};

subtest "--group-by=all,exec" => sub
{
  no warnings "qw";
  run_test("01_parse_sbr_57.txt", "01_parse_sbr_57_all_exec.r", qw{--group-by=all,exec --cell=1m --output=tsv});
};

done_testing;


exit 0;


sub run_test
{
  my ($infile, $resultfile, @argv)= @_;

  my $prog= Ytkit::BinlogGroupby->new(@argv);
  open(my $in, "<", sprintf("%s/data/%s", $Bin, $infile)) or die;
  open(my $expect, "<", sprintf("%s/data/%s", $Bin, $resultfile)) or die;
  
  while (<$in>)
  {
    $prog->parse($_);
  }

  my @expect= <$expect>;
  close($in);
  close($expect);

  is_deeply($prog->output, \@expect, $resultfile);
}
