package Ytkit;

########################################################################
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
use Carp qw{ carp croak };
use Term::ReadKey;

use Ytkit::Config;
use Ytkit::Config::File;
use Ytkit::MySQLServer;

sub instance
{
  my ($self)= @_;
  $self->{_instance} ||= Ytkit::MySQLServer->new($self->{_config}->{result});
  return $self->{_instance};
}

sub help
{
  my ($self)= @_;
  return sprintf("%s\n%s\n\n%s",
                 $self->{_config}->help,
                 $self->version,
                 $self->usage);
}

sub usage
{
  my ($self)= @_;
  return $self->{_config}->usage;
}

sub version
{
  my ($self)= @_;
  return $self->{_config}->version;
}

sub handle_help
{
  my ($self)= @_;

  $self->fix_common_options;

  if ($self->{help})
  {
    $self->{silent}= 0;
    $self->infof($self->help);
    exit 0;
  }
  elsif ($self->{version})
  {
    $self->{silent}= 0;
    $self->infof($self->version);
    exit 0;
  }
  elsif (@{$self->{_config}->{left_argv}} && $self->{_config}->{_allow_extra_argv} == 0)
  {
    ### script doesn't allow bare argument.
    $self->carpf("You give unknown argument(s) [%s]\n\n",
                 join(" ", @{$self->{_config}->{left_argv}}));
    $self->notef($self->usage);
    exit 3;
  }
  elsif ($self->{ask_pass})
  {
    $self->ask_password;
  }
}

sub fix_common_options
{
  my ($self)= @_;

  if ($self->{silent} && $self->{verbose})
  {
    ### --silent and --verbose are exclusive
    $self->{silent}= 0;
    $self->carpf("Can't set both --silent and --verbose. Failling back to only --verbose");
    return 1;
  }
  return 0;
}

sub clear_cache
{
  my ($self)= @_;
  return $self->instance->clear_cache;
}

sub test_connect
{
  my ($self)= @_;

  ### Test connection
  $self->instance->conn;

  if ($self->instance->error)
  {
    ### die if can't connect to MySQL.
    my $msg= sprintf("MySQL Connection failed. %s", $self->instance->error);
    croak($msg) if !($ENV{HARNESS_ACTIVE});

    ### For test.
    return $self;
  }
}

sub ask_password
{
  my ($self)= @_;

  Term::ReadKey::ReadMode("noecho");
  print "Password: ";
  my $password= Term::ReadKey::ReadLine;
  Term::ReadKey::ReadMode("restore");
  print "\n";
  chomp($password);
  $self->{_config}->{result}->{password}= $password;
  $self->{password}= $password;
}

sub infof
{
  my ($self, $format, @argv)= @_;

  if ($self->{silent})
  {
    return undef;
  }
  else
  {
    my $msg= sprintf($format, @argv);
    print(STDOUT $msg) if !($ENV{HARNESS_ACTIVE});
    return $msg;
  }
}

sub notef
{
  my ($self, $format, @argv)= @_;

  if ($self->{silent})
  {
    return undef;
  }
  else
  {
    my $msg= sprintf($format, @argv);
    print(STDERR $msg) if !($ENV{HARNESS_ACTIVE});
    return $msg;
  }
}

sub debugf
{
  my ($self, $format, @argv)= @_;

  if (!($self->{verbose}))
  {
    return undef;
  }
  else
  {
    my $msg= sprintf($format, @argv);
    print(STDERR $msg) if !($ENV{HARNESS_ACTIVE});
    return $msg;
  }
}

sub croakf
{
  my ($self, $format, @argv)= @_;

  ### Do not handle by --silent
  my $msg= sprintf($format, @argv);
  croak($msg);
}

sub carpf
{
  my ($self, $format, @argv)= @_;

  if ($self->{silent})
  {
    return undef;
  }
  else
  {
    my $msg= sprintf($format, @argv);
    carp($msg) if !($ENV{HARNESS_ACTIVE});
    return $msg;
  }
}

return 1;
