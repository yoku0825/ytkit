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
use base "Ytkit";
use Carp qw{carp croak};

use Ytkit::HealthCheck;

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

  if (grep { $_ =~ /timeout/ && $_ !~ /retry/ } @orig_argv)
  {
    if (grep { $_ =~ /timeout/ && $_ =~ /retry/ } @orig_argv)
    {
      ### Both --timeout and --retry-timeout are specified, maybe they are specified correctly.
    }
    else
    {
      ### --timeout is specified but --retry-timeout is NOT, maybe using old-param 
      $self->{retry_timeout}= $self->{timeout};
      carp("--timeout is deprecated (See #15), use --retry-timeout instead. (Sorry if you mean really 'timeout')\n" .
           "Set $self->{timeout} into both of --timeout(connection timeout parameter) and --retry-timeout");
    }
  }

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

  while ()
  {
    ### Report CRITICAL only when I/O and/or SQL threads have stopped.
    my $healthcheck= Ytkit::HealthCheck->new(@{$self->{healthcheck_opt}});
    croak($healthcheck->{output}) 
      if $healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_CRITICAL->{exit_code};

    $healthcheck->check_slave_status;

    if ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_OK->{exit_code})
    {
      ### Seconds_behind_master < threshold, return.
      return 0;
    }
    elsif ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_WARNING->{exit_code})
    {
      $wait_count++;
      $healthcheck->print_status if $self->{verbose};

      if (($wait_count * $self->{sleep}) > $self->{retry_timeout})
      {
        ### Retry out.
        my $msg= sprintf("Retrying %d times each %d seconds but Seconds_Behind_Master still exceeds %d.",
                         $wait_count, $self->{sleep}, $self->{seconds_behind_master});
        croak($msg);
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
      print("yt-healthcheck returns Unexpected return-code. aborting.\n") if $self->{verbose};
      croak($healthcheck->print_status);
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
    timeout => { alias => ["timeout"],
                 default => 1800,
                 text => "Seconds for scripts running(timeout when --timeout < retry_count * sleep_interval)\n" .
                         "This parameter is DEPRECATED. Use --retry-timeout instead." },
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
