package Ytkit::HealthCheck;

########################################################################
# Copyright (C) 2017, 2021  yoku0825
# Copyright (C) 2018        hacchuu0119
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
use POSIX;
use base "Ytkit";

use IO::File;
use Time::Piece qw{ localtime };
use Ytkit::MySQLServer;
use Ytkit::IO;

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

my $synopsis= q{  $ yt-healthcheck --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password --role=auto};
my $script= sprintf("%s - MySQL healthcheck script", $0);
my $description= << "EOS";
yt-health-check checks following MySQL status,

  Able to connect.
  Running replication threads.
  Replication delay.
  Too long query in processlist.
  Connection count.
  AUTO_INCREMENT column usage.
  read_only variable is set or not.
  No "GTID-gap" in gtid_executed.
  LATEST DETECTED DEADLOCK time.
  Uptime check.

and returns Nagios compatible result code,

  0 OK
  1 WARNING
  2 CRITICAL
  3 UNKNOWN
EOS
my $allow_extra_arvg= 0;


sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}} };
  bless $self => $class;
  $self->handle_help;

  ### Can't use Ytkit::test_connect, because we should return NAGIOS_CRITICAL instead of abort.
  $self->instance->conn;
  if ($self->instance->error)
  {
    ### Early return if can't connect to MySQL.
    $self->{status}= NAGIOS_CRITICAL;
    $self->{output}= "Can't connect to MySQL Server($@)";
    $self->{role}= $self->{role} eq "auto" ? "unknown" : $self->{role};
    return $self;
  }

  ### Set role for check items.
  $self->{role}= $self->{role} eq "auto" ? $self->decide_role : $self->{role};
  my $role= $self->{role};

  ### Initial value
  $self->{status}= NAGIOS_OK;
  $self->{output}= "";

  return $self if $self->{role} ne "fabric" && $self->check_offline_mode;

  if ($role eq "master" || $role eq "primary" || $role eq "source")
  {
    ### Check too long query, connection count, AUTO_INCREMENT usage, read_only should be OFF.
    $self->check_long_query;
    $self->check_connection_count;
    $self->check_autoinc_usage;
    $self->{read_only}->{should_be}= 0;
    $self->check_read_only;
    $self->check_gtid_hole;
    $self->check_latest_deadlock;
    $self->check_uptime;
    $self->check_history_list_length;
  }
  elsif ($role eq "slave" || $role eq "replica" || $role eq "read" || $role eq "standby" || $role eq "secondary")
  {
    ### Check too long query, replication threads, replication delay, connection count, read_only should be ON.
    $self->check_long_query;
    $self->check_connection_count;
    $self->check_slave_status;
    $self->{read_only}->{should_be}= 1;
    $self->check_read_only;
    $self->check_gtid_hole;
    $self->check_uptime;
    $self->check_history_list_length;
  }
  elsif ($role eq "intermidiate" || $role eq "cascade")
  {
    ### Intermidiate master in cascaded replication toporogy.
    $self->check_long_query;
    $self->check_connection_count;
    $self->check_autoinc_usage;
    $self->check_slave_status;
    $self->{read_only}->{should_be}= 0;
    $self->check_read_only;
    $self->check_gtid_hole;
    $self->check_latest_deadlock;
    $self->check_uptime;
    $self->check_history_list_length;
  }
  elsif ($role eq "backup")
  {
    ### Check only replication threads, read_only should be ON.
    $self->check_slave_status;
    $self->{read_only}->{should_be}= 1;
    $self->check_read_only;
    $self->check_gtid_hole;
  }
  elsif ($role eq "none")
  {
    ### Nothing to check (automatically).
    ### Use this role when call Ytkit::HealthCheck as library.
  }
  elsif ($role eq "fabric")
  {
    ### mikasafabric couldn't return its hostname.
    $self->instance->{_hostname}= $self->{host};
    ### mikasafabric for MySQL specific checks.
    $self->check_fabric;
  }
  elsif ($role eq "group_replication")
  {
    my $group_replication_primary= $self->instance->i_am_group_replication_primary;

    ### Like a master-replica toporogy.
    if ($group_replication_primary)
    {
      ### 1, if node is Group Replication PRIMARY.
      $self->check_autoinc_usage;
      $self->check_latest_deadlock;
      $self->{role}= "group_replication-PRIMARY"; ### For display
    }
    elsif (defined($group_replication_primary))
    {
      ### 0, if node is Group Replication SECONDARY
      $self->{role}= "group_replication-SECONDARY"; ### For display
    }
    else
    {
      ### undef, if node is NOT IN Group Replication.
      $self->{status}= NAGIOS_UNKNOWN;
      $self->{output}= sprintf("--role=%s is specified but this node is NOT in Group Replication", $role);
      return $self;
    }
 
    $self->check_group_replication_node_count;
    $self->check_group_replication_replica_lag;

    $self->check_long_query;
    $self->check_connection_count;
    $self->check_uptime;
    $self->check_history_list_length;
  }
  else
  {
    ### Unexpected role was specified by user.
    $self->{status}= NAGIOS_UNKNOWN;
    $self->{output}= sprintf("Unexpected role was specified. %s", $role);
  }
  $self->dump_detail;

  return $self;
}

sub DESTROY
{
  my ($self)= @_;
  $self->instance && $self->instance->DESTROY;
}

sub decide_role
{
  my ($self)= @_;
  my $master= my $slave= my $cluster= 0;

  $master= 1 if $self->show_slaves_via_processlist;
  $slave = 1 if ($self->instance->show_slave_status && $self->instance->show_slave_status->[0]);

  ### Stop _carp within internal version handling
  my $saved_ignore= $self->instance->{_ignore_unsupport_version};
  $self->instance->{_ignore_unsupport_version}= 1;

  $cluster= 1 if defined($self->instance->i_am_group_replication_primary);
  
  ### Restore param
  $self->instance->{_ignore_unsupport_version}= $saved_ignore;

  ### SHOW SLAVE STATUS condition is advanced more than cluster.
  if ($slave)
  {
    ### Intermidiate-master in a cascaded replication toporogy.
    return "intermidiate" if $master;
    return "slave";
  }
  elsif ($cluster)
  {
    return "group_replication";
  }
  else
  {
    return "master";
  }
}

sub result
{
  my ($self)= @_;

  $self->print_status;
  exit $self->{status}->{exit_code};
}

sub print_status
{
  my ($self)= @_;
  _printf("%s on %s: %s (%s)\n%s",
          $self->{status}->{str}, $self->instance->hostname,
          $self->{output}, $self->{role},
          $self->{dump_detail} && $self->{status}->{exit_code} ne NAGIOS_OK->{exit_code} ? 
            "-  Details in " . $self->{dump_detail} : 
            "");
}

sub check_long_query
{
  my ($self)= @_;
  return 0 unless $self->{long_query}->{enable};

  ### Evaluate each thread.
  my @warning_thread;
  my @critical_thread;
  foreach my $row (@{$self->instance->show_processlist})
  {
    my $user= $row->{User};

    ### Exclude by user.
    if (grep {/^$user$/} ("system user", "event_scheduler"))
    {
      ### Ignore replication threads and daemon plugin
	next;
    }

    ### Exclude by user in optional.
    if (grep { $user eq $_ } @{$self->{long_query}->{exclude_user}})
    {
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
      ### show processlist's "Host" is ip_or_hostname:port style.
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

    if ($status->{str} eq "WARNING")
    {
      push(@warning_thread, sprintf(q{Detected long query(%d sec) by %s@%s: "%s"},
                                    $row->{Time}, $row->{User},
                                    $row->{Host}, $row->{Info})) if $row->{Info};
    }
    elsif ($status->{str} eq "CRITICAL")
    {
      ### Push @warning_thread too for the timing of CRITICAL fallbacks to WARNING.
      push(@critical_thread, sprintf(q{Detected long query(%d sec) by %s@%s: "%s"},
                                     $row->{Time}, $row->{User},
                                     $row->{Host}, $row->{Info})) if $row->{Info};
      push(@warning_thread, sprintf(q{Detected long query(%d sec) by %s@%s: "%s"},
                                    $row->{Time}, $row->{User},
                                    $row->{Host}, $row->{Info})) if $row->{Info};
    }
  } ### End of foreach, goes to the next row.

  ### Calc between count and min_critical_thread
  my $critical_count= @critical_thread;
  my $warning_count= @warning_thread;
  if ($critical_count >= $self->{long_query}->{min_critical_thread})
  {
    $self->update_status(NAGIOS_CRITICAL, join("\n", @critical_thread));
  }
  elsif ($warning_count >= $self->{long_query}->{min_warning_thread})
  {
    $self->update_status(NAGIOS_WARNING, join("\n", @warning_thread));
  }

  return;
}

sub check_connection_count
{
  my ($self)= @_;
  return 0 unless $self->{connection_count}->{enable};

  my $current= $self->instance->show_status->{Threads_connected}->{Value};
  my $setting= $self->instance->show_variables->{max_connections}->{Value};
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

  ### Treat as WARNING if innodb_stats_on_metadata = ON
  if ($self->instance->stats_on_metadata)
  {
    $self->update_status(NAGIOS_WARNING, "--autoinc-usage-enable was falling-back to 0 " .
                                         "because innodb_stats_on_metadata = ON could cause performance problem " .
                                         "when accessing information_schema.tables and etc.");
    return 0;
  }

  ### select_autoinc_usage can raise an error when server has many tables
  eval
  {
    $self->instance->select_autoinc_usage;
  };

  if ($@)
  {
    ### Treat as NAGIOS_CRITICAL
    $self->update_status(NAGIOS_CRITICAL, sprintf("check_autoinc_usage fails because %s. " .
                                                  "Please consider --autoinc-usage-enable=0 " .
                                                  "(Maybe there are too much tables)",
                                                  $@));
  }
  else
  {
    foreach my $row (@{$self->instance->select_autoinc_usage})
    {
      ### Calculate max value of autoinc from datatype.
      my ($type, $unsigned)= $row->{column_type} =~ /^([a-z]+)(?:\(.+\))?(\s+(unsigned))?/;
      my $max= 2 ** (BYTES->{$type} * 8 - ($unsigned ? 0 : 1));
      my $ratio= ($row->{auto_increment} / $max) * 100;

      my $status= compare_threshold($ratio, $self->{autoinc_usage});
      $self->update_status($status, sprintf(qq{table %s.%s uses auto_increment column %s %5.2f%%(%d/%d)"\t},
                                            $row->{table_schema}, $row->{table_name}, $row->{column_name},
                                            $ratio, $row->{auto_increment}, $max)) if $status;
    }
  }

  return;
}

sub check_read_only
{
  my ($self)= @_;

  my $status   = NAGIOS_OK;
  my $read_only= $self->instance->show_variables->{read_only}->{Value};

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
                                        $self->instance->show_variables->{read_only}->{Value})) if $status;
}

sub check_slave_status
{
  my ($self)= @_;
  return 0 unless $self->{slave_status}->{enable};

  foreach my $row (@{$self->instance->show_slave_status})
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

  ### mikasafabric >= 0.6.10 had implemented "dump.health" command.
  if (my $try= $self->query_fabric("dump.health"))
  {
    foreach my $group (@$try)
    {
      my $group_id= $group->{group_id};

      if ($group->{primary} < 1)
      {
        $status= NAGIOS_CRITICAL;
        $output= sprintf("group %s does not have Master Server", $group_id);
        $self->update_status($status, $output);
      }

      if ($group->{secondary} < 1)
      {
        $output= sprintf("group %s does not have Candidate-Slave Server", $group_id);
        if ($self->{fabric_no_candidate} eq "critical")
        {
          $status= NAGIOS_CRITICAL;
          $self->update_status($status, $output);
        }
        elsif ($self->{fabric_no_candidate} eq "warning")
        {
          $status= NAGIOS_WARNING;
          $self->update_status($status, $output);
        }
      }

      if ($group->{faulty} > 0)
      {
        $output= sprintf("group %s has Faulty state server.", $group_id);
        if ($self->{fabric_faulty} eq "critical")
        {
          $status= NAGIOS_CRITICAL;
          $self->update_status($status, $output);
        }
        elsif ($self->{fabric_faulty} eq "warning")
        {
          $status= NAGIOS_WARNING;
          $self->update_status($status, $output);
        }
      }
    }
  }
  else
  {
    ### "dump.health" cannot use, using old-way to check.

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

sub compare_threshold_reverse
{
  my ($value, $threshold)= @_;

  if ($value < $threshold->{critical})
  {
    return NAGIOS_CRITICAL;
  }
  elsif ($value < $threshold->{warning})
  {
    return NAGIOS_WARNING;
  }
  return NAGIOS_OK;
}

sub show_slaves_via_processlist
{
  my ($self)= @_;
  return 0 unless $self->instance->show_processlist;

  foreach my $row (@{$self->instance->show_processlist})
  {
    ### "Binlog Dump (GTID)" is in processlist, the server maybe master.
    return 1 if $row->{Command} =~ /^Binlog\sDump/;
  }
  return 0;
}

sub query_fabric
{
  my ($self, $function, $arg)= @_;

  ### Query for mikasafabric doesn't cache but this for unit-test.
  my $cache_name= sprintf("_%s", $function);

  if (!(defined($self->{$cache_name})))
  {
    my $sql = sprintf("CALL %s(%s)", $function, $arg ? "'" . $arg . "'" : "");
    my $stmt= $self->instance->conn->prepare($sql, {Slice => {}});

    eval
    {
      $stmt->execute;
    };

    if ($self->instance->conn->{mysql_errno} == 1106)
    {
      ### Got error 1106, its unknown command. (ex. dump.health in < 0.6.10)
      return undef;
    }
    else
    {
      ### Skip, 1st Result set is metadata.
      $stmt->fetchall_arrayref();
      $stmt->more_results;        ### Go ahead to next Result set.

      $self->{$cache_name}= $stmt->fetchall_arrayref({});
    }
  }

  my $ret= $self->{$cache_name};

  ### Clear buffer each time.
  delete($self->{$cache_name});
  return $ret;
}

sub check_gtid_hole
{
  my ($self)= @_;
  return 0 unless $self->{gtid_hole}->{enable};

  my ($status, $output);

  ### Split for each server_uuid's gtid.
  ### gtid_executed= 'server_uuid1:gtid-range1:gtid-range2:..,server_uuid2:gtid-range3,..'
  foreach my $one_server_gtid (split(/,/, $self->instance->gtid))
  {
    my ($server_uuid, @gtid_range)= split(/:/, $one_server_gtid);

    ### If 1-server_uuid has more than 2-gtid_range, there's gtid_hole.
    $self->update_status(NAGIOS_WARNING, sprintf("gitd_executed hole detected(%s) ", $one_server_gtid))
      if $#gtid_range > 0;
  }
}

sub check_offline_mode
{
  my ($self)= @_;

  ### Check offline_mode (treat as same as failed to connect when offline_mode=1)
  if ($self->instance->show_variables && ### Connection-fail
      $self->instance->show_variables->{offline_mode} && ### For < 5.7
      $self->instance->show_variables->{offline_mode}->{Value} eq "ON")
  {
    $self->{status}= NAGIOS_CRITICAL;
    $self->{output}= "MySQL Server is now offline mode.";
    return 1;
  }
  return 0;
}

sub check_latest_deadlock
{
  my ($self)= @_;
  return 0 unless $self->{deadlock}->{enable};

  my $latest= $self->instance->latest_deadlock;
  my $diff  = localtime() - $latest;

  my $status= compare_threshold_reverse($diff, $self->{deadlock});
  $self->update_status($status, sprintf(qq{LATEST DETECTED DEADLOCK has occurred at %s},
                                        $latest)) if $status;
  return 0; 
}

sub check_uptime
{
  my ($self)= @_;
  return 0 unless $self->{uptime}->{enable};

  my $uptime= $self->instance->show_status->{Uptime}->{Value};
  my $status= compare_threshold_reverse($uptime, $self->{uptime});

  $self->update_status($status, sprintf("Uptime is too small %d", $uptime)) if $status;
  return 0;
}

sub check_history_list_length
{
  my ($self)= @_;
  return 0 unless $self->{history_list}->{enable};

  if ($self->instance->support_version(50602))
  {
    my $length= $self->instance->history_list_length;
    my $status= compare_threshold($length, $self->{history_list});
    $self->update_status($status, sprintf("trx_rseg_history_len is %d", $length)) if $status;
  }
  else
  {
    ### Unsupported versions for --history-list-enable=1
    _carpf("Version %s is not supported check_history_list_length. Use --history-list-enable=0 for turning off this function. ",
           $self->instance->valueof("version"));
  }

  return 0;
}

sub check_group_replication_node_count
{
  my ($self)= @_;
  
  my $count= grep { $_->{member_state} && $_->{member_state} eq "ONLINE" } @{$self->instance->replication_group_members};
  my $status= compare_threshold_reverse($count, { warning => 3, critical => 2 });

  $self->update_status($status, sprintf("ONLINE Group Replication Member is %d. ", $count)) if $status;

  if ($self->instance->i_am_group_replication_recovering)
  {
    $self->update_status(NAGIOS_WARNING, "Group Replication in RECOVERING state. ");
  }
  return 0;
}

sub check_group_replication_replica_lag
{
  my ($self)= @_;
  return 0 unless $self->{group_replication_lag_enable};

  ### If node is entering RECOVERING state, mysqlrouter is devide node from load-balancing,
  ### Group Replication lag is not matter.
  if ($self->instance->i_am_group_replication_recovering)
  {
    ### Change critical threshold to supernum to fall back as WARNING
    $self->{group_replication_lag_transactions}->{critical}= 2 ** 63 - 1;
    $self->{group_replication_lag_seconds}->{critical}= 2 ** 63 - 1;
  }

  ### How many commits not yet applied.
  my $trx_lag= $self->instance->replication_group_member_stats->[0]->{count_transactions_remote_in_applier_queue} // 0;
  my $trx_status= compare_threshold($trx_lag, $self->{group_replication_lag_transactions});
  $self->update_status($trx_status, sprintf("%d transactions are queued in Group Replication. ", $trx_lag)) if $trx_status;

  ### How many seconds between "STARTING APPLY" and "COMMITTED ORIGINAL"
  my $applier_time_lag= $self->instance->replication_applier_status->{group_replication_applier}->{_diff} // 0;
  my $applier_status= compare_threshold($applier_time_lag, $self->{group_replication_lag_seconds});
  $self->update_status($applier_status,
                       sprintf("Group Replication Applier Seconds_Behind_Master is %d. ", $applier_time_lag)) if $applier_status;

  my $recovery_time_lag= $self->instance->replication_applier_status->{group_replication_recovery}->{_diff} // 0;
  my $recovery_status= compare_threshold($recovery_time_lag, $self->{group_replication_lag_seconds});
  $self->update_status($recovery_status,
                       sprintf("Group Replication Applier Seconds_Behind_Master is %d. ", $recovery_time_lag)) if $recovery_status;

  return 0;
}

sub dump_detail
{
  my ($self)= @_;
  return 0 if !($self->{dump_detail});

  ### Don't dump information when status is OK.
  return 0 if $self->{status}->{exit_code} eq NAGIOS_OK->{exit_code};

  ### mikasafabric could not dump information.
  return 0 if $self->{role} eq "fabric";

  my $fh;
  eval
  {
    $fh= IO::File->new($self->{dump_detail}, "a");
  };

  if ($@ || !($fh))
  {
    ### Falling down to STDERR
    _carpf("Couldn't open %s, falling back to STDERR\n", $self->{dump_detail});
    $fh= IO::Handle->new_from_fd(2, "w");
  }
  binmode $fh, ":utf8";

  printf($fh "# %s\n", localtime->strftime("%Y/%m/%d %H:%M:%S"));
  printf($fh "# %s on %s: %s (%s)\n",
         $self->{status}->{str}, $self->instance->hostname,
         $self->{output}, $self->{role},
         localtime->cdate);
  printf($fh "%s\n", $self->instance->print_information);

  return 1;
}

sub _config
{
  my $role_text= << "EOS";
Switching check-item as below,
    - "master", "source", "primary"
      - Long query
      - Connection count
      - AUTO_INCREMENT usage
      - read_only should be OFF
      - Uptime
    - "slave", "read", "replica", "standby", "secondary"
      - Long query
      - Replication threads
      - Replication delay
      - Connection count
      - read_only should be ON
      - Uptime
    - "intermidiate", "cascade"
      - Long query
      - Connection count
      - AUTO_INCREMENT usage
      - Replication threads
      - Replication delay
      - read_only should be OFF
      - Uptime
    - "backup"
      - Replication threads
      - read_only should be ON
    - "auto"
      - Script determines MySQL is "master", "slave" or "intermidiate" automatically 
        by using SHOW SLAVE STATUS and SHOW SLAVE HOSTS(Result is empty or not)
    - "none"
      - Check only connectivity. For calling as library.
    - "fabric"
      - Checking for mikasafabric for MySQL.
    - "group_replication"
      - Long query
      - Connection count
      - AUTO_INCREMENT usage (If member_state is PRIMARY)
      - Group Replication status
      - Group Replication delay
      - Uptime
EOS

  my $yt_healthcheck_option=
  {
    role => { alias => ["role"],
              isa  => ["auto", "master", "source", "primary", "slave", "replica", "read", "standby", "secondary", "backup", "fabric", "none", "intermidiate", "cascade", "group_replication"],
              default => "auto",
              text => $role_text },
    long_query =>
    {
      enable        => { default => 1,
                         text    => qq{When set to 0, turn off SHOW PROCESSLIST's check.} },
      warning       => { default => 5,
                         text    => qq{Warning threshold for "SHOW PROCESSLIST"'s "Time"(seconds)} },
      critical      => { default => 100,
                         text    => qq{Critical threshold for "SHOW PROCESSLIST"'s "Time"(seconds)} },
      exclude_user  => { multi   => 1,
                         text    => qq{Specify to ignore values for "SHOW PROCESSLIST"'s "User".\n} .
                                    qq{  When first-match them, doesn't raise WARNING or CRITICAL(always OK)} },
      exclude_host  => { multi   => 1,
                         text    => qq{Specify to ignore values for "SHOW PROCESSLIST"'s "Host".\n} .
                                    qq{  When first-match them, doesn't raise WARNING or CRITICAL(always OK)} },
      exclude_query => { multi   => 1,
                         text    => qq{Specify to ignore values for "SHOW PROCESSLIST"'s "Info"(SQL statement)\n} .
                                    qq{  When first-match them, doesn't raise WARNING or CRITICAL(always OK)} },
      min_warning_thread => { default => 1,
                              text    => qq{Don't return NAGIOS_WARNING when threads which is over long-query-warning\n} .
                                         qq{  are less than long-query-min-warning-thread} },
      min_critical_thread => { default => 1,
                               text    => qq{Don't return NAGIOS_CRITICAL when threads which is over long-query-critical\n} .
                                          qq{  are less than long-query-min-critical-thread} },
    },
    connection_count =>
    {
      enable   => { default => 1,
                    text    => qq{When set to 0, turn off connection count check.} },
      warning  => { default => 70,
                    text    => qq{Warning threshold for "Threads_connected / max_connections"(percentage)} },
      critical => { default => 95,
                    text    => qq{Critical threshold for "Threads_connected / max_connections"(percentage)} },
    },
    autoinc_usage =>
    {
      enable   => { default => 1,
                    text    => qq{When set to 0, turn off auto_increment usage calculation.} },
      warning  => { default => 50,
                    text    => qq{Warning threshold for "current_auto_increment_value / datatype_max"(percentage)} },
      critical => { default => 90,
                    text    => qq{Critical threshold for "current_auto_increment_value / datatype_max"(percentage)} },
    },
    slave_status =>
    {
      enable   => { default => 1,
                    text    => qq{When set to 0, turn off "SHOW SLAVE STATUS"'s "Seconds_Behind_Master" check.} },
      warning  => { default => 5,
                    text    => qq{Warning threshold for "Seconds_Behind_Master"(seconds)} },
      critical => { default => 30,
                    text    => qq{Critical threshold for "Seconds_Behind_Master"(seconds)} },
    },
    fabric_fd  =>
    {
      enable   => { default => 1,
                    text    => qq{When set to 0, turn off "CALL manage.openfds()" check.(mikasafabric only)} },
      warning  => { default => 50,
                    text    => qq{Warning threshold for "current_fd / max_fd"(percentage)} },
      critical => { default => 70,
                    text    => qq{Critical threshold for "current_fd / max_fd"(percentage)} },
    },
    fabric_faulty =>
    {
      isa     => ["ignore", "warning", "critical"],
      default => "ignore",
      text    => q{Reporting level when mikasafabric has faulty-state managed server.}
    },
    fabric_no_candidate =>
    {
      isa     => ["ignore", "warning", "critical"],
      default => "critical",
      text    => q{Reporting level when managed group has no Candidate-Slave server.}
    },
    gtid_hole =>
    {
      enable => { default => 0,
                  text    => qq{When set to 1, check does gtid_hole exist.\n} .
                             qq{  When gtid_executed is like "server_uuid:1-2:4-5", server_uuid:3 is gtid_hole.\n} .
                             qq{  This option default will be 1 in future release.} },
    },
    deadlock =>
    {
      enable => { default => 0,
                  text    => "When set to 1, check LATEST DETECTED DEADLOCK section in SHOW ENGINE INNODB STATUS.", },
      warning => { default => 300,
                   text    => "Warning threshold for LATEST DETECTED DEADLOCK time (seconds)", },
      critical => { default => 1,
                   text    => "Critical threshold for LATEST DETECTED DEADLOCK time (seconds)", },
    },
    uptime =>
    {
      enable => { default => 1,
                  text => "When set to 1, check Uptime from SHOW GLOBAL STATUS.", },
      warning => { default => 300,
                   text => "Warning threshold for Uptime(seconds)", },
      critical => { default => 300,
                    text => "Critical threshold for Uptime(seconds)", },
    },
    history_list =>
    {
      enable => { default => 0,
                  text => "When set to 1, check trx_rseg_history_len from information_schema.innodb_metrics.", },
      warning => { default => 100000,
                   text => "Warning threshold for trx_rseg_history_len", },
      critical => { default => 500000,
                    text => "Critical threshold for trx_rseg_history_len", },
    },
    group_replication_lag_enable => { default => 1,
                                      text    => qq{When set to 0, turn off Group Replication Lag check.} },
    group_replication_lag_transactions =>
    {
      warning  => { default => 100,
                    text    => qq{Warning threshold for Group Replication Lag (queued transactions)} },
      critical => { default => 10000,
                    text    => qq{Critical threshold for Group Replication Lag (queued transactions)} },
    },
    group_replication_lag_seconds =>
    {
      warning  => { default => 5,
                    text    => qq{Warning threshold for Group Replication Lag (seconds)} },
      critical => { default => 30,
                    text    => qq{Critical threshold for Group Replication Lag (seconds)} },
    },
    dump_detail      => { alias   => ["dump-detail"],
                          text    => qq{When result is NOT NAGIOS_OK,\n} .
                                     qq{  output results of "SHOW PROCESSLIST", "SHOW SLAVE STATUS" } .
                                     qq{and "SHOW ENGINE INNODB STATUS"" into specified file}, }
 
  };

  my $config= Ytkit::Config->new({ %$yt_healthcheck_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
} 

return 1;
