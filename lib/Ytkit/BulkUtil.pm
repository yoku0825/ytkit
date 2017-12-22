package Ytkit::BulkUtil;

########################################################################
# Copyright (C) 2017  yoku0825
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
use v5.10;
use base qw{Exporter};
use Ytkit::HealthCheck;
use DBI;
use Time::HiRes;
our @EXPORT= qw{elapsed_time};

use constant YTKIT_HEALTHCHECK_OPTION =>
{
  role                  => "none",
  slave_status_warning  => 0,
  slave_status_critical => 4294967295, ### Report CRITICAL only when I/O and/or SQL threads have stopped.
};

sub new
{
  my ($class, $opt)= @_;

  my $self=
  {
    master_user      => $opt->{master_user},
    master_password  => $opt->{master_password},
    master_host      => $opt->{master_host},
    master_port      => $opt->{master_port},
    master_socket    => $opt->{master_socket},
    _master_conn     => undef,
    monitor_user     => $opt->{monitor_user} ? $opt->{monitor_user} : "yt_bulkutil",
    monitor_password => $opt->{monitor_password} ? $opt->{monitor_password} : undef,
    monitor_ip       => $opt->{monitor_ip} ? $opt->{monitor_ip} : "%",
    sleep            => $opt->{sleep} ? $opt->{sleep} : 1,
    slaves           => $opt->{slaves} ? [split(/,/, $opt->{slaves})] : [],
    silent           => $opt->{silent},
  };
  bless $self => $class;

  $self->{monitor_password} ||= $self->generate_random_password;
  $self->add_monitor_user if ($opt->{create_user});
  $SIG{"INT"}= sub { $self->drop_monitor_user } if ($opt->{drop_user});
  $self->{slaves} ||= $self->set_slave_via_search;

  return $self;
}

sub master_conn
{
  my ($self)= @_;

  $self->{_master_conn} ||= do
  {
    ### Don't connect when not specify both of --master-user and --master-host.
    return 0 if (!($self->{master_user})  || !($self->{master_host}));

    my $dsn= "dbi:mysql:";
    $dsn  .= sprintf(";host=%s", $self->{master_host});
    $dsn  .= sprintf(";port=%d", $self->{master_port}) if $self->{master_port};
    $dsn  .= sprintf(";mysql_socket=%s", $self->{master_socket}) if $self->{master_socket};
    $self->connect_mysql($dsn, $self->{master_user}, $self->{master_password});
  };

  return $self->{_master_conn};
}

sub connect_mysql
{
  my ($self, $dsn, $user, $password)= @_;

  my $conn;
  eval
  {
    $conn= DBI->connect($dsn, $user, $password, {PrintError => 0, RaiseError => 1});
  };

  if ($@)
  {
    warn(sprintf("Connect to MySQL failed user: %s, dsn: %s - %s", $user, $dsn, $@)) if !($self->{silent});
    return 0;
  }
  return $conn;
}

sub slave_list
{
  my ($self)= @_;
  return [map { [split(/:/, $_)] } @{$self->{slaves}}];
}

sub wait_slave
{
  my ($self)= @_;
  my $wait_count= 0;

  foreach my $one_slave (@{$self->slave_list})
  {
    my ($host, $port)= @$one_slave;
    my $one_opt= YTKIT_HEALTHCHECK_OPTION;
    $one_opt->{host}= $host;
    $one_opt->{port}= $port if $port;
    $one_opt->{user}= $self->{monitor_user};
    $one_opt->{password}= $self->{monitor_password};

    while ()
    {
      my $healthcheck= Ytkit::HealthCheck->new($one_opt);
      $healthcheck->check_long_query;
      $healthcheck->check_slave_status;

      if ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_OK->{exit_code})
      {
        ### Go to next slave.
        last;
      }
      elsif ($healthcheck->{status}->{exit_code} eq Ytkit::HealthCheck::NAGIOS_WARNING->{exit_code})
      {
        $wait_count++;
        $healthcheck->print_status if !($self->{silent});
        sleep $self->{sleep};
      }
      else
      {
        ### yt-healthcheck can't connect server or I/O and/or SQL thread has stopped.
        print("yt-healthcheck returns Unexpected return-code. aborting.\n") if !($self->{silent});
        die($healthcheck->print_status);
      }
    }
  }

  return $wait_count;
}

sub add_monitor_user
{
  my ($self)= @_;

  eval
  {
    foreach my $sql ($self->add_monitor_user_sql)
    {
      $self->master_conn->do($sql);
    }
  };

  if ($@)
  {
    warn(sprintf("Failed to CREATE USER to master - %s", $@)) if !($self->{silent});
    return 0;
  }
  return 1;
}

sub add_monitor_user_sql
{
  my ($self)= @_;

  return (sprintf(q{CREATE USER /*!50708 IF NOT EXISTS */ '%s'@'%s' IDENTIFIED BY '%s'},
                  $self->{monitor_user}, $self->{monitor_ip}, $self->{monitor_password}),
          sprintf(q{GRANT REPLICATION CLIENT ON *.* TO '%s'@'%s'},
                  $self->{monitor_user}, $self->{monitor_ip}));
}

sub drop_monitor_user
{
  my ($self)= @_;

  eval
  {
    $self->master_conn->do($self->drop_monitor_user_sql);
  };

  if ($@)
  {
    warn(sprintf("Failed to DROP USER to master - %s", $@)) if !($self->{silent});
    return 0;
  }
  return 1;
}

sub drop_monitor_user_sql
{
  my ($self)= @_;
  return sprintf(q{DROP USER '%s'@'%s'}, $self->{monitor_user}, $self->{monitor_ip});
}

sub show_slave_hosts
{
  my ($self)= @_;

  $self->{_show_slave_hosts} ||= do
  {
    return 0 if !($self->master_conn);
    $self->master_conn->selectall_arrayref("SHOW SLAVE HOSTS", {Slice => {}});
  };

  return $self->{_show_slave_hosts};
}

sub search_slave
{
  my ($self)= @_;

  if ($self->show_slave_hosts)
  {
    return join(",", map { sprintf("%s:%d", $_->{Host}, $_->{Port}) } @{$self->show_slave_hosts});
  }
  else
  {
    ### Can't search slaves by SHOW SLAVE HOSTS
    return 0;
  }
}

sub set_slave_via_search
{
  my ($self)= @_;

  if (my $slave= $self->search_slave)
  {
    return $self->{slaves}= [split(/,/, $slave)];
  }
  return 0;
}

sub check_slave_connectivity
{
  my ($self)= @_;
  my $ret= 1;

  foreach my $one_slave (@{$self->slave_list})
  {
    my ($host, $port)= @$one_slave;
    my $dsn= "dbi:mysql:";
    $dsn  .= sprintf(";host=%s", $host);
    $dsn  .= sprintf(";port=%d", $port) if $port;

    if (my $conn= $self->connect_mysql($dsn, $self->{monitor_user}, $self->{monitor_password}))
    {
      ### Check executing SHOW SLAVE STATUS
      eval
      {
        $conn->selectall_arrayref("SHOW SLAVE STATUS");
      };

      next if !($@);
    }

    ### If you are here, you failed connect_mysql or execute SHOW SLAVE STATUS.
    warn(sprintf("SHOW SLAVE STATUS failed in %s:%d - %s", $host, $port, $@)) if !($self->{silent});
    $ret= 0;
  }

  return $ret;
}

sub elapsed_time
{
  my ($code)= @_;

  my $start= Time::HiRes::time;
  if (ref($code) eq "CODE")
  {
    &$code;
  }
  else
  {
    eval($code);
  }
  my $finished= Time::HiRes::time;

  return $finished - $start;
}

sub generate_random_password
{
  my ($self)= @_;

  ### generate 16 upper case string
  my $str= join("", map { pack("c", 65 + rand(26)) } (1..16));
  printf(q{Random one-time password for %s@%s has benn generated: %s\n},
         $self->{monitor_user}, $self->{monitor_ip}, $str) if !($self->{silent});
  return $str;
}

return 1;
