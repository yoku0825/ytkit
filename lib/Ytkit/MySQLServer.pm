package Ytkit::MySQLServer;

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
use DBI;
use Time::Piece qw{ localtime };
use Ytkit::IO;

### Timeout for i_s query.
use constant ALRM_TIME      => 3;
use constant ALRM_MSG       => "SIGALRM";
use constant ABORT_I_S      => "Querying information_schema is too dangerous for this instance. Aborting.";
use constant ERRNO_INTERNAL => 9999;
use constant ER_NO_SUCH_TABLE => 1146;

### Implicit default
$ENV{ytkit_ignore_warning} //= "";

sub new
{
  my ($class, $opt)= @_;

  my $self=
  {
    _hostname => undef,
    _version  => undef,
    _opt      => $opt,
    _conn     => undef,
    _error    => undef,
    _errno    => undef,
    _warning  => undef,
    _do_not_query_i_s => 0,
    _ignore_unsupport_version => 0,
  };
  bless $self => $class;

  return $self;
}

sub DESTROY
{
  my ($self)= @_;
  return undef if !($self->{_conn});
  eval
  {
    _debugf("Ytkit::MySQLServer is destroyed.");
    $self->conn->disconnect;
  };
}

sub error
{
  my ($self, $arg)= @_;

  if (defined($arg))
  {
    $self->{_error}= $arg;
  }
  else
  {
    return $self->{_error};
  }
}

sub errno
{
  my ($self, $arg)= @_;

  if (defined($arg))
  {
    $self->{_errno}= $arg;
  }
  else
  {
    return $self->{_errno};
  }
}

sub warning
{
  my ($self, $arg)= @_;

  if (defined($arg))
  {
    $self->{_warning}= $arg;
  }
  else
  {
    return $self->{_warning};
  }
}

sub raise_if_error
{
  my ($self)= @_;

  _croakf($self->error) if $self->error;
  _carpf($self->warning) if @{$self->warning};
}

sub warn_if_error
{
  my ($self)= @_;

  _carpf($self->error) if $self->error;
  _carpf($self->warning) if @{$self->warning};
}

sub exec_sql_with_croak
{
  my ($self, $sql, $opt, @argv)= @_;
  $self->exec_sql($sql, $opt, @argv);
  $self->raise_if_error;
}

sub exec_sql_with_carp
{
  my ($self, $sql, $opt, @argv)= @_;
  $self->exec_sql($sql, $opt, @argv);
  $self->warn_if_error;
}

sub use
{
  my ($self, $schema)= @_;
  $self->exec_sql_with_croak("USE $schema");
}

sub conn
{
  my ($self)= @_;

  if (!($self->{_conn}))
  {
    my $opt= $self->{_opt};
    my $dsn= "dbi:mysql:";
    $dsn  .= sprintf(";host=%s", $opt->{host}) if $opt->{host};
    $dsn  .= sprintf(";port=%d", $opt->{port}) if $opt->{port};
    $dsn  .= sprintf(";mysql_socket=%s", $opt->{socket}) if $opt->{socket};

    eval
    {
      _debugf("Connect to %s@%s", $opt->{user}, $dsn);
      $self->{_conn}= DBI->connect($dsn, $opt->{user}, $opt->{password},
                                   { mysql_enable_utf8     => 1,
                                     mysql_connect_timeout => $opt->{timeout},
                                     mysql_write_timeout   => $opt->{timeout}, 
                                     mysql_read_timeout    => $opt->{timeout},
                                     RaiseError            => 1, 
                                     PrintError            => 0,
                                   });
    };

    if ($@)
    {
      _debugf("Connection failure %s", $@);
      $self->error($@);
      $self->errno(ERRNO_INTERNAL);
      $self->{_conn}= undef;
    }
  }
  return $self->{_conn};
}

sub exec_sql
{
  my ($self, $sql, $opt, @argv)= @_;
  my $ret;

  if (my $conn= $self->conn)
  {
    $self->_clear_error_buf;
    return undef if $self->error;

    eval
    {
      _debugf("Execute %s (%s)", $sql, join(", ", @argv));
      $ret= $conn->do($sql, $opt, @argv);
    };

    if ($@)
    {
      my $err_msg= sprintf("%s (%s): %s", $sql, join(", ", @argv), $@);
      _debugf($err_msg);
      $self->error($err_msg);
      $self->errno($conn->{mysql_errno});
      return undef;
    }

    $self->check_warnings;
  }

  return $ret;
}

sub hostname
{
  my ($self)= @_;
  return $self->{_hostname} if $self->{_hostname};

  $self->{_hostname}= $self->valueof("hostname") || $self->{_opt}->{host};
  return $self->{_hostname};
}

sub port
{
  my ($self)= @_;
  $self->{_port} ||= $self->valueof("port");
  return $self->{_port};
}

sub mysqld_version
{
  my ($self)= @_;

  if (!($self->{_version}))
  {
    if (my $version_raw= $self->valueof("version"))
    {
      $version_raw =~ /^(\d+)\.(\d+)\.(\d+)/;
      $self->{_version}= sprintf("%d%02d%02d", $1, $2, $3);
    }
    else
    {
      $self->{_version}= 0;
    }
  }
  return $self->{_version};
}

sub show_slave_status
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW SLAVE STATUS");
}

sub show_slave_hosts
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW SLAVE HOSTS");
}

sub show_processlist
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW FULL PROCESSLIST");
}

sub show_status
{
  my ($self)= @_;
  return $self->query_hashref("SHOW GLOBAL STATUS", "Variable_name");
}

sub show_variables
{
  my ($self)= @_;
  return $self->query_hashref("SHOW GLOBAL VARIABLES", "Variable_name");
}

sub select_autoinc_usage
{
  my ($self)= @_;
  return [] if !($self->support_version(50002));

  ### 8.0.13 and later uses cache for i_s.tables...
  $self->update_stats_expiry if $self->mysqld_version >= 80013 && $self->should_set_stats_expiry;

  my $sql= << "EOS";
SELECT
  table_schema AS table_schema,
  table_name AS table_name,
  column_name AS column_name,
  auto_increment AS auto_increment,
  column_type AS column_type
FROM
  information_schema.tables 
    JOIN information_schema.columns USING(table_schema, table_name)
WHERE
  table_schema NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys') AND
  table_type = 'BASE TABLE' AND
  auto_increment IS NOT NULL AND 
  extra = 'auto_increment'
EOS
  return $self->query_arrayref($sql);
}

sub show_master_logs
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW MASTER LOGS");
}

sub describe_table
{
  my ($self, $table)= @_;
  return $self->query_arrayref("DESC " . $table);
}

sub select_innodb_trx
{
  my ($self)= @_;
  return [] if !($self->support_version(50508));

  return $self->query_arrayref("SELECT * FROM information_schema.innodb_trx ORDER BY trx_started DESC");
}

sub select_ps_digest
{
  my ($self, $limit)= @_;
  return [] if !($self->support_version(50605));

  ### Compatibility between 0.2.1-7 and 0.2.1-8
  if ($ENV{ytkit_collect_compat})
  {
    ### Old behavior
    return $self->_select_ps_digest_old_compat($limit);
  }
  else
  {
    ### New (2 columns added) behavior
    my $sql= << "EOS";
SELECT
  schema_name,
  digest,
  digest_text,
  count_star,
  sum_timer_wait,
  sum_rows_examined,
  sum_rows_sent,
  sum_sort_rows,
  sum_created_tmp_tables,
  NOW() AS last_update
FROM
  performance_schema.events_statements_summary_by_digest
WHERE
  digest_text NOT LIKE 'SET %' AND
  digest_text NOT LIKE 'DESC %' AND
  digest_text NOT LIKE 'SHOW %'
ORDER BY
  count_star DESC
EOS
    $sql .= sprintf(" LIMIT %d", $limit) if $limit;
 
    return $self->query_arrayref($sql);
  }
}

sub _select_ps_digest_old_compat
{
  my ($self, $limit)= @_;
  return [] if !($self->support_version(50605));

  my $sql= << "EOS";
SELECT
  schema_name,
  digest,
  digest_text,
  count_star,
  sum_timer_wait,
  sum_rows_examined,
  sum_rows_sent,
  NOW() AS last_update
FROM
  performance_schema.events_statements_summary_by_digest
WHERE
  digest_text NOT LIKE 'SET %' AND
  digest_text NOT LIKE 'DESC %' AND
  digest_text NOT LIKE 'SHOW %'
ORDER BY
  count_star DESC
EOS

  $sql .= sprintf(" LIMIT %d", $limit) if $limit;
 
  return $self->query_arrayref($sql);
}

sub select_ps_table
{
  my ($self, $limit)= @_;
  return [] if !($self->support_version(50602));

  my $sql= << "EOS";
SELECT
  object_schema AS table_schema, 
  object_name AS table_name,
  count_read,
  sum_timer_read,
  count_write,
  sum_timer_write,
  NOW() AS last_update
FROM 
  performance_schema.table_io_waits_summary_by_table
WHERE
  count_star > 0
ORDER BY
  count_star DESC
EOS
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;
 
  return $self->query_arrayref($sql);
}

sub select_ps_threads
{
  my ($self)= @_;
  return [] if !($self->support_version(50602));

  my $sql= "SELECT * FROM performance_schema.threads"; ### Need lower column-names?
  return $self->query_arrayref($sql);
}

sub select_is_table_by_size
{
  my ($self, $limit)= @_;
  return [] if !($self->support_version(50002));

  ### 8.0.13 and later uses cache for i_s.tables...
  $self->update_stats_expiry if $self->mysqld_version >= 80013 && $self->should_set_stats_expiry;

  my $sql= << "EOS";
SELECT
  table_schema AS table_schema,
  table_name AS table_name,
  table_rows AS table_rows,
  data_length AS data_length,
  index_length AS index_length,
  data_free AS data_free,
  engine AS engine,
  NOW() AS last_update
FROM
  information_schema.tables
WHERE
  table_schema NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys') AND
  table_type = 'BASE TABLE'
ORDER BY
  data_length + index_length DESC
EOS
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;

  return $self->query_arrayref($sql);
}

sub select_is_metrics
{
  my ($self)= @_;
  return [] if !($self->support_version(50602));

  my $sql= "SELECT name AS name, " .
                  "count AS count, " .
                  "NOW() AS last_update " .
           "FROM information_schema.innodb_metrics " .
           "WHERE STATUS <> 'disabled'";
  return $self->query_arrayref($sql);
}

sub select_user_list
{
  my ($self)= @_;
  return $self->query_arrayref("SELECT user, host FROM mysql.user ORDER BY user, host");
}

sub show_grants
{
  my ($self, $user, $host)= @_;

  $user ||= '';
  $host ||= '%';

  ### Fix variable column-name
  if (my $ret= $self->query_arrayref("SHOW GRANTS FOR ?@?", $user, $host))
  {
    my ($column_name)= keys(%{$ret->[0]});
    my @ret= map { +{ grants => $_->{$column_name} } } @$ret;

    ### Don't have cache.
    delete($self->{_show_grants});
    return \@ret;
  }
  ### Don't have cache.
  delete($self->{_show_grants});
  return undef;
}

sub query_arrayref
{
  my ($self, $sql, @argv)= @_;
  my $caller= (caller 1)[3] || "";
  my ($caller_name)= $caller =~ /::([^:]+)$/;
  $caller_name ||= "";

  ### Normalize SQL
  $sql =~ s/\s+/ /g;
 
  ### Add $caller as comment 
  $sql = "/* ytkit $caller_name */ " . $sql;

  if (!(defined($self->{"_" . ${caller_name}})))
  {
    $self->reconnect;
    ### Gurad for out-controlled query of information_schema.
    my $i_s_query= 0;
    if ($sql =~ /\binformation_schema\.(?:tables|columns)/i)
    {
      ### If already timed out i_s query, then stop script.
      if ($self->{_do_not_query_i_s})
      {
        _debugf("_do_not_query_i_s is flagged");
        $self->error(ABORT_I_S);
        $self->errno(ERRNO_INTERNAL);
        _croakf(ABORT_I_S);
      }
      $i_s_query= 1;
      
      ### Set timeout
      alarm(ALRM_TIME);
    } ### Not i_s query doesn't set alarm.

    $self->_clear_error_buf;
    my $conn= $self->conn;
    return undef if $self->error;

    my $buff;
    eval
    {
      local $SIG{ALRM}= sub { _croakf(ALRM_MSG) };
      $buff= $self->_real_query_arrayref($sql, @argv);
    };
    $self->{"_" . ${caller_name}}= $buff;

    ### Disable alarm.
    alarm(0);
 
    if ($@)
    {
      if ($i_s_query)
      {
        ### When got timeout for i_s query, abort and should be handled by upper-layer.
        _debugf("Turn on _do_not_query_i_s");
        $self->{_do_not_query_i_s}= 1;
      }

      $self->_set_error_buf_from_conn;
      _croakf("Error occurs during query %s (%s): %s", $sql, join(", ", @argv), $@);
    }

    $self->check_warnings;
  }
  return $self->{"_" . ${caller_name}};
}

sub _real_query_arrayref
{
  my ($self, $sql, @argv)= @_;

  _debugf("Querying: %s (%s)", $sql, join(", ", @argv));
  return $self->conn->selectall_arrayref($sql, {Slice => {}}, @argv);
}

sub _real_query_hashref
{
  my ($self, $sql, $key, @argv)= @_;

  _debugf("Querying: %s (%s)", $sql, join(", ", @argv));
  return $self->conn->selectall_hashref($sql, [$key], @argv);
}

sub query_hashref
{
  my ($self, $sql, $key, @argv)= @_;
  my $caller= (caller 1)[3] || "";
  my ($caller_name)= $caller =~ /::([^:]+)$/;
  $caller_name ||= "";

  ### Normalize SQL
  $sql =~ s/\s+/ /g;
 
  ### Add $caller as comment 
  $sql = "/* ytkit $caller_name */ " . $sql;

  if (!(defined($self->{"_" . ${caller_name}})))
  {
    $self->reconnect;
    ### Gurad for out-controlled query of information_schema.
    my $i_s_query= 0;
    if ($sql =~ /\binformation_schema\.(?:tables|columns)/i)
    {
      ### If already timed out i_s query, then stop script.
      _croakf("Querying information_schema is too dangerous for this instance. Aborting.")
        if $self->{_do_not_query_i_s};
      $i_s_query= 1;
      
      ### Set timeout
      alarm(ALRM_TIME);
    } ### Not i_s query doesn't set alarm.

    $self->_clear_error_buf;
    my $conn= $self->conn;
    return undef if $self->error;

    my $buff;
    eval
    {
      local $SIG{ALRM}= sub { _croakf(ALRM_MSG) };
      $buff= $self->_real_query_hashref($sql, $key, @argv);
    };
    $self->{"_" . ${caller_name}}= $buff;

    if ($@)
    {
      if ($i_s_query)
      {
        ### When got timeout for i_s query, abort and should be handled by upper-layer.
        $self->{_do_not_query_i_s}= 1;

        ### Disable alarm.
        alarm(0);
      }

      $self->_set_error_buf_from_conn;
      _croakf("Error occurs during query %s (%s): %s", $sql, join(", ", @argv), $@);
    }

    $self->check_warnings;
  }
  return $self->{"_" . ${caller_name}};
}

sub check_warnings
{
  my ($self)= @_;

  my @warn;
  if ($self->{__test_show_warnings})
  {
    ### For test purpose
    @warn= @{$self->{__test_show_warnings}};
  }
  else
  {
    eval
    {
      @warn= @{$self->conn->selectall_arrayref("SHOW WARNINGS")};
      _debugf(\@warn) if @warn;
    };
  }

  ### Filtering by ytkit_ignore_warning
  my @filtered= ();
  foreach my $row (@warn)
  {
    push(@filtered, $row) if !(grep { $row->[1] eq $_ } split(",", $ENV{ytkit_ignore_warning}));
  }
  
  $self->warning(\@filtered);
}

sub clear_cache
{
  my ($self)= @_;

  foreach (keys(%$self))
  {
    $self->{$_}= undef if $_ =~ /^_/ && $_ ne "_conn" && $_ ne "_do_not_query_i_s";
  }
}

sub quote
{
  my ($self, $str)= @_;

  $self->conn;

  if ($self->error)
  {
    ### Return immitate-quote, if $self->conn is not connected.
    $str =~ s/\'/\\'/g;
    return qq{'$str'};
  }
  else
  {
    return $self->conn->quote($str);
  }
}

sub show_master_status
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW MASTER STATUS");
}

sub gtid
{
  my ($self)= @_;

  if (!($self->{_gtid}))
  {
    $self->{_gtid}= $self->show_master_status->[0]->{Executed_Gtid_Set} // "empty";
    ### format gtid_string.
    $self->{_gtid} =~ s/\n//g;
  }

  return $self->{_gtid};
}

sub stats_on_metadata
{
  my ($self)= @_;
  return $self->valueof("innodb_stats_on_metadata") eq "ON";
}

sub p_s_on
{
  my ($self)= @_;

  if ($self->mysqld_version >= 50608 &&
      $self->valueof("performance_schema") eq "ON")
  {
    return 1;
  }
  return 0;
}

sub  should_set_stats_expiry
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW SESSION VARIABLES LIKE 'information_schema_stats_expiry'")->[0]->{Value} // 0;
}

sub update_stats_expiry
{
  my ($self)= @_;
  return $self->exec_sql("/*!80013 SET SESSION information_schema_stats_expiry = 0; */");
}

sub valueof
{
  my ($self, $variable_name)= @_;

  if (my $variables= $self->show_variables)
  {
    if ($variables->{$variable_name})
    {
      return $variables->{$variable_name}->{Value};
    }
  }
  return "";
}

sub fetch_p_s_stage_innodb_alter_table
{
  my ($self)= @_;
  return [] if !($self->support_version(50706));

  my $sql= << "EOS";
SELECT
  name AS name,
  enabled AS enabled,
  timed AS timed
FROM
  performance_schema.setup_instruments
WHERE
  name LIKE 'stage/innodb/alter table%'
EOS

  return $self->query_arrayref($sql);
}

sub fetch_p_s_events_stages
{
  my ($self)= @_;
  return [] if !($self->support_version(50601));

  my $sql= << "EOS";
SELECT
  name AS name,
  enabled AS enabled
FROM
  performance_schema.setup_consumers
WHERE
  name LIKE 'events\_stages\_%'
EOS

  return $self->query_arrayref($sql);
}

sub alter_table_progress
{
  my ($self)= @_;
  return [] if !($self->support_version(50706));

  my $sql= << 'EOS';
SELECT
  thread_id AS thread_id,
  processlist_id AS processlist_id,
  event_name AS event_name,
  sql_text AS sql_text,
  @progress:= (work_completed / work_estimated) * 100 AS progress,
  @elapsed:= (timer_current - timer_start) / power(10, 12) AS elapsed,
  @elapsed * (100 / @progress) - @elapsed AS estimated
FROM
  (SELECT
     processlist_id AS processlist_id,
     stage.thread_id AS thread_id,
     stage.event_name AS event_name,
     work_completed AS work_completed,
     work_estimated AS work_estimated,
     (SELECT
        timer_start
      FROM
        performance_schema.events_statements_current
          JOIN
        performance_schema.threads
          USING(thread_id)
      WHERE
        processlist_id = @@pseudo_thread_id
     ) AS timer_current,
     statement.timer_start AS timer_start,
     sql_text AS sql_text
   FROM
     performance_schema.events_stages_current AS stage
       JOIN
     performance_schema.events_statements_current AS statement
       USING(thread_id)
       JOIN
     performance_schema.threads
       USING(thread_id)
  ) AS dummy
EOS
  return $self->query_arrayref($sql);
}

sub show_engine_innodb_status
{
  my ($self)= @_;
  return $self->query_arrayref("SHOW ENGINE INNODB STATUS");
}

sub thread_id
{
  my ($self)= @_;

  ### pseudo_thread_id is SESSION scope.
  return $self->query_arrayref("SHOW SESSION VARIABLES LIKE 'pseudo_thread_id'")->[0]->{Value} // 0;
}

sub fetch_innodb_lock_waits
{
  my ($self)= @_;

  ### Stop _carp within internal version handling
  my $saved_ignore= $self->{_ignore_unsupport_version};
  $self->{_ignore_unsupport_version}= 1;

  ### i_s is implemented in 5.1.38, sys is implemented in 5.7.7
  my $use_i_s= $self->support_version(50138);
  my $use_sys= $self->support_version(50707);

  ### Restore param
  $self->{_ignore_unsupport_version}= $saved_ignore;
 
  ### Can't use any information_schema.
  return [] if !($use_i_s);

  if ($use_sys)
  {
    return $self->_fetch_sys_innodb_lock_waits;
  }
  else
  {
    my $ret;
    eval
    {
      $ret= $self->_fetch_innodb_lock_waits_rawsql;
    };

    if ($@)
    {
      ### 5.1 builtin-InnoDB doesn't provide INNODB_TRX
      $self->errno(ERRNO_INTERNAL);
      $self->error("Unsupported version for fetch_innodb_lock_waits");
      return undef;
    }
    return $ret;
  }
}

sub history_list_length
{
  my ($self)= @_;
  my $ret;

  eval
  {
    $ret= $self->select_is_metrics;
  };
  return 0 if $@;

  my @row= grep { $_->{name} eq "trx_rseg_history_len" } @$ret;
  return $row[0]->{count} // 0;
}

sub _fetch_innodb_lock_waits_rawsql
{
  my ($self)= @_;
  return [] if !($self->support_version(50508));

  ### information_schema.innodb_lock* is not on 8.0
  return undef if $self->mysqld_version >= 80011;

  my $sql= << 'EOS';
SELECT 
  waiting_trx.trx_started AS waiting_trx_started,
  ROUND(NOW() - waiting_trx.trx_started) AS waiting_time,
  waiting_trx.trx_mysql_thread_id AS waiting_process_id,
  waiting_trx.trx_query AS waiting_query,
  /*!50508 waiting_trx.trx_rows_locked, */
  blocking_trx.trx_started AS blocking_trx_started,
  ROUND(NOW() - blocking_trx.trx_started) AS blocking_time,
  blocking_trx.trx_mysql_thread_id AS blocking_process_id,
  blocking_trx.trx_query AS blocking_query,
  /*!50508 blocking_trx.trx_rows_locked, */
  blocking_lock.lock_mode, 
  blocking_lock.lock_type, 
  blocking_lock.lock_table, 
  blocking_lock.lock_index,
  blocking_lock.lock_data
FROM 
  information_schema.innodb_lock_waits INNER JOIN 
  information_schema.innodb_locks AS blocking_lock ON innodb_lock_waits.blocking_lock_id = blocking_lock.lock_id INNER JOIN 
  information_schema.innodb_trx AS blocking_trx ON innodb_lock_waits.blocking_trx_id = blocking_trx.trx_id INNER JOIN 
  information_schema.innodb_trx AS waiting_trx ON innodb_lock_waits.requesting_trx_id = waiting_trx.trx_id
EOS

  return $self->query_arrayref($sql);
}

sub _fetch_sys_innodb_lock_waits
{
  my ($self)= @_;
  return $self->query_arrayref("SELECT * FROM sys.innodb_lock_waits");
}

sub latest_deadlock
{
  my ($self)= @_;

  $self->_clear_error_buf;
  my $text= $self->show_engine_innodb_status->[0]->{Status};

  my @tmp= split(/^---+\n/m, $text);
  my $ret;
  for (my $n= 0; $n <= $#tmp; $n++)
  {
    my $current= $tmp[$n];
    chomp($current);
    if ($current eq "LATEST DETECTED DEADLOCK")
    {
      $ret= $tmp[$n + 1];
    }
    else
    {
      next;
    }
  }
  return localtime(0) if !($ret);

  @tmp= split(/\s/, $ret);
  
  eval
  {
    $ret= localtime(Time::Piece->strptime($tmp[0] . " " . $tmp[1], "%y%m%d %H:%M:%S"));
  };
  
  if ($@)
  {
    eval
    {
      $ret= localtime(Time::Piece->strptime($tmp[0] . " " . $tmp[1], "%Y-%m-%d %H:%M:%S"));
    };
  }

  return $ret if !($@);
  return undef;
}

sub reconnect
{
  my ($self)= @_;

  ### Ping connection
  eval
  {
    $self->conn;
    $self->exec_sql("SELECT 1");
  };

  ### Reconnect if it fails.
  if ($@ || $self->error)
  {
    eval
    {
      _debugf("Disconnect.");
      $self->conn->disconnect;
    };
    delete($self->{_conn});
    $self->conn;
  }
}

sub _clear_error_buf
{
  my ($self)= @_;

  $self->error("");
  $self->errno(0);
  $self->warning([]);
 
  return 1;
}

sub _set_error_buf_from_conn
{
  my ($self)= @_;

  $self->error($self->{_conn}->{mysql_error});
  $self->errno($self->{_conn}->{mysql_errno});

  return 1;
}

sub print_information
{
  my ($self)= @_;
  my $line= "=" x 10;
  my $ret;

  eval
  {
    $self->show_processlist;
  };
  if (!($@))
  {
    $ret .= sprintf("\n%sSHOW PROCESSLIST%s\n\n", $line, $line);
    $ret .= _print_table($self->show_processlist);
  }

  eval
  {
    $self->show_slave_status;
  };
  if (!($@))
  {
    $ret .= sprintf("\n%sSHOW SLAVE STATUS%s\n\n", $line, $line);
    $ret .= _print_vtable($self->show_slave_status);
  }

  eval
  {
    $self->show_engine_innodb_status;
  };
  if (!($@))
  {
    $ret .= sprintf("\n%sSHOW ENGINE INNODB STATUS%s\n\n", $line, $line);
    $ret .= $self->show_engine_innodb_status->[0]->{Status};
  }

  eval
  {
    $self->fetch_innodb_lock_waits;
  };
  if (!($@))
  {
    $ret .= sprintf("\n%sSHOW INNODB LOCKS%s\n\n", $line, $line);
    $ret .= _print_vtable($self->fetch_innodb_lock_waits);
  }

  eval
  {
    $self->select_innodb_trx;
  };
  if (!($@))
  {
    $ret .= sprintf("\n%sINNODB TRANSACTIONS%s\n\n", $line, $line);
    $ret .= _print_vtable($self->select_innodb_trx);
  }

  eval
  {
    $self->select_ps_threads;
  };
  if (!($@))
  {
    $ret .= sprintf("\n%sperformance_schema.threads%s\n\n", $line, $line);
    $ret .= _print_table($self->select_ps_threads);
  }

  return $ret;
}

sub _print_table
{
  ### Argument should be `selectall_arrayref($sql, {Slice => {}})`
  my ($selectall_arrayref)= @_;

  if (!($selectall_arrayref) || !(@$selectall_arrayref))
  {
    ### Empty
    return "Empty\n";
  }

  my @columns= sort(keys(%{$selectall_arrayref->[0]}));

  ### Evaluate width of resultset.
  my %width= map { $_ => length($_) } @columns;
  foreach my $row (@$selectall_arrayref)
  {
    foreach my $column (@columns)
    {
      my $length= length($row->{$column});
      $length ||= 0;
      $width{$column}= $length
        if !($width{$column}) || ($width{$column} < $length);
    }
  }
  my $ret;
  
  ### header-line
  $ret .= sprintf("| %s |\n", join(" | ", map { my $format= sprintf("%%-%ds", $width{$_}); sprintf($format, $_); } @columns));
  $ret .= sprintf("| %s |\n", join(" | ", map { sprintf("-" x $width{$_}); } @columns));

  ### Print each line
  foreach my $row (@$selectall_arrayref)
  {
    $ret .= sprintf("| %s |\n", join(" | ",
                                map { my $format= sprintf("%%-%ds", $width{$_});
                                      sprintf($format, $row->{$_} ? $row->{$_} : ""); } @columns));
  }
  return $ret;
}

sub _print_vtable
{
  ### Argv should be `selectall_arrayref($sql, {Slice => {}})`
  my ($selectall_arrayref)= @_;

  if (!($selectall_arrayref) || !(@$selectall_arrayref))
  {
    ### Empty
    return "Empty\n";
  }

  my @columns= sort(keys(%{$selectall_arrayref->[0]}));

  ### Evaluate width of resultset.
  my $width= 0;
  foreach my $row (@$selectall_arrayref)
  {
    foreach my $column (@columns)
    {
      $width= length($column) if length($column) > $width;
    }
  }
  my $ret;
  my $format= sprintf("%%-%ds : %%s\n", $width);
 
  ### Print each line
  foreach my $row (@$selectall_arrayref)
  {
    $ret .= "*" x 40 . "\n";
    foreach my $column (@columns)
    {
      $ret .= sprintf($format, $column, $row->{$column} // "");
    }
  }
  return $ret;
}

sub support_version
{
  my ($self, $require_version)= @_;

  if ($self->mysqld_version >= $require_version)
  {
    return 1;
  }
  else
  {
    if (!($self->{_ignore_unsupport_version}))
    {
      my $caller= (caller 1)[3] || "";
      my ($caller_name)= $caller =~ /::([^:]+)$/;
      $caller_name ||= "";
      my $require_version_string= _sprintf("%d.%d.%d",
                                           int($require_version / 10000),
                                           int(($require_version % 10000) / 100),
                                           $require_version % 100);

      _carpf("Unsupported version %s for function %s (Need %s and later)",
             $self->valueof("version"), $caller_name, $require_version_string);
    }
    return 0;
  }
}


return 1;
