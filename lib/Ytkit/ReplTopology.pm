package Ytkit::ReplTopology;

########################################################################
# Copyright (C) 2022  yoku0825
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

use Ytkit::IO;
use Ytkit::MySQLServer;

my $synopsis= q{ $ yt-repl-topology --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password};
my $script= sprintf("%s - Display Replication Topology by dot syntax", $0);
my $description= << "EOS";
yt-repl-topology displays replication topology around specified host.
--user needs Repl_client_priv and Process_priv for each host.
EOS
my $allow_extra_arvg= 0;


sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self=
  {
    _config             => $config,
    _topology           => [],
    _candidate_port     => [$config->{result}->{port}],
    _candidate_ipaddr   => [$config->{result}->{host}],
    _registered_node    => {},
    %{$config->{result}},
  };
  bless $self => $class;
  $self->handle_help;

  return $self;
}

sub run
{
  my ($self)= @_;

  $self->search_candidate_port;
  $self->search_candidate_ipaddr;

  while ()
  {
    my $count= 0;
    foreach my $ipaddr (@{$self->{_candidate_ipaddr}})
    {
      foreach my $port (@{$self->{_candidate_port}})
      {
        my $instance_id= sprintf("%s:%d", $ipaddr, $port);
        next if $self->{_registered_node}->{$instance_id};
        $self->{_registered_node}->{$instance_id}= 1 if $ipaddr =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
  
        my $replica= Ytkit::MySQLServer->new({ host => $ipaddr, port => $port,
                                               user => $self->{user}, password => $self->{password} });
        $replica->conn;

        ### Override instance_id by hostname
        $instance_id= sprintf("%s:%d", $replica->hostname, $port);
        next if $self->{_registered_node}->{$instance_id};
        $self->{_registered_node}->{$instance_id}= 1;
  
        next if $replica->error;
  
        foreach my $one_master (@{$replica->show_slave_status})
        {
          my $source= Ytkit::MySQLServer->new({ host => $one_master->{Master_Host}, port => $one_master->{Master_Port},
                                                user => $self->{user}, password => $self->{password} });
          my $source_id= sprintf("%s:%d", $source->hostname, $one_master->{Master_Port});
          push(@{$self->{_topology}}, { $source_id => $instance_id });
          $count++;
        }
        my $add_replica_ipaddr= _search_candidate_replica_ipaddr_by_instance($replica);
        my $add_source_ipaddr= _search_candidate_replica_ipaddr_by_instance($replica);
 
        if (@$add_replica_ipaddr || $add_source_ipaddr)
        {
          $self->{_candidate_ipaddr}= uniq_push_arrayref($self->{_candidate_ipaddr}, @$add_replica_ipaddr, @$add_source_ipaddr);
          $count++;
        }

        my $add_replica_port= _search_candidate_replica_port_by_instance($replica);
        my $add_source_port= _search_candidate_replica_port_by_instance($replica);
        if (@$add_replica_port || $add_source_port)
        {
          $self->{_candidate_port}= uniq_push_arrayref($self->{_candidate_port}, @$add_replica_port, @$add_source_port);
          $count++;
        }
      }
    }

    ### Nothing any new registered.
    last if $count == 0;
  }
  return 1;
}

sub topology
{
  my ($self)= @_;
  my @buff;

  foreach (@{$self->{_topology}})
  {
    while (my ($source, $replica)= each(%$_))
    {
      push(@buff, sprintf("%s => %s\n", $source, $replica));
    }
  }
  return sort(@buff);
}

sub search_candidate_ipaddr
{
  my ($self)= @_;
  my $replica= _search_candidate_replica_ipaddr_by_instance($self->instance);
  my $source= _search_candidate_source_ipaddr_by_instance($self->instance);
  $self->{_candidate_ipaddr}= uniq_push_arrayref($self->{_candidate_ipaddr}, @$replica, @$source);
  return 1;
}

sub _search_candidate_replica_ipaddr_by_instance
{
  my ($instance)= @_;

  return [] unless $instance->show_processlist;

  my @buff;
  foreach (@{$instance->show_processlist})
  {
    if ($_->{Command} =~ /^Binlog\sDump/)
    {
      my ($ipaddr, $port)= split_host_port($_->{Host});
      push(@buff, $ipaddr);    ### port is unused.
    }
  }
  return \@buff; 
}

sub _search_candidate_source_ipaddr_by_instance
{
  my ($instance)= @_;
  return [] unless $instance->show_slave_status;

  my @buff;
  foreach my $one_master (@{$instance->show_slave_status})
  {
    push(@buff, $one_master->{Master_Host});
  }
  return \@buff;
}
 

sub search_candidate_port
{
  my ($self)= @_;
  my $replica= _search_candidate_replica_port_by_instance($self->instance);
  my $source = _search_candidate_source_port_by_instance($self->instance);
  $self->{_candidate_port}= uniq_push_arrayref($self->{_candidate_port}, @$replica, @$source);
  return 1;
}

sub _search_candidate_replica_port_by_instance
{
  my ($instance)= @_;
  return [] unless $instance->show_slave_hosts;

  my @buff;
  foreach my $row (@{$instance->show_slave_hosts})
  {
    push(@buff, $row->{Port});
  }
  return \@buff;
}

sub _search_candidate_source_port_by_instance
{
  my ($instance)= @_;
  return [] unless $instance->show_slave_status;

  my @buff;
  foreach my $one_master (@{$instance->show_slave_status})
  {
    push(@buff, $one_master->{Master_Port});
  }
  return \@buff;
}
 

sub _config
{
  my $program_option=
  {
  };

  my $config= Ytkit::Config->new({ %$program_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
}

return 1;
