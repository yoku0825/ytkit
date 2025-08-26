package Ytkit::ReplTopology;

########################################################################
# Copyright (C) 2022, 2025  yoku0825
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
use JSON qw{ to_json };

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
        my $add_source_ipaddr= _search_candidate_source_ipaddr_by_instance($replica);
 
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

  if ($self->{output} eq "text")
  {
    return $self->print_topology_text;
  }
  elsif ($self->{output} eq "json")
  {
    return $self->print_topology_json;
  }
  elsif ($self->{output} eq "dot")
  {
    return $self->print_topology_dot;
  }
  elsif ($self->{output} eq "member")
  {
    return $self->print_topology_member;
  }
  else
  {
    ### Something wrong, print as --output=text
    return $self->print_topology_text;
  }
}

sub print_topology_text
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

sub print_topology_json
{
  my ($self)= @_;
  my $buff;

  foreach (@{$self->{_topology}})
  {
    while (my ($source, $replica)= each(%$_))
    {
      if (!(defined($buff->{$source})))
      {
        $buff->{$source}= { source => [], replica => [$replica] };
      }
      else
      {
        $buff->{$source}->{replica}= uniq_push_arrayref($buff->{$source}->{replica}, $replica);
      }

      if (!(defined($buff->{$replica})))
      {
        $buff->{$replica}= { source => [$source], replica => [] };
      }
      else
      {
        $buff->{$replica}->{source}= uniq_push_arrayref($buff->{$replica}->{source}, $source);
      }
    }
  }
  return to_json($buff);
}

sub print_topology_dot
{
  my ($self)= @_;
  my @buff;

  foreach (@{$self->{_topology}})
  {
    while (my ($source, $replica)= each(%$_))
    {
      push(@buff, sprintf(q|  "%s" -> "%s"|, $source, $replica));
    }
  }
  @buff= sort(@buff);
  unshift(@buff, "digraph graph_name {");
  push(@buff, "}\n");
  return join("\n", @buff);
}

sub print_topology_member
{
  my ($self)= @_;
  my $buff;

  foreach (@{$self->{_topology}})
  {
    while (my ($source, $replica)= each(%$_))
    {
      $buff= uniq_push_arrayref($buff, join(" ", split_host_port($source)));
      $buff= uniq_push_arrayref($buff, join(" ", split_host_port($replica)));
    }
  }
  return join("\n", sort(@$buff)) . "\n";
}

sub search_candidate_ipaddr
{
  my ($self)= @_;
  my $self_host= $self->instance->hostname;
  my $replica= _search_candidate_replica_ipaddr_by_instance($self->instance);
  my $source= _search_candidate_source_ipaddr_by_instance($self->instance);
  $self->{_candidate_ipaddr}= uniq_push_arrayref($self->{_candidate_ipaddr}, $self_host, @$replica, @$source);
  _debugf("candidate_ippaddr: %s", $self->{_candidate_ipaddr});
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
  _debugf("detected_candidate_replica: %s", \@buff);
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
  _debugf("detected_candidate_source %s", \@buff);
  return \@buff;
}
 

sub search_candidate_port
{
  my ($self)= @_;
  my $self_port= $self->instance->port;
  my $replica= _search_candidate_replica_port_by_instance($self->instance);
  my $source = _search_candidate_source_port_by_instance($self->instance);
  $self->{_candidate_port}= uniq_push_arrayref($self->{_candidate_port}, $self_port, @$replica, @$source);
  _debugf("Candidate_port is now %s", $self->{_candidate_port});
  return 1;
}

sub _search_candidate_replica_port_by_instance
{
  my ($instance)= @_;

  my $ret;
  eval
  {
    $ret = $instance->show_slave_hosts;
  };

  if ($@)
  {
    ### Lack of privilege, but maybe it can be salvage via SHOW PROCESSLIST, should not abort.
    _carpf("SHOW SLAVE STATUS failed. But maybe SHOW PROCESSLIST can catch slaves");
    return [];
  }

  my @buff;
  foreach my $row (@$ret)
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
    output   => { alias => ["output", "o"],
                  isa   => ["text", "json", "dot", "member"],
                  default => "text",
                  text  => "Output type (member is for command-line tool)" },
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
