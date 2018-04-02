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
use v5.10;
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
    _hostname        => undef,
    timeout          => $opt->{timeout} ? $opt->{timeout} : 10,
  };
  bless $self => $class;

  $self->{conn}= connect_to_mysql($dsn, $opt->{user}, $opt->{password}, $self->{timeout});
  return $self;
}

sub connect_to_mysql
{
  my ($dsn, $user, $password, $timeout)= @_;
  $timeout ||= 10;

  my $conn;
  eval
  {
    $conn= DBI->connect($dsn, $user, $password,
                        {mysql_enable_utf8     => 1,
                         mysql_connect_timeout => $timeout,
                         mysql_write_timeout   => $timeout, 
                         mysql_read_timeout    => $timeout,
                         RaiseError            => 1, 
                         PrintError            => 0,
                        });
  };

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

sub show_slave_status
{
  my ($self)= @_;
  return 0 if !($self->{conn});

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_show_slave_status})))
  {
    $self->{_show_slave_status}= $self->{conn}->selectall_arrayref("SHOW SLAVE STATUS", {Slice => {}});
  }
  return $self->{_show_slave_status};
}

sub show_slave_hosts
{
  my ($self)= @_;
  return 0 if !($self->{conn});

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_show_slave_hosts})))
  {
    $self->{_show_slave_hosts}= $self->{conn}->selectall_arrayref("SHOW SLAVE HOSTS", {Slice => {}});
  }
  return $self->{_show_slave_hosts};
}

sub show_processlist
{
  my ($self)= @_;
  return 0 if !($self->{conn});

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_show_processlist})))
  {
    $self->{_show_processlist}= $self->{conn}->selectall_arrayref("SHOW FULL PROCESSLIST", {Slice => {}});
  }
  return $self->{_show_processlist};
}

sub show_status
{
  my ($self)= @_;
  return 0 if !($self->{conn});

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_show_status})))
  {
    $self->{_show_status}= $self->{conn}->selectall_hashref("SHOW GLOBAL STATUS", ["Variable_name"]);
  }
  return $self->{_show_status};
}

sub show_variables
{
  my ($self)= @_;
  return 0 if !($self->{conn});

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_show_variables})))
  {
    $self->{_show_variables}= $self->{conn}->selectall_hashref("SHOW GLOBAL VARIABLES", ["Variable_name"]);
    $self->{hostname}= $self->{_show_variables}->{hostname}->{Value};
  }
  return $self->{_show_variables};
}

sub select_autoinc_usage
{
  my ($self)= @_;
  return 0 if !($self->{conn});

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_select_autoinc_usage})))
  {
    my $sql= "SELECT table_schema, table_name, column_name, auto_increment, column_type " .
             "FROM information_schema.tables JOIN information_schema.columns USING(table_schema, table_name) " .
             "WHERE auto_increment IS NOT NULL AND extra = 'auto_increment'";
    $self->{_select_autoinc_usage}= $self->{conn}->selectall_arrayref($sql, {Slice => {}});
  }
  return $self->{_select_autoinc_usage};
}

sub show_master_logs
{
  my ($self)= @_;

  ### if use "||=", can't decide result is blank or never execute the query.
  if (!(defined($self->{_show_master_logs})))
  {
    my $sql= "SHOW MASTER LOGS";
    $self->{_show_master_logs}= $self->{conn}->selectall_arrayref($sql, {Slice => {}});
  }
  return $self->{_show_master_logs};
}

return 1;

