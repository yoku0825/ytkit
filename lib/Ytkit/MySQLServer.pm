package Ytkit::MySQLServer;

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

use DBI;

sub new
{
  my ($class, $opt)= @_;

  my $dsn= "dbi:mysql:";
  $dsn  .= sprintf(";host=%s", $opt->{host}) if $opt->{host};
  $dsn  .= sprintf(";port=%d", $opt->{port}) if $opt->{port};
  $dsn  .= sprintf(";mysql_socket=%s", $opt->{socket}) if $opt->{socket};

  my $self=
  {
    _hostname => undef,
    _version  => undef,
    timeout   => $opt->{timeout},
  };
  bless $self => $class;

  $self->{conn}= connect_to_mysql($dsn, $opt->{user}, $opt->{password}, $self->{timeout});
  return $self;
}

sub connect_to_mysql
{
  my ($dsn, $user, $password, $timeout)= @_;
  $timeout ||= 10;

  my $conn= DBI->connect($dsn, $user, $password,
                         {mysql_enable_utf8     => 1,
                          mysql_connect_timeout => $timeout,
                          mysql_write_timeout   => $timeout, 
                          mysql_read_timeout    => $timeout,
                          RaiseError            => 1, 
                          PrintError            => 0,
                         });
  return $conn;
}


sub exec_sql
{
  my ($self, $sql, $opt, @ARGV)= @_;

  my $ret;
  eval
  {
    $ret= $self->{conn}->do($sql, $opt, @ARGV);
  };
  return $ret;
}

sub hostname
{
  my ($self)= @_;
  return "Can't fetch hostname" if !($self->{conn});
  $self->{_hostname} ||= $self->show_variables->{hostname}->{Value};
  return $self->{_hostname};
}

sub port
{
  my ($self)= @_;
  return undef if !($self->{conn});
  $self->{_port} ||= $self->show_variables->{port}->{Value};
  return $self->{_port};
}

sub mysqld_version
{
  my ($self)= @_;
  return "Can't fetch version" if !($self->{conn});

  if (!($self->{_version}))
  {
    my $version_raw= $self->show_variables->{version}->{Value};
    $version_raw =~ /^(\d+)\.(\d+)\.(\d+)/;
    $self->{_version}= sprintf("%d%02d%02d", $1, $2, $3);
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
  my $sql= "SELECT schema_name, digest, count_star, sum_timer_wait, NOW() AS now " .
           "FROM performance_schema.events_statements_summary_by_digest " .
           "ORDER BY count_star DESC";
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;
 
  return $self->query_arrayref($sql);
}

sub select_ps_table
{
  my ($self, $limit)= @_;
  my $sql= << "EOS";
SELECT
  object_schema, 
  object_name,
  count_read,
  sum_timer_read,
  count_write,
  sum_timer_write,
  NOW() AS now
FROM 
  performance_schema.table_io_waits_summary_by_table
WHERE
  count_star > 0
ORDER BY
  count_star DESC
EOS
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;
  $sql =~ s/\n/ /g;
 
  return $self->query_arrayref($sql);
}

sub select_is_table_by_size
{
  my ($self, $limit)= @_;
  my $sql= << "EOS";
SELECT
  table_schema AS table_schema,
  table_name AS table_name,
  table_rows AS table_rows,
  data_length AS data_length,
  index_length AS index_length,
  data_free AS data_free,
  NOW() AS now
FROM
  information_schema.tables
ORDER BY
  data_length + index_length DESC
EOS
  $sql .= sprintf(" LIMIT %d", $limit) if $limit;
  $sql =~ s/\n/ /g;

  return $self->query_arrayref($sql);
}

sub select_is_metrics
{
  my ($self)= @_;
  my $sql= "SELECT name AS name, " .
                  "count AS count, " .
                  "NOW() AS now " .
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
  my ($caller_name)= (caller 1)[3] =~ /::([^:]+)$/;

  if (!(defined($self->{"_" . ${caller_name}})))
  {
    return 0 if !($self->{conn});
    $self->{"_" . ${caller_name}}= $self->{conn}->selectall_arrayref($sql, {Slice => {}}, @argv);
  }
  return $self->{"_" . ${caller_name}};
}

sub query_hashref
{
  my ($self, $sql, $key, @argv)= @_;
  my ($caller_name)= (caller 1)[3] =~ /::([^:]+)$/;

  if (!(defined($self->{"_" . ${caller_name}})))
  {
    return 0 if !($self->{conn});
    $self->{"_" . ${caller_name}}= $self->{conn}->selectall_hashref($sql, [$key], @argv);
  }
  return $self->{"_" . ${caller_name}};
}

sub clear_cache
{
  my ($self)= @_;

  foreach (keys(%$self))
  {
    $self->{$_}= undef if $_ =~ /^_/;
  }
}

sub quote
{
  my ($self, $str)= @_;

  my $ret;
  eval
  {
    $ret= $self->{conn}->quote($str);
  };

  if ($@)
  {
    ### Return immitate-quote, if $self->{conn} is not connected.
    $str =~ s/\'/\\'/g;
    return qq{'$str'};
  }
  else
  {
    return $ret;
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
  return "Can't fetch gtid_executed" if !($self->{conn});

  if (!($self->{_gtid}))
  {
    $self->{_gtid}= $self->show_master_status->[0]->{Executed_Gtid_Set} // "empty";
  }
  return $self->{_gtid};
}


return 1;

