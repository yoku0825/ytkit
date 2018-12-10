package Ytkit::Config::File;

########################################################################
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
use Carp qw{ carp croak };

sub new
{
  my ($class, $file)= @_;

  if (!(-r $file))
  {
    carp("Can't read from $file");
    return undef;
  }

  open(my $fh, "<", $file);
  my @buff= <$fh>;
  close($fh);
  my $self= {};
  my $section;

  foreach (@buff)
  {
    chomp;
    ### Ignore Comment-line(#) or blank-line
    next if /^\s*(?:#|$)/;

    ### Section definition ([..]) line
    if (/^\[(?<section>[^\]]+)\]\s*$/)
    {
      $section= $+{section};
      next;
    }

    ### Others are parameter line.
    if (/^(?<name>[^-][^=\s]*)\s*=\s*(?<value>\S.+)$/)
    {
      ### long[-_]name=value style.
      push(@{$self->{$section}}, sprintf("--%s=%s", $+{name}, $+{value}));
    }
  }

  bless $self => $class;
  return $self;
}


return 1;
