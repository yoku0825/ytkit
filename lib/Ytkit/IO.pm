package Ytkit::IO;

########################################################################
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

use Carp qw{ carp croak };
use Term::ReadKey;
use base "Exporter";
our @EXPORT= qw{ _infof _notef _carpf _croakf _debugf _sprintf _printf split_host_port };

use constant
{
  SILENT => 0,
  NORMAL => 1,
  VERBOSE => 2,
  DEBUG => 3,
};
$ENV{ytkit_verbose} //= NORMAL;
$ENV{ytkit_force} //= 0;

sub split_host_port
{
  ### aaa:bbb -> (aaa, bbb), ccc -> (ccc, 3306)
  my ($str)= @_;

  my ($ipaddr, $port)= $str =~ /^([^:]+)(?::)?(\d+)?$/;
  $port //= 3306; ### default
  return undef if !($ipaddr);

  return ($ipaddr, $port);
}

sub _notef ### NORMAL, VERBOSE, DEBUG (Not --silent)
{
  my ($format, @argv)= @_;

  return undef if $ENV{ytkit_verbose} < NORMAL;
  return __out_stdout($format, @argv);
}

sub _infof ### VERBOSE, DEBUG (Only --verbose)
{
  my ($format, @argv)= @_;

  return undef if $ENV{ytkit_verbose} < VERBOSE;
  return __out_stdout($format, @argv);
}

sub _debugf ### DEBUG (Only --verbose --verbose (twice))
{
  my ($format, @argv)= @_;

  return undef if $ENV{ytkit_verbose} < DEBUG;
  return __out_stderr("DEBUG: %s", _sprintf($format, @argv));
}

sub _croakf
{
  my ($format, @argv)= @_;

  my $msg= _sprintf($format, @argv);

  if ($ENV{ytkit_force})
  {
    ### with --force, falling back carp.
    carp($msg);
  }
  else
  {
    croak($msg);
  }
  return $msg; ### Maybe this is not returned.
}

sub _carpf ### NORMAL, VERBOSE, DEBUG (Not --silent)
{
  my ($format, @argv)= @_;

  return undef if $ENV{ytkit_verbose} < NORMAL;
  my $msg= _sprintf($format, @argv);
  carp($msg);
  return $msg;
}

sub __out_stdout
{
  my ($format, @argv)= @_;

  my $msg= _sprintf($format, @argv);
  $msg .= "\n" if (substr($msg, -1, 1) ne "\n");
  print(STDOUT $msg);
  return $msg;
}

sub __out_stderr
{
  my ($format, @argv)= @_;

  my $msg= _sprintf($format, @argv);
  $msg .= "\n" if (substr($msg, -1, 1) ne "\n");
  print(STDERR $msg);
  return $msg;
}

sub _printf
{
  my ($format, @argv)= @_;
  return __out_stderr($format, @argv);
}

sub _sprintf
{
  my ($format, @argv)= @_;
  if (!(@argv))
  {
    ### Only pass 1 argv without format.
    push(@argv, $format);
    $format= "%s";
  }
  return sprintf($format, map { __extract_ref($_) } @argv);
}

sub __extract_ref
{
  my ($element)= @_;
  return "" if !(defined($element));
  my @ret;

  if (ref($element) eq "HASH" || 
      ref($element) =~ /^Ytkit::/) ### Treat blessed reference as same as HASH
  {
    foreach (sort(keys(%$element)))
    {
      push(@ret, sprintf("%s => %s", $_, __extract_ref($element->{$_})));
    }
    return sprintf("{%s}", join(", ", @ret));
  }
  elsif (ref($element) eq "ARRAY")
  {
    foreach (@$element)
    {
      push(@ret, __extract_ref($_));
    }
    return sprintf("[%s]", join(", ", @ret));
  }
  return $element;
}

sub _ask_password
{
  Term::ReadKey::ReadMode("noecho");
  print "Password: ";
  my $password= Term::ReadKey::ReadLine;
  Term::ReadKey::ReadMode("restore");
  print "\n";
  chomp($password);
  return $password;
}



return 1;
