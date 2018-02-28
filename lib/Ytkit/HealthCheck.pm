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
use v5.10;
use DBI;

use Ytkit::Config;
use Ytkit::MySQLServer;

### return code for Nagios-compats.
use constant NAGIOS_OK       => { exit_code => 0, str => "OK" };
use constant NAGIOS_WARNING  => { exit_code => 1, str => "WARNING" };
use constant NAGIOS_CRITICAL => { exit_code => 2, str => "CRITICAL" };
use constant NAGIOS_UNKNOWN  => { exit_code => 3, str => "UNKNOWN" };

use constant DEFAULT_OPTION =>
{
  version    => { alias => ["version", "V"], default => 0 },
  role       => { alias   => ["role"],
                  isa     => ["auto", "master", "slave", "backup", "fabric", "none", "intermidiate"],
                  default => "auto" },
  user       => ["u", "user"],
  host       => ["h", "host"],
  port       => ["P", "port"],
  socket     => ["S", "socket"],
  password   => ["p", "password"],
  timeout    => { default => 1 },
  help       => ["help", "usage"],
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
  config_file      => { alias => ["c", "config-file"] },
  config_group     => { alias => ["config-group"], default => "yt-healthcheck" },
};

sub new
{
  my ($class, @orig_argv)= @_;
  my ($opt, @argv)= options(DEFAULT_OPTION, @orig_argv);
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
    instance => Ytkit::MySQLServer->new($opt),
  };
  bless $self => $class;

  if (!($self->{instance}->{conn}))
  {
    ### Early return if can't connect to MySQL.
    $self->{status}= NAGIOS_CRITICAL;
    $self->{output}= "Can't connect to MySQL Server.";
    $self->{role}= $opt->{role} eq "auto" ? "unknown" : $opt->{role};
    return $self;
  }

  ### Set role for check items.
  $self->{role}= $opt->{role} eq "auto" ? $self->decide_role : $opt->{role};

  given($self->{role})
  {
    when("master")
    {
      ### Check too long query, connection count, AUTO_INCREMENT usage, read_only should be OFF.
      $self->check_long_query;
      $self->check_connection_count;
      $self->check_autoinc_usage;
      $self->{read_only}->{should_be}= 0;
      $self->check_read_only;
    };
    when("slave")
    {
      ### Check too long query, replication threads, replication delay, connection count, read_only should be ON.
      $self->check_long_query;
      $self->check_connection_count;
      $self->check_slave_status;
      $self->{read_only}->{should_be}= 1;
      $self->check_read_only;
    };
    when("intermidiate")
    {
      ### Intermidiate master in cascaded replication toporogy.
      $self->check_long_query;
      $self->check_connection_count;
      $self->check_autoinc_usage;
      $self->check_slave_status;
      $self->{read_only}->{should_be}= 0;
      $self->check_read_only;
    };
    when("backup")
    {
      ### Check only replication threads, read_only should be ON.
      $self->check_slave_status;
      $self->{read_only}->{should_be}= 1;
      $self->check_read_only;
    };
    when("none")
    {
      ### Nothing to check (automatically).
      ### Use this role when call Ytkit::HealthCheck as library.
    };
    when("fabric")
    {
      ### mikasafabric couldn't return its hostname.
      $self->{instance}->{_hostname}= $opt->{host};
      ### mikasafabric for MySQL specific checks.
      $self->check_fabric;
    };

    default
    {
      ### Unexpected role was specified by user.
      $self->{status}= NAGIOS_UNKNOWN;
      $self->{output}= sprintf("Unexpected role was specified. %s", $self->{role});
    };
  };

  return $self;
}

sub decide_role
{
  my ($self)= @_;
  my $master= my $slave= 0;

  $master= 1 if $self->show_slaves_via_processlist;
  $slave = 1 if $self->show_slave_status->[0];

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
    ### Exclude by user.
    given($row->{User})
    {
      ### Ignore replication threads and daemon plugin
      when(["system user", "event_scheduler"])
      {
        next;
      }
    };

    ### Exclude by command.
    given($row->{Command})
    {
      when(["Sleep", "Killed", "Binlog Dump", "Binlog Dump GTID", "Delayed insert"])
      {
        next;
      }
    };

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
    my $status;
    given($row->{Time})
    {
      $_ ||= 0;
      when($_ > $self->{long_query}->{critical})
      {
        $status= NAGIOS_CRITICAL;
      };
      when($_ > $self->{long_query}->{warning})
      {
        $status= NAGIOS_WARNING;
      };
    };
    $self->update_status($status, sprintf(qq{Detected long query: "%s"\t}, $row->{Info})) if $status;

  } ### End of foreach, goes to the next row.

  return;
}

sub check_connection_count
{
  my ($self)= @_;
  return 0 unless $self->{connection_count}->{enable};

  my $status;

  my $current= $self->show_status->{Threads_connected}->{Value};
  my $setting= $self->show_variables->{max_connections}->{Value};
  my $ratio  = ($current / $setting) * 100;

  given($ratio)
  {
    when($_ > $self->{connection_count}->{critical})
    {
      $status= NAGIOS_CRITICAL;
    };
    when($_ > $self->{connection_count}->{warning})
    {
      $status= NAGIOS_WARNING;
    };
  };
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
    my $max;
    given($type)
    {
      when("tinyint")
      {
        $max= 2 ** ($unsigned ? 8 : 7) - 1;
      };
      when("smallint")
      {
        $max= 2 ** ($unsigned ? 16 : 15) - 1;
      };
      when("mediumint")
      {
        $max= 2 ** ($unsigned ? 24 : 23) - 1;
      };
      when("int")
      {
        $max= 2 ** ($unsigned ? 32 : 31) - 1;
      };
      when("bigint")
      {
        $max= 2 ** ($unsigned ? 64 : 63) - 1;
      };
    };

    my $ratio= ($row->{auto_increment} / $max) * 100;

    my $status;
    given($ratio)
    {
      when($_ > $self->{autoinc_usage}->{critical})
      {
        $status= NAGIOS_CRITICAL;
      };
      when($_ > $self->{autoinc_usage}->{warning})
      {
        $status= NAGIOS_WARNING;
      };
    };
  
    $self->update_status($status, sprintf(qq{table %s.%s uses auto_increment column %s %5.2f%%(%d/%d)"\t},
                                          $row->{table_schema}, $row->{table_name}, $row->{column_name},
                                          $ratio, $row->{auto_increment}, $max)) if $status;
  }

  return;
}

sub check_read_only
{
  my ($self)= @_;

  my $status;
  given($self->show_variables->{read_only}->{Value})
  {
    when("ON")
    {
      ### If master server(read_only should_be 0) turns on read_only, raise as CRITICAL.
      $status= $self->{read_only}->{should_be} == 0 ? NAGIOS_CRITICAL : undef
    };
    when("OFF")
    {
      ### Just warning if slave server(read_only should_be 1) turns off read_only.
      $status= $self->{read_only}->{should_be} == 1 ? NAGIOS_WARNING : undef;
    };
  }

  $self->update_status($status, sprintf(qq{read_only should be %s but current setting is %s}, 
                                        $self->{read_only}->{should_be} == 1 ? "ON" : "OFF",
                                        $self->show_variables->{read_only}->{Value})) if $status;
}

sub check_slave_status
{
  my ($self)= @_;
  return 0 unless $self->{slave_status}->{enable};

  my $status;
  my $output= "";
  foreach my $row (@{$self->show_slave_status})
  {
    ### Each $row means each CHANNEL (correspond to Multi-Source Replication)
    if ($row->{Slave_IO_Running} ne "Yes")
    {
      $status  = NAGIOS_CRITICAL;
      $output .= "Slave I/O Thread is NOT Running. ";
    }
    if ($row->{Slave_SQL_Running} ne "Yes")
    {
      $status  = NAGIOS_CRITICAL;
      $output .= "Slave SQL Thread is NOT Running. ";
    }

    ### Don't evaluate Seconds_Behind_Master when replication thread is down.
    if ($status)
    {
      $self->update_status($status, $output);
      next;
    }

    given($row->{Seconds_Behind_Master})
    {
      when($_ > $self->{slave_status}->{critical})
      {
        $status= NAGIOS_CRITICAL;
        $output= sprintf("Seconds_Behind_Master is %d", $_);
      };
      when($_ > $self->{slave_status}->{warning})
      {
        $status= NAGIOS_WARNING;
        $output= sprintf("Seconds_Behind_Master is %d", $_);
      };
    };
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

  given($pct_fd)
  {
    when($_ > $self->{fabric_fd}->{critical})
    {
      $status= NAGIOS_CRITICAL;
      $output= sprintf("File-descriptor count %d/%d is over %d%%", $current_fd, $max_fd, $self->{fabric_fd}->{critical});
    };
    when($_ > $self->{fabric_fd}->{warning})
    {
      $status= NAGIOS_WARNING;
      $output= sprintf("File-descriptor count %d/%d is over %d%%", $current_fd, $max_fd, $self->{fabric_fd}->{critical});
    };
    default
    {
      $status= NAGIOS_OK;
      $output= sprintf("File-descriptor count %d/%d", $current_fd, $max_fd);
    }
  };
  $self->update_status($status, $output) if $status;

  return;
}

sub update_status
{
  my ($self, $new_status, $new_output)= @_;

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

sub show_slave_status
{
  my ($self)= @_;

  $self->{_show_slave_status}= $self->{instance}->show_slave_status if !(defined($self->{_show_slave_status}));
  return $self->{_show_slave_status};
}

sub show_processlist
{
  my ($self)= @_;

  $self->{_show_processlist}= $self->{instance}->show_processlist if !(defined($self->{_show_processlist}));
  return $self->{_show_processlist};
}

sub show_status
{
  my ($self)= @_;

  $self->{_show_status}= $self->{instance}->show_status if !(defined($self->{_show_status}));
  return $self->{_show_status};
}

sub show_variables
{
  my ($self)= @_;

  $self->{_show_variables}= $self->{instance}->show_variables if !(defined($self->{_show_variables}));
  return $self->{_show_variables};
}

sub select_autoinc_usage
{
  my ($self)= @_;
  $self->{_select_autoinc_usage}= $self->{instance}->select_autoinc_usage if !(defined($self->{_select_autoinc_usage}));
  return $self->{_select_autoinc_usage};
}

sub show_slaves_via_processlist
{
  my ($self)= @_;

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

return 1;
