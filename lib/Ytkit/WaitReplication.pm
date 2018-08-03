package Ytkit::WaitReplication;

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
use Carp qw{carp croak};

use Ytkit::Config;
use Ytkit::HealthCheck;

my $default_option=
{
  silent => { alias => ["silent", "s", "quiet", "q"],
              default => 1},
  sleep  => { alias => ["sleep", "interval", "i"],
              default => 3 },
  seconds_behind_master => { default => 5 },
};
$default_option= { %$default_option, %$Ytkit::Config::CONNECT_OPTION, %$Ytkit::Config::COMMON_OPTION };

### Fix
$default_option->{timeout}->{default}= 1800;

sub new
{
  my ($class, @orig_argv)= @_;
  my ($opt, @argv)= options($default_option, @orig_argv);
  return -255 if $opt->{help};
  return -254 if $opt->{version};
  return -253 if @argv;

  my $self=
  {
    timeout               => $opt->{timeout},
    healthcheck_opt       => ["--role", "none",
                              "--slave_status_warning", $opt->{seconds_behind_master},
                              "--slave_status_critical", 4294967295,
                              "--user", $opt->{user} // "", 
                              "--host", $opt->{host} // "",
                              "--port", $opt->{port} // 3306,
                              "--socket", $opt->{socket} // "",
                              "--password", $opt->{password} // ""],
 
  };
  $self= { %$self, %$opt };
  bless $self => $class;

  return $self;
}


sub wait_slave
{
  my ($self)= @_;
  my $wait_count= 0;

  while ()
  {
    ### Report CRITICAL only when I/O and/or SQL threads have stopped.
    my $healthcheck= Ytkit::HealthCheck->new(@{$self->{healthcheck_opt}});
    croak($healthcheck->{status}->{output}) 
      if $healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_CRITICAL->{exit_code};

    $healthcheck->check_slave_status;

    if ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_OK->{exit_code})
    {
      ### return.
      return 0;
    }
    elsif ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_WARNING->{exit_code})
    {
      $wait_count++;
      $healthcheck->print_status if !($self->{silent});

      if (($wait_count * $self->{sleep}) > $self->{timeout})
      {
        ### Retry out.
        my $msg= sprintf("Retrying %d times each %d seconds but Seconds_Behind_Master still exceeds %d.",
                         $wait_count, $self->{sleep}, $self->{seconds_behind_master});
        croak($msg);
      }
      else
      {
        sleep $self->{sleep};
      }
    }
    else
    {
      ### yt-healthcheck can't connect server or I/O and/or SQL thread has stopped.
      print("yt-healthcheck returns Unexpected return-code. aborting.\n") if !($self->{silent});
      croak($healthcheck->print_status);
    }
  }
}

return 1;
