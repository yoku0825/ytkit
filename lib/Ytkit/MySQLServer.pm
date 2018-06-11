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
    _hostname             => undef,
    _version              => undef,
    _show_slave_status    => undef,
    _show_slave_hosts     => undef,
    _show_processlist     => undef,
    _show_status          => undef,
    _show_variables       => undef,
    _select_autoinc_usage => undef,
    _show_master_logs     => undef,
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

sub query_arrayref
{
  my ($self, $sql)= @_;
  my ($caller_name)= (caller 1)[3] =~ /::([^:]+)$/;

  if (!(defined($self->{"_" . ${caller_name}})))
  {
    return 0 if !($self->{conn});
    $self->{"_" . ${caller_name}}= $self->{conn}->selectall_arrayref($sql, {Slice => {}});
  }
  return $self->{"_" . ${caller_name}};
}

sub query_hashref
{
  my ($self, $sql, $key)= @_;
  my ($caller_name)= (caller 1)[3] =~ /::([^:]+)$/;

  if (!(defined($self->{"_" . ${caller_name}})))
  {
    return 0 if !($self->{conn});
    $self->{"_" . ${caller_name}}= $self->{conn}->selectall_hashref($sql, [$key]);
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

return 1;

