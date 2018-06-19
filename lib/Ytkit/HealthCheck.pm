package Ytkit::HealthCheck;

########################################################################
# Copyright (C) 2017, 2018  yoku0825
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

use Ytkit::Config;
use Ytkit::MySQLServer;

### return code for Nagios-compats.
use constant NAGIOS_OK       => { exit_code => 0, str => "OK" };
use constant NAGIOS_WARNING  => { exit_code => 1, str => "WARNING" };
use constant NAGIOS_CRITICAL => { exit_code => 2, str => "CRITICAL" };
use constant NAGIOS_UNKNOWN  => { exit_code => 3, str => "UNKNOWN" };

### Data-type map
use constant BYTES =>
{
  tinyint   => 1,
  smallint  => 2,
  mediumint => 3,
  int       => 4,
  bigint    => 8,
};

my $default_option=
{
  role       => { alias   => ["role"],
                  isa     => ["auto", "master", "slave", "backup", "fabric", "none", "intermidiate"],
                  default => "auto" },
  long_query       => { enable        => { default => 1, },
                        warning       => { default => 5, },
                        critical      => { default => 100, },
                        exclude_host  => { default => [] },
                        exclude_query => { default => [] }, },
  connection_count => { enable   => { default => 1, },
                        warning  => { default => 70, },
                        critical => { default => 95, }, },
  autoinc_usage    => { enable   => { default => 1, },
                        warning  => { default => 50, },
                        critical => { default => 90, }, },
  slave_status     => { enable   => { default => 1, },
                        warning  => { default => 5, },
                        critical => { default => 30, }, },
  fabric_fd        => { enable   => { default => 1, },
                        warning  => { default => 50, },
                        critical => { default => 70, }, },
  config_group     => { alias => ["config-group"], default => "yt-healthcheck" },
};
$default_option= { %$default_option, %$Ytkit::Config::CONNECT_OPTION, %$Ytkit::Config::COMMON_OPTION };

sub new
{
  my ($class, @orig_argv)= @_;
  my ($opt, @argv)= options($default_option, @orig_argv);
  return -255 if $opt->{help};
  return -254 if $opt->{version};
  load_config($opt, $opt->{config_file}, $opt->{config_group}) if $opt->{config_file};

  my $self=
  {
    status           => NAGIOS_OK,  ### default.
    output           => "",
    timeout          => $opt->{timeout},
    long_query       =>
    {
      enable        => $opt->{long_query_enable},
      warning       => $opt->{long_query_warning},
      critical      => $opt->{long_query_critical},
      exclude_host  => $opt->{long_query_exclude_host} ? [split(/,/, $opt->{long_query_exclude_host})] : [],
      exclude_query => $opt->{long_query_exclude_query} ? [split(/,/, $opt->{long_query_exclude_query})] : [],
    },
    connection_count => { enable        => $opt->{connection_count_enable},
                          warning       => $opt->{connection_count_warning},
                          critical      => $opt->{connection_count_critical}, },
    autoinc_usage    => { enable        => $opt->{autoinc_usage_enable},
                          warning       => $opt->{autoinc_usage_warning},
                          critical      => $opt->{autoinc_usage_critical}, },
    read_only        => { should_be     => undef },
    slave_status     => { enable        => $opt->{slave_status_enable},
                          warning       => $opt->{slave_status_warning},
                          critical      => $opt->{slave_status_critical}, },
    fabric_fd        => { enable        => $opt->{fabric_fd_enable},
                          warning       => $opt->{fabric_fd_warning},
                          critical      => $opt->{fabric_fd_critical}, },
  };
  bless $self => $class;
  eval
  {
    $self->{instance}= Ytkit::MySQLServer->new($opt);
  };

  if ($@)
  {
    ### Early return if can't connect to MySQL.
    $self->{instance}= {};
    bless $self->{instance} => "Ytkit::MySQLServer";
    $self->{status}= NAGIOS_CRITICAL;
    $self->{output}= "Can't connect to MySQL Server($@)";
    $self->{role}= $opt->{role} eq "auto" ? "unknown" : $opt->{role};
    return $self;
  }

  ### Set role for check items.
  $self->{role}= $opt->{role} eq "auto" ? $self->decide_role : $opt->{role};
  my $role= $self->{role};

  if ($role eq "master")
  {
    ### Check too long query, connection count, AUTO_INCREMENT usage, read_only should be OFF.
    $self->check_long_query;
    $self->check_connection_count;
    $self->check_autoinc_usage;
    $self->{read_only}->{should_be}= 0;
    $self->check_read_only;
  }
  elsif ($role eq "slave")
  {
    ### Check too long query, replication threads, replication delay, connection count, read_only should be ON.
    $self->check_long_query;
    $self->check_connection_count;
    $self->check_slave_status;
    $self->{read_only}->{should_be}= 1;
    $self->check_read_only;
  }
  elsif ($role eq "intermidiate")
  {
    ### Intermidiate master in cascaded replication toporogy.
    $self->check_long_query;
    $self->check_connection_count;
    $self->check_autoinc_usage;
    $self->check_slave_status;
    $self->{read_only}->{should_be}= 0;
    $self->check_read_only;
  }
  elsif ($role eq "backup")
  {
    ### Check only replication threads, read_only should be ON.
    $self->check_slave_status;
    $self->{read_only}->{should_be}= 1;
    $self->check_read_only;
  }
  elsif ($role eq "none")
  {
    ### Nothing to check (automatically).
    ### Use this role when call Ytkit::HealthCheck as library.
  }
  elsif ($role eq "fabric")
  {
    ### mikasafabric couldn't return its hostname.
    $self->{instance}->{_hostname}= $opt->{host};
    ### mikasafabric for MySQL specific checks.
    $self->check_fabric;
  }
  else
  {
    ### Unexpected role was specified by user.
    $self->{status}= NAGIOS_UNKNOWN;
    $self->{output}= sprintf("Unexpected role was specified. %s", $role);
  }

  return $self;
}

sub decide_role
{
  my ($self)= @_;
  my $master= my $slave= 0;

  $master= 1 if $self->show_slaves_via_processlist;
  $slave = 1 if ($self->show_slave_status && $self->show_slave_status->[0]);

  if ($master && $slave)
  {
    return "intermidiate";
  }
  elsif($master)
  {
    return "master";
  }
  elsif($slave)
  {
    return "slave";
  }
  else
  {
    ### Master server without any slaves.
    return "master";
  }
}

sub result
{
  my ($self)= @_;

  $self->print_status;
  exit $self->{status}->{exit_code};
}

sub hostname
{
  my ($self)= @_;
  return $self->{instance}->hostname;
}

sub print_status
{
  my ($self)= @_;
  printf("%s on %s: %s (%s)\n",
         $self->{status}->{str}, $self->hostname,
         $self->{output}, $self->{role});
}

sub check_long_query
{
  my ($self)= @_;
  return 0 unless $self->{long_query}->{enable};

  ### Evaluate each thread.
  foreach my $row (@{$self->show_processlist})
  {
    my $user= $row->{User};

    ### Exclude by user.
    if (grep {/^$user$/} ("system user", "event_scheduler"))
    {
      ### Ignore replication threads and daemon plugin
      next;
    }

    ### Exclude by command.
    my $command= $row->{Command};
    if (grep {/^$command$/} ("Sleep", "Killed", "Binlog Dump", "Binlog Dump GTID", "Delayed insert"))
    {
      next;
    }

    ### Exclude by host.
    if ($self->{long_query}->{exclude_host}->[0])
    {
      my ($host_without_port)= split(/:/, $row->{Host});
      next if grep { $host_without_port eq $_ } @{$self->{long_query}->{exclude_host}};
    }

    ### Exclude by statement regexp.
    if ($self->{long_query}->{exclude_query}->[0] && $row->{Info})
    {
      next if grep { $row->{Info} =~ /$_/ } @{$self->{long_query}->{exclude_query}};
    }

    ### Evaluate by time.
    my $time= $row->{Time} ? $row->{Time} : 0;
    my $status= compare_threshold($time, $self->{long_query});

    $self->update_status($status, sprintf(q{Detected long query by %s@%s: "%s"},
                                          $row->{User}, $row->{Host}, $row->{Info})) if $status && $row->{Info};

  } ### End of foreach, goes to the next row.

  return;
}

sub check_connection_count
{
  my ($self)= @_;
  return 0 unless $self->{connection_count}->{enable};

  my $current= $self->show_status->{Threads_connected}->{Value};
  my $setting= $self->show_variables->{max_connections}->{Value};
  my $ratio  = ($current / $setting) * 100;
  my $status = compare_threshold($ratio, $self->{connection_count});
  $self->update_status($status, sprintf(qq{Caution for too many connections: "%5.2f(%d/%d)"\t},
                                        $ratio, $current, $setting)) if $status;
  return;
}

sub check_autoinc_usage
{
  my ($self)= @_;
  return 0 unless $self->{autoinc_usage}->{enable};

  foreach my $row (@{$self->select_autoinc_usage})
  {
    ### Calculate max value of autoinc from datatype.
    my ($type, $unsigned)= $row->{column_type} =~ /^([a-z]+)\(.+\)(\s+(unsigned))?/;
    my $max= 2 ** (BYTES->{$type} * 8 - ($unsigned ? 0 : 1));
    my $ratio= ($row->{auto_increment} / $max) * 100;

    my $status= compare_threshold($ratio, $self->{autoinc_usage});
    $self->update_status($status, sprintf(qq{table %s.%s uses auto_increment column %s %5.2f%%(%d/%d)"\t},
                                          $row->{table_schema}, $row->{table_name}, $row->{column_name},
                                          $ratio, $row->{auto_increment}, $max)) if $status;
  }

  return;
}

sub check_read_only
{
  my ($self)= @_;

  my $status   = NAGIOS_OK;
  my $read_only= $self->show_variables->{read_only}->{Value};

  if ($read_only eq "ON")
  {
    ### If master server(read_only should_be 0) turns on read_only, raise as CRITICAL.
    $status= $self->{read_only}->{should_be} == 0 ? NAGIOS_CRITICAL : NAGIOS_OK;
  }
  elsif ($read_only eq "OFF")
  {
    ### Just warning if slave server(read_only should_be 1) turns off read_only.
    $status= $self->{read_only}->{should_be} == 1 ? NAGIOS_WARNING : NAGIOS_OK;
  }

  $self->update_status($status, sprintf(qq{read_only should be %s but current setting is %s}, 
                                        $self->{read_only}->{should_be} == 1 ? "ON" : "OFF",
                                        $self->show_variables->{read_only}->{Value})) if $status;
}

sub check_slave_status
{
  my ($self)= @_;
  return 0 unless $self->{slave_status}->{enable};

  foreach my $row (@{$self->show_slave_status})
  {
    my $status;
    my $output= "";
    my $channel_name= $row->{Channel_Name} ? "Channel: " . $row->{Channel_Name} . " " : "";

    ### Each $row means each CHANNEL (correspond to Multi-Source Replication)
    if ($row->{Slave_IO_Running} ne "Yes")
    {
      $status  = NAGIOS_CRITICAL;
      $output .= sprintf("%sSlave I/O Thread is NOT Running. ", $channel_name);
    }
    if ($row->{Slave_SQL_Running} ne "Yes")
    {
      $status  = NAGIOS_CRITICAL;
      $output .= sprintf("%sSlave SQL Thread is NOT Running. ", $channel_name);
    }

    ### Don't evaluate Seconds_Behind_Master when replication thread is down.
    if ($status)
    {
      $self->update_status($status, $output);
      next;
    }

    my $second= $row->{Seconds_Behind_Master} ? $row->{Seconds_Behind_Master} : 0;
    $output .= sprintf("%sSlave Seconds_Behind_Master is %d. ", $channel_name, $second);
    $status= compare_threshold($second, $self->{slave_status});
    $self->update_status($status, $output) if $status;
  } ### Evaluate each CHANNEL in SHOW SLAVE STATUS
  return;
}

sub check_fabric
{
  my ($self)= @_;

  my $status;
  my $output= "";

  ### Healthcheck for each group.
  foreach my $group (@{$self->query_fabric("group.lookup_groups", "")})
  {
    my $group_id= $group->{group_id};
    my $primary_server= "";
    my $secondary     = 0;

    foreach my $server (@{$self->query_fabric("group.health", $group_id)})
    {
      $primary_server= $server->{uuid} if $server->{status} eq "PRIMARY";
      $secondary += 1 if $server->{status} eq "SECONDARY";
    }

    if (!($primary_server))
    {
      $status= NAGIOS_CRITICAL;
      $output= sprintf("group %s does not have Master Server", $group_id);
      $self->update_status($status, $output) if $status;
    }

    if (!($secondary))
    {
      $status= NAGIOS_CRITICAL;
      $output= sprintf("group %s does not have Candidate-Slave Server", $group_id);
      $self->update_status($status, $output) if $status;
    }
  }

  ### File-Descriptor count.
  my $openfds= $self->query_fabric("manage.openfds", "");

  my $current_fd= $openfds->[0]->{current};
  my $max_fd    = $openfds->[0]->{max};
  my $pct_fd    = ($current_fd / $max_fd) * 100;

  $status= compare_threshold($pct_fd, $self->{fabric_fd});

  ### Information message when $status = NAGIOS_OK
  $output= sprintf("File-descriptor count %d/%d", $current_fd, $max_fd) if $status;
  $self->update_status($status, $output) if $status;

  return;
}

sub update_status
{
  my ($self, $new_status, $new_output)= @_;
  return if $new_status->{exit_code} == NAGIOS_OK->{exit_code};

  if ($self->{status}->{exit_code} == $new_status->{exit_code})
  {
    ### Same level, join.
    $self->{output} .= $new_output;
  }
  elsif($self->{status}->{exit_code} < $new_status->{exit_code})
  {
    ### New status is more important than current one, override.
    $self->{status}= $new_status;
    $self->{output}= $new_output;
  }
  else
  {
    ### New status is NOT important than current one, ignore.
  }

  return;
}

sub compare_threshold
{
  my ($value, $threshold)= @_;

  if ($value > $threshold->{critical})
  {
    return NAGIOS_CRITICAL;
  }
  elsif ($value > $threshold->{warning})
  {
    return NAGIOS_WARNING;
  }
  return NAGIOS_OK;
}

sub show_slave_status
{
  my ($self)= @_;
  return $self->{instance}->show_slave_status;
}

sub show_processlist
{
  my ($self)= @_;
  return $self->{instance}->show_processlist;
}

sub show_status
{
  my ($self)= @_;
  return $self->{instance}->show_status;
}

sub show_variables
{
  my ($self)= @_;
  return $self->{instance}->show_variables;
}

sub select_autoinc_usage
{
  my ($self)= @_;
  return $self->{instance}->select_autoinc_usage;
}

sub show_slaves_via_processlist
{
  my ($self)= @_;
  return 0 unless $self->show_processlist;

  foreach my $row (@{$self->show_processlist})
  {
    if ($row->{Command} =~ /^Binlog\sDump/)
    {
      return 1;
    }
  }
  return 0;
}

sub query_fabric
{
  my ($self, $function, $arg)= @_;

  ### Query for mikasafabric doesn't cache but this for unit-test.
  if (!(defined($self->{_query_fabric})))
  {
    my $sql = sprintf("CALL %s(%s)", $function, $arg ? "'" . $arg . "'" : "");
    my $stmt= $self->{instance}->{conn}->prepare($sql, {Slice => {}});
    $stmt->execute;

    ### Skip, 1st Result set is metadata.
    $stmt->fetchall_arrayref();
    $stmt->more_results;        ### Go ahead to next Result set.

    $self->{_query_fabric}= $stmt->fetchall_arrayref({});
  }

  my $ret= $self->{_query_fabric};

  ### Clear buffer each time.
  delete($self->{_query_fabric});
  return $ret;
}

sub clear_cache
{
  my ($self)= @_;
  return $self->{instance}->clear_cache;
}

return 1;
