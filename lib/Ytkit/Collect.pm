package Ytkit::Collect;

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
use POSIX;
use IO::File;

use Ytkit::Config;
use Ytkit::MySQLServer;

my $default_option=
{
  table_size     => { enable      => { default => 1 },
                      limit       => { default => 30 },
                      output_name => { default => "table_status_info" } },
  table_latency  => { enable      => { default => 1 },
                      limit       => { default => 30 },
                      output_name => { default => "ps_table_info" } },
  innodb_metrics => { enable      => { default => 1 },
                      output_name => { default => "is_innodb_metrics" } },
  query_latency  => { enable      => { default => 1 },
                      limit       => { default => 30 },
                      output_name => { default => "ps_digest_info" } },
  show_status    => { enable      => { default => 1 },
                      output_name => { default => "status_info" } },
  show_grants    => { enable      => { default => 0 },
                      output_name => { default => "grant_info" } },
  show_slave     => { enable      => { default => 0 },
                      output_name => { default => "slave_info" } },
  show_variables => { enable      => { default => 0 },
                      output_name => { default => "variable_info" } },
  interval       => { alias => ["interval", "i", "sleep"], default => 600 },
  iteration      => { alias => ["iteration", "count", "c"], default => 1 },
  output         => { alias => ["output", "o"], default => "tsv", isa => [qw{tsv csv json sql}] },
  record_path    => { alias => ["record-path", "r"], default => undef },
  no_header      => { alias => ["no-header", "n"], default => 0, isa => "noarg" },
  config_group   => { alias => ["config-group"], default => "yt-collect" },
};
$default_option= { %$default_option, %$Ytkit::Config::CONNECT_OPTION, %$Ytkit::Config::COMMON_OPTION };

sub new
{
  my ($class, @orig_argv)= @_;
  my ($opt, @argv)= options($default_option, @orig_argv);
  return -255 if $opt->{help};
  return -254 if $opt->{version};
  load_config($opt, $opt->{config_file}, $opt->{config_group}) if $opt->{config_file};

  my $self=
  {
    instance       => {}, ### Reserve for Ytkit::MySQLServer
    output         => $opt->{output},
    interval       => $opt->{interval},
    iteration      => $opt->{iteration},
    record_path    => $opt->{record_path},
    table_size     => { enable      => $opt->{table_size_enable},
                        limit       => $opt->{table_size_limit},
                        output_name => $opt->{table_size_output_name} },
    table_latency  => { enable      => $opt->{table_latency_enable},
                        limit       => $opt->{table_latency_limit},
                        output_name => $opt->{table_latency_output_name} },
    innodb_metrics => { enable      => $opt->{innodb_metrics_enable},
                        output_name => $opt->{innodb_metrics_output_name} },
    query_latency  => { enable      => $opt->{query_latency_enable},
                        limit       => $opt->{query_latency_limit},
                        output_name => $opt->{query_latency_output_name} },
    show_status    => { enable      => $opt->{show_status_enable},
                        output_name => $opt->{show_status_output_name} },
    show_grants    => { enable      => $opt->{show_grants_enable},
                        output_name => $opt->{show_grants_output_name} },
    show_slave     => { enable      => $opt->{show_slave_enable},
                        output_name => $opt->{show_slave_output_name} },
    show_variables => { enable      => $opt->{show_variables_enable},
                        output_name => $opt->{show_variables_output_name} },
    print_header   => !($opt->{no_header}),
    enable_list    => [],
  };
  bless $self => $class;
  eval
  {
    $self->{instance}= Ytkit::MySQLServer->new($opt);
  };

  if ($@)
  {
    ### die if can't connect to MySQL.
    die("MySQL Connection failed. $@");
  }

  my @enable= grep { ref($self->{$_}) eq "HASH" && exists($self->{$_}->{enable}) && $self->{$_}->{enable} == 1 } keys(%$self);
  $self->{enable_list}= \@enable;
  $self->make_handle;

  return $self;
}

sub make_handle
{
  my ($self)= @_;

  foreach my $collection (@{$self->{enable_list}})
  {
    if ($self->{record_path})
    {
      my $filepath= sprintf("%s/%s_%s.%s", $self->{record_path}, $collection,
                                           strftime("%Y%m%d%H%M%S", localtime),
                                           $self->{output});
      $self->{$collection}->{fh}= IO::File->new($filepath, "a");
    }
    else
    {
      ### If --record_path isn't specified, set STDOUT for output channel.
      $self->{$collection}->{fh}= IO::Handle->new_from_fd(1, "w");
    }
  }
}

sub collect
{
  my ($self)= @_;

  while ()
  {
    ### Print to output-fd, each collection
    foreach (@{$self->{enable_list}})
    {
      my $method= sprintf("print_%s", $_);
      $self->{$_}->{fh}->print($self->$method);
      $self->{$_}->{fh}->flush;
    }

    ### Break loop when all-iterations have been finished.
    last if --$self->{iteration} <= 0;

    ### Clear cache each time.
    $self->clear_cache;

    ### Don't print header again.
    $self->{print_header}= 0;

    sleep($self->{interval});
  }
}

sub is_satisfied_requirement
{
  my ($self)= @_;
  return 1 if ($self->{instance}->mysqld_version >= 50608 && 
               $self->{instance}->show_variables->{performance_schema}->{Value} eq "ON");
  return 0;
}

sub clear_cache
{
  my ($self)= @_;
  return $self->{instance}->clear_cache;
}

sub print_query_latency
{
  my ($self)= @_;
  die("--query_latency_enable=1 needs MySQL >= 5.6.8 and performance_schema = ON, please check requirements are satisfied.") 
    if !($self->is_satisfied_requirement);
  my $ps_digest= $self->{instance}->select_ps_digest($self->{query_latency}->{limit});
  return $self->print_low($ps_digest, $self->{query_latency}->{output_name});
}

sub print_table_latency
{
  my ($self)= @_;
  die("--table_latency_enable=1 needs MySQL >= 5.6.8 and performance_schema = ON, please check requirements are satisfied.") 
    if !($self->is_satisfied_requirement);
  my $ps_table= $self->{instance}->select_ps_table($self->{table_latency}->{limit});
  return $self->print_low($ps_table, $self->{table_latency}->{output_name});
}

sub print_table_size
{
  my ($self)= @_;
  my $is_table= $self->{instance}->select_is_table_by_size($self->{table_size}->{limit});
  return $self->print_low($is_table, $self->{table_size}->{output_name});
}

sub print_innodb_metrics
{
  my ($self)= @_;
  die("--innodb_metrics_enable=1 needs MySQL >= 5.6.8, please check requirements are satisfied.") 
    if $self->{instance}->mysqld_version < 50608;
  my $is_metrics= $self->{instance}->select_is_metrics;
  return $self->print_low($is_metrics, $self->{innodb_metrics}->{output_name});
}

sub print_show_status
{
  my ($self)= @_;

  ### Ytkit::MySQLServer::show_status returns hashref(not arrayref),
  ### should be fixed to arrayref.
  my $global_status= $self->{instance}->show_status;
  my @rs= map { +{ variable_name => $global_status->{$_}->{Variable_name},
                   value => $global_status->{$_}->{Value},
                   now   => strftime("%Y-%m-%d %H:%M:%S", localtime) }
              } keys(%$global_status);
  return $self->print_low(\@rs, $self->{show_status}->{output_name});
}

sub print_show_variables
{
  my ($self)= @_;

  ### Ytkit::MySQLServer::show_variables returns hashref(not arrayref),
  ### should be fixed to arrayref.
  my $global_variables= $self->{instance}->show_variables;
  my @rs= map { +{ variable_name => $global_variables->{$_}->{Variable_name},
                   value => $global_variables->{$_}->{Value},
                   now   => strftime("%Y-%m-%d %H:%M:%S", localtime) }
              } keys(%$global_variables);
  return $self->print_low(\@rs, $self->{show_variables}->{output_name});
}

sub print_show_grants
{
  my ($self)= @_;
  my @rs;

  foreach my $user (@{$self->{instance}->select_user_list})
  {
    my @grants= map { $_->{grants} } @{$self->{instance}->show_grants($user->{user}, $user->{host})};
    push(@rs, +{ user_name => $user->{user}, user_host => $user->{host}, grants => join("; ", @grants) });
  }
  return $self->print_low(\@rs, $self->{show_grants}->{output_name});
}

sub print_show_slave
{
  my ($self)= @_;

  foreach my $channel (@{$self->{instance}->show_slave_status})
  {
    ### Ignore named-channel(for Multi-Source Replication)
    next if exists($channel->{Channel_name}) && $channel->{Channel_name} ne "";

    return $self->print_low([{ master_host => $channel->{Master_Host},
                               master_port => $channel->{Master_Port},
                               now         => strftime("%Y-%m-%d %H:%M:%S", localtime),
                            }], $self->{slave_status}->{output_name});
  }
}

sub print_low
{
  my ($self, $rs, $table)= @_;
  return 0 if !($rs->[0]);

  my @buff;
  my @column= sort(keys(%{$rs->[0]}));

  if ($self->{output} eq "tsv" || $self->{output} eq "csv")
  {
    my $seperator= $self->{output} eq "tsv" ? "\t" : ",";

    if ($self->{print_header})
    {
      ### Header
      push(@buff, join($seperator, map { qq|"$_"| } ("host", "port", @column)));
    }

    ### Body
    foreach my $row (@$rs)
    {
      ### Add host/port information
      my $info= sprintf(q|"%s"%s"%s"%s%s|,
                        $self->{instance}->hostname, $seperator,
                        $self->{instance}->port, $seperator,
                        join($seperator, map { sprintf(q|"%s"|, defined($row->{$_}) ? escape_backslash($row->{$_}) : "");
                                             } @column));
      push(@buff, $info);
    }

    return join("\n", @buff) . "\n";
  }
  elsif ($self->{output} eq "json")
  {
    return 0 if !($table);
    foreach my $row (@$rs)
    {
      ### Add host/port information
      my $info= sprintf(q|{"host":"%s","port":"%s",%s}|,
                        $self->{instance}->hostname,
                        $self->{instance}->port,
                        join(",", map { sprintf(q|"%s":"%s"|, $_, defined($row->{$_}) ? escape_backslash($row->{$_}) : "")
                                      } @column));
      push(@buff, $info);
    }
    return sprintf(q|{"%s":[%s]}|, $table, join(",", @buff)) . "\n";
  }
  elsif ($self->{output} eq "sql")
  {
    return 0 if !($table);
    foreach my $row (@$rs)
    {
      ### Add host/port information
      my $info= sprintf(q|('%s', '%s', %s)|,
                        $self->{instance}->hostname,
                        $self->{instance}->port,
                        join(", ", map { defined($row->{$_}) ?  $self->{instance}->quote($row->{$_}) : "''"
                                       } @column));
      push(@buff, $info);
    }
    return sprintf("INSERT INTO %s (%s) VALUES %s;", $table, join(", ", ("host", "port", @column)), join(", ", @buff)) . "\n";
  }
  else
  {
    ### Unknown output-type
    die(sprintf("Unknown --output = %s", $self->{output}));
  }
}

sub escape_backslash
{
  my ($str)= @_;

  $str =~ s/\\/\\\\/g;
  $str =~ s/\n/\\n/g;
  $str =~ s/\r/\\r/g;
  $str =~ s/\t/\\t/g;
  $str =~ s/\"/\\"/g;

  return $str;
}

return 1;
