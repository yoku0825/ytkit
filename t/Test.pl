package Ytkit::Test;

#########################################################################
# Copyright (C) 2018  yoku0825
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
use FindBin qw{$Bin};

use Exporter qw{ import };
our @EXPORT= qw{ read_file };

### Load data/*.txt
foreach (glob("$Bin/data/*.pl"))
{
  require $_;
}

### STDOUT, STDERR changing for test
_turn_off_stdouts() if ($ENV{HARNESS_ACTIVE});

sub read_file
{
  my ($filename)= @_;
  open(my $fh, "<", $filename);
  my @buff= <$fh>;
  close($fh);
  return join("", @buff);
}

sub _turn_off_stdouts
{
  close(STDOUT);
  open(STDOUT, ">", "/dev/null");
  close(STDERR);
  open(STDERR, ">", "/dev/null");
}

return 1;
