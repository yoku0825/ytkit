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
use Ytkit::BinlogGroupby;


my $opt=
{
  group_by => "all",
  cell     => "1m",
  output   => "tsv",
};

foreach my $filename_txt (glob("$Bin/data/01_*.txt"))
{
  my $prog= Ytkit::BinlogGroupby->new($opt);
  my $filename_r= $filename_txt;
  $filename_r =~ s/\.txt\z/.r/;
  open(my $in, "<", $filename_txt) or die;
  print $filename_r;
  open(my $expect, "<", $filename_r) or die;

  while (<$in>)
  {
    $prog->parse($_);
  }
  my @expect= <$expect>;
  close($in);
  close($expect);

  is_deeply(@{$prog->output}, @expect);
}

done_testing;


exit 0;
