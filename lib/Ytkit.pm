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

  if ($self->{help})
  {
    print $self->help;
    exit 0;
  }
  elsif ($self->{version})
  {
    print $self->version;
    exit 0;
  }
  elsif (@{$self->{_config}->{left_argv}} && $self->{_config}->{_allow_extra_argv} == 0)
  {
    ### script doesn't allow bare argument.
    my $msg= sprintf("You give unknown argument(s) [%s]\n\n",
                     join(" ", @{$self->{_config}->{left_argv}}));
    carp($msg);
    print STDERR $self->usage;
    exit 3;
  }
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

return 1;
