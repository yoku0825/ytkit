package Ytkit::Config::Option;

########################################################################
# Copyright (C) 2018, 2020  yoku0825
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
use Ytkit::IO;

sub new
{
  my ($class, $opt)= @_;
  my $self;

  if (ref($opt) eq "ARRAY")
  {
    ### { param_name => ["aliases"] } style.
    $self->{alias}= $opt;
  }
  elsif (ref($opt) eq "HASH")
  {
    $self=
    {
      multi   => $opt->{multi} // undef,
      noarg   => $opt->{noarg} // undef,
      isa     => $opt->{isa} // undef,
      value   => $opt->{multi} ? 
                   $opt->{default} ? [$opt->{default}] : [] :
                   $opt->{default} // undef,
      alias   => _normalize_hyphen($opt->{alias}) // undef,
      default => $opt->{default} // undef,
      text    => $opt->{text} // "FIXME: This option doesn't have description",
    }
  }

  bless $self => $class;
  return $self;
}

sub _normalize_hyphen
{
  my ($array)= @_;
  return undef if !($array);
  my @ret;

  foreach (@$array)
  {
    s/-/_/g;
    push(@ret, $_);
  }
  return \@ret;
}

sub set_value
{
  my ($self, $value)= @_;

  ### Return 0 means 
  ###   "Need next argument, please call me again with next argument"
  if ($value =~ /^"([^"]*)/)
  {
    ### Start with doublequote should be ended with doublequote.
    return 0 if !($value =~ /"$/);

    ### Trim doublequote.
    $value =~ s/^"([^"]*)"$/$1/;
  }
  elsif ($value =~ /^'([^']*)/)
  {
    ### Start with singlequote should be ended with singlequote.
    return 0 if !($value =~ /'$/);

    ### Trim singlequote
    $value =~ s/^'([^']*)'$/$1/;
  }

  if ($self->{multi})
  {
    push(@{$self->{value}}, $value);
  }
  else
  {
    if (_check_isa($value, $self->{isa}))
    {
      $self->{value}= $value;
    }
    else
    {
      my $msg= sprintf("%s is not satisfied %s", $value,
                       ref($self->{isa}) eq "ARRAY" ?
                         "[" . join(", ", @{$self->{isa}}) . "]" :
                         $self->{isa});

      _carpf($msg) if !($ENV{HARNESS_ACTIVE});
    }
  }
  return 1;
}

sub _check_isa
{
  my ($value, $isa)= @_;
  return 1 if !(defined($isa));

  ### Validation.
  if (ref($isa) eq "ARRAY")
  {
    ### Array-style isa, grep
    return grep {$value eq $_} @$isa;
  }
  elsif (ref($isa) eq "Regexp")
  {
    ### Evaluate regexp
    return $value =~ $isa;
  }
  elsif (ref($isa) eq "CODE")
  {
    &$isa;
    return 1;
  }
}

return 1;
