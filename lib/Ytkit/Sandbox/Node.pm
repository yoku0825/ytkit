package Ytkit::Sandbox::Node;

########################################################################
# Copyright (C) 2025  yoku0825
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

use Ytkit::IO qw{ _infof _notef _carpf _croakf _debugf } ;
use Ytkit::MySQLServer;
use Time::Piece;

use constant SANDBOX_USER => "root";
use constant SANDBOX_PASSWORD => "";
use constant REPLICATION_USER => "replicator";
use constant REPLICATION_PASSWORD => "replicator";

sub new
{
  my ($class, $ipaddr)= @_;

  my $self=
  {
    ipaddr => $ipaddr,
    instance => Ytkit::MySQLServer->new({ host => $ipaddr, user => SANDBOX_USER, password => SANDBOX_PASSWORD }),
  };
  bless $self => $class;

  return $self;
}

sub setup_replication
{
  my ($self)= @_;

  my $instance= $self->{instance};
  $instance->exec_sql(sprintf("CREATE USER %s IDENTIFIED BY '%s'", REPLICATION_USER, REPLICATION_PASSWORD));
  $instance->exec_sql(sprintf("GRANT REPLICATION SLAVE ON *.* TO %s", REPLICATION_USER));

  my ($semisync_source, $semisync_replica);
  if ($instance->mysqld_version ge 80400)
  {
    $semisync_source= "INSTALL PLUGIN rpl_semi_sync_source SONAME 'semisync_source.so'";
    $semisync_replica= "INSTALL PLUGIN rpl_semi_sync_replica SONAME 'semisync_replica.so'";
  }
  else
  {
    $semisync_source= "INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so'";
    $semisync_replica= "INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so'";
  }
  $instance->exec_sql($semisync_source);
  $instance->exec_sql($semisync_replica);

  return 1;
}

sub setup_group_replication
{
  my ($self)= @_;

  my $instance= $self->{instance};
  _infof(sprintf("CREATE USER %s IDENTIFIED BY '%s'", REPLICATION_USER, REPLICATION_PASSWORD));
  $instance->exec_sql(sprintf("CREATE USER %s IDENTIFIED BY '%s'", REPLICATION_USER, REPLICATION_PASSWORD));
  _infof(sprintf("GRANT REPLICATION SLAVE, CONNECTION_ADMIN, BACKUP_ADMIN, GROUP_REPLICATION_STREAM, CLONE_ADMIN ON *.* TO %s", REPLICATION_USER));
  $instance->exec_sql(sprintf("GRANT REPLICATION SLAVE, CONNECTION_ADMIN, BACKUP_ADMIN, GROUP_REPLICATION_STREAM, CLONE_ADMIN ON *.* TO %s", REPLICATION_USER));
  _infof("INSTALL PLUGIN group_replication SONAME 'group_replication.so'");
  $instance->exec_sql("INSTALL PLUGIN group_replication SONAME 'group_replication.so'");
  _infof("INSTALL PLUGIN clone SONAME 'mysql_clone.so'");
  $instance->exec_sql("INSTALL PLUGIN clone SONAME 'mysql_clone.so'");
  _infof("SET PERSIST binlog_transaction_dependency_tracking = WRITESET");
  $instance->exec_sql("SET PERSIST binlog_transaction_dependency_tracking = WRITESET");
  _infof("SET PERSIST group_replication_group_name = '01234567-89ab-cdef-0123-456789abcdef'");
  $instance->exec_sql("SET PERSIST group_replication_group_name = '01234567-89ab-cdef-0123-456789abcdef'");
  _infof("SET PERSIST group_replication_recovery_get_public_key = ON");
  $instance->exec_sql("SET PERSIST group_replication_recovery_get_public_key = ON");
  _infof(sprintf("SET PERSIST group_replication_local_address = '%s:13306'", $self->{ipaddr}));
  $instance->exec_sql(sprintf("SET PERSIST group_replication_local_address = '%s:13306'", $self->{ipaddr}));

  my $replication_channel;
  if ($instance->mysqld_version ge 80400)
  {
    $replication_channel= sprintf("CHANGE REPLICATION SOURCE TO source_user = '%s', source_password = '%s' FOR CHANNEL 'group_replication_recovery'",
                                  REPLICATION_USER, REPLICATION_PASSWORD);
  }
  else
  {
    $replication_channel= sprintf("CHANGE MASTER TO master_user = '%s', master_password = '%s' FOR CHANNEL 'group_replication_recovery'",
                                  REPLICATION_USER, REPLICATION_PASSWORD);
  }
  _infof($replication_channel);
  $self->{instance}->exec_sql($replication_channel);
  return 1;
}

sub wait_until_mysqld_startup
{
  my ($self, $timeout)= @_;

  my $wait_start= localtime()->epoch;

  my $alive= 0;
  while ()
  {
    my $now= localtime()->epoch;
    last if $now - $wait_start > $timeout;

    eval
    {
      $self->{instance}->reconnect;

      if ($self->{instance}->show_status->{Uptime}->{Value} gt 3)
      {
        $alive= 1;
      }
      ### Clear cache
      delete $self->{instance}->{_show_status};
    };
    last if $alive;
  }
  return $alive;
}

sub clear_gtid
{
  my ($self)= @_;

  my $reset;
  if ($self->{instance}->mysqld_version ge 80400)
  {
    $reset= "RESET BINARY LOGS AND GTIDS";
  }
  else
  {
    $reset= "RESET MASTER";
  }
  _infof($reset);
  $self->{instance}->exec_sql_with_croak($reset);
}

sub follow_replication_source
{
  my ($self, $source_ipaddr, $gtid_mode)= @_;

  my ($change_replication, $start_replica);
  if ($self->{instance}->mysqld_version lt 50600)
  {
    ### 5.5, always non-gtid
    $change_replication= sprintf("CHANGE MASTER TO master_host = '%s', master_user = '%s', master_password = '%s'",
                                 $source_ipaddr, REPLICATION_USER, REPLICATION_PASSWORD);
    $start_replica= "START SLAVE";
  }
  elsif ($self->{instance}->mysqld_version lt 80000)
  {
    ### 5.6, 5.7
    $change_replication= sprintf("CHANGE MASTER TO master_host = '%s', master_user = '%s', master_password = '%s', master_auto_position = %d",
                                 $source_ipaddr, REPLICATION_USER, REPLICATION_PASSWORD, $gtid_mode);
    $start_replica= "START SLAVE";
  }
  elsif ($self->{instance}->mysqld_version lt 80400)
  {
    ### 8.0
    $change_replication= sprintf("CHANGE MASTER TO master_host = '%s', master_user = '%s', master_password = '%s', master_auto_position = %d, get_master_public_key = 1",
                                 $source_ipaddr, REPLICATION_USER, REPLICATION_PASSWORD, $gtid_mode);
    $start_replica= "START SLAVE";
  }
  else
  {
    ### 8.4 and later
    $change_replication= sprintf("CHANGE REPLICATION SOURCE TO source_host = '%s', source_user = '%s', source_password = '%s', source_auto_position = %d, get_source_public_key = 1",
                                 $source_ipaddr, REPLICATION_USER, REPLICATION_PASSWORD, $gtid_mode);
    $start_replica= "START REPLICA";
  }
  _infof("%s", $change_replication);
  $self->{instance}->exec_sql($change_replication);
  $self->{instance}->exec_sql($start_replica);
}


return 1;
