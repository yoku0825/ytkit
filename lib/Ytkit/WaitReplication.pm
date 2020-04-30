package Ytkit::WaitReplication;

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
use base "Ytkit";

use Time::Piece;
use Ytkit::HealthCheck;
use Ytkit::IO;

my $script= sprintf("%s - Script that waiting for Seconds_Behind_Master is less than specified value", $0);
my $description= << "EOS";
yt-wait-replication only waits for Seconds_Behind_Master is less than --seconds-behind-master

  yt-wait-replication returns 0 if Seconds_Behind_Master < --seconds-behind-master during --retry-timeout seconds.
  yt-wait-replication dies when mysqld dies or replication thread(s) not running,
  or Seconds_Behind_Master > --seconds-behind-master after --retry-timeout seconds.
EOS
my $synopsis= q{  $ yt-wait-replication --host=your_mysql_host --port=your_mysql_port } .
              q{--user=your_mysql_account --password=your_password } .
              q{--seconds-behind-master=5 --sleep=3 --retry-timeout=180};
my $allow_extra_arvg= 0;
my $config= _config();


sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);
  my $self= { _config => $config,
              %{$config->{result}} };
  bless $self => $class;
  $self->handle_help;

  $self=
  {
    %$self,
    healthcheck_opt => ["--role", "none",
                        "--slave_status_warning", $self->{seconds_behind_master},
                        "--slave_status_critical", 4294967295,
                        "--user", $self->{user} // "''", 
                        "--host", $self->{host} // "''",
                        "--port", $self->{port} // 3306,
                        "--socket", $self->{socket} // "''",
                        "--password", $self->{password} || "''"],
  };
  bless $self => $class;

  return $self;
}


sub wait_slave
{
  my ($self)= @_;
  my $wait_count= 0;
  my $start_time= undef;
  my $start_behind= undef;
  $|= 1;

  while ()
  {
    ### Report CRITICAL only when I/O and/or SQL threads have stopped.
    my $healthcheck= Ytkit::HealthCheck->new(@{$self->{healthcheck_opt}});
    _croakf($healthcheck->{output}) 
      if $healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_CRITICAL->{exit_code};

    $healthcheck->check_slave_status;

    if ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_OK->{exit_code})
    {
      ### Seconds_behind_master < threshold, return.
      return 0;
    }
    elsif ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_WARNING->{exit_code})
    {
      ### TODO: Support Multi-Source Replication.
      my $info= $healthcheck->show_slave_status->[0];
      my $current_time= Time::Piece::localtime;
      my $current_behind= $info->{Seconds_Behind_Master};
      $wait_count++;

      if ($self->{verbose})
      {
        if (!($start_time) || !($start_behind))
        {
          $start_time= $current_time;
          $start_behind= $current_behind;
        }
        else
        {
          my $second_diff= $current_time->epoch - $start_time->epoch;
          my $catchup_rate= ($start_behind - $current_behind) / $second_diff;
          my $estimated_sec= $catchup_rate > 0 ? sprintf("%0.2f", $current_behind / $catchup_rate) : "NaN";
          my $estimated_time= $estimated_sec ne "NaN" ? $current_time + $estimated_sec : "Never";
          _infof("Current Seconds_Behind_Master = %d, Catching up %0.2f/sec during %d secs,\n" .
                 "  Delay will solve in %s secs, Estimated at %s.\n",
                 $current_behind, $catchup_rate, $second_diff,
                 $estimated_sec, $estimated_sec ne "NaN" ? $estimated_time->strftime("%m/%d %H:%M") : "Never");
        }
      }

      if (($wait_count * $self->{sleep}) > $self->{retry_timeout})
      {
        ### Retry out.
        _croakf("Retrying %d times each %d seconds but Seconds_Behind_Master still exceeds %d.",
                      $wait_count, $self->{sleep}, $self->{seconds_behind_master});
      }
      else
      {
        $healthcheck->DESTROY;
        sleep $self->{sleep};
      }
    }
    else
    {
      ### yt-healthcheck can't connect server or I/O and/or SQL thread has stopped.
      _debugf("yt-healthcheck returns Unexpected return-code. aborting.\n");
      $healthcheck->print_status;
      _croakf($healthcheck->{output});
    }
  }
}

sub _config
{
  my $yt_wait_replication_option=
  {
    seconds_behind_master => { alias => ["seconds_behind_master"],
                               default => 5,
                               text => "Wait until Seconds_Behind_Master get to be less than this value." },
    sleep => { alias => ["sleep", "interval", "i"],
               default => 3,
               text => "Interval seconds in each retry-loop iteration." },
    retry_timeout => { alias => ["retry_timeout"],
                       default => 1800,
                       text => "Seconds for scripts running(timeout when --retry-timeout < retry_count * sleep_interval)" },
  };
  my $config= Ytkit::Config->new({ %$yt_wait_replication_option,
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
} 

return 1;
