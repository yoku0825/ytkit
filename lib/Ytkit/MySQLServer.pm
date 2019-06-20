package Ytkit::MySQLServer;

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

use base "Ytkit";
use DBI;

### Timeout for i_s query.
use constant ALRM_TIME => 3;
use constant ALRM_MSG  => "SIGALRM";
use constant ABORT_I_S => "Querying information_schema is too dangerous for this instance. Aborting.";

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
    _warning  => undef,
    _do_not_query_i_s => 0,
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
      $self->error($@);
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
    $self->error("");
    $self->warning([]);
    return undef if $self->error;

    eval
    {
      $ret= $conn->do($sql, $opt, @argv);
    };

    if ($@)
    {
      $self->error(sprintf("%s (%s): %s", $sql, join(", ", @argv), $@));
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

sub select_ps_digest
{
  my ($self, $limit)= @_;
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
ORDER BY
  count_star DESC
EOS
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;
 
  return $self->query_arrayref($sql);
}

sub select_ps_table
{
  my ($self, $limit)= @_;
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

sub select_is_table_by_size
{
  my ($self, $limit)= @_;

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
ORDER BY
  data_length + index_length DESC
EOS
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;

  return $self->query_arrayref($sql);
}

sub select_is_metrics
{
  my ($self)= @_;
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
        $self->error(ABORT_I_S);
        $self->croakf(ABORT_I_S);
      }
      $i_s_query= 1;
      
      ### Set timeout
      alarm(ALRM_TIME);
    } ### Not i_s query doesn't set alarm.

    $self->error("");
    $self->warning([]);
    my $conn= $self->conn;
    return undef if $self->error;

    eval
    {
      local $SIG{ALRM}= sub { $self->croakf(ALRM_MSG) };
      $self->{"_" . ${caller_name}}= $conn->selectall_arrayref($sql, {Slice => {}}, @argv);
    };

    ### Disable alarm.
    alarm(0);
 
    if ($@)
    {
      if ($i_s_query)
      {
        ### When got timeout for i_s query, abort and should be handled by upper-layer.
        $self->{_do_not_query_i_s}= 1;

      }

      $self->error(sprintf("%s (%s): %s", $sql, join(", ", @argv), $@));
      $self->croakf("Error occurs during query $sql; $@");
    }

    $self->check_warnings;
  }
  return $self->{"_" . ${caller_name}};
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
      $self->croakf("Querying information_schema is too dangerous for this instance. Aborting.")
        if $self->{_do_not_query_i_s};
      $i_s_query= 1;
      
      ### Set timeout
      alarm(ALRM_TIME);
    } ### Not i_s query doesn't set alarm.

    $self->error("");
    $self->warning("");
    my $conn= $self->conn;
    return undef if $self->error;

    eval
    {
      local $SIG{ALRM}= sub { $self->croakf(ALRM_MSG) };
      $self->{"_" . ${caller_name}}= $conn->selectall_hashref($sql, [$key], @argv);
    };

    if ($@)
    {
      if ($i_s_query)
      {
        ### When got timeout for i_s query, abort and should be handled by upper-layer.
        $self->{_do_not_query_i_s}= 1;

        ### Disable alarm.
        alarm(0);
      }

      $self->error(sprintf("%s (%s): %s", $sql, join(", ", @argv), $@));
      $self->croakf("Error occurs during query %s; %s", $sql, $@);
    }

    $self->check_warnings;
  }
  return $self->{"_" . ${caller_name}};
}

sub check_warnings
{
  my ($self)= @_;

  my $warn;
  eval
  {
    $warn= $self->conn->selectall_arrayref("SHOW WARNINGS");
  };
  $self->warning($warn) if $warn;
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
  return $self->exec_sql("SET SESSION information_schema_stats_expiry = 0");
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
      $self->conn->disconnect;
    };
    delete($self->{_conn});
    $self->conn;
  }
}

return 1;
