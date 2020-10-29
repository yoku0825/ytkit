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
      mandatory => $opt->{mandatory} // undef,
      deprecated => $opt->{deprecated} // undef,
    }
  }

  bless $self => $class;
  return $self;
}

sub check_mandatory
{
  my ($self)= @_;
  return 1 if !($self->{mandatory});

  ### Empty
  return 0 if !($self->{value});
  ### Empty array
  return 0 if ref($self->{value}) eq "ARRAY" && !(@{$self->{value}});

  ### mandatory && has value
  return 1;
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
    _carpf("Option %s is now deprecated.", $self->{alias}) if $self->{deprecated};
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

      _carpf($msg);
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
    &$isa($value);
    return 1;
  }
}

sub extract_for_usage
{
  my ($self)= @_;

  ### Decide to print "-s=value" or "-s"
  my $arg;
  if ($self->{noarg})
  {
    $arg= "";
  }
  else
  {
    ### Don't display functional isa 
    if ($self->{isa} && ref($self->{isa}) ne "CODE")
    {
      $arg= _sprintf("=%s", $self->{isa});
    }
    else
    {
      $arg= "=value";
    }
  }

  ### If multi => 1, add "(multiple)" after aliases.
  my $multi= $self->{multi} ? " (multiple)" : "";

  ### Add default information.
  my $default= (exists($self->{default}) && length($self->{default} // "") > 0 && !($self->{noarg})) ? 
                 _sprintf(" { Default: %s }", $self->{default}) : 
                 "";

  ### Expand each aliases
  my @aliases= map { _sprintf("%s%s", _alias_as_opt($_), $arg) } @{$self->{alias}};

  return _sprintf("* %s%s%s\n  %s\n", join(", ", sort(@aliases)), $multi, $default, $self->{text});
}

sub _alias_as_opt
{
  my ($alias)= @_;
  
  if (length($alias) == 1)
  {
    ### 1 character alias must specified with single-hyphen.
    return _sprintf("-%s", $alias);
  }
  else
  {
    ### 2 or more characters must specified with double-hypen.
    return _sprintf("--%s", $alias);
  }
}

sub longest_alias
{
  my ($self)= @_;
  my $longest= "";

  foreach (@{$self->{alias}})
  {
    $longest= $_ if length($longest) < length($_);
  }

  return $longest;
}

sub default_option_print
{
  my ($self)= @_;
  if (!($self->{default}))
  {
    return "";
  }
  elsif (ref($self->{default}) eq "ARRAY" && !(@{$self->{default}}))
  {
    return "";
  }

  my $left = _alias_as_opt($self->longest_alias);
  my $right= $self->{noarg} ? "" : _sprintf("=%s", $self->{default});
  return $left . $right;
}


return 1;
