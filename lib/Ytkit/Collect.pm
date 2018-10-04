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
use base "Ytkit";
use Carp qw{carp croak};

use Ytkit::MySQLServer;

my $synopsis= q{ $ yt-collect --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password --output=sql } .
              q{--iteration=60 --interval=60  ### collect data each 1 minutes during 1 hour and exits };
my $script= sprintf("%s - Collect data from performance_schema and information_schema", $0);
my $description= << "EOS";
yt-collect gets some statistics from p_s and prints as tsv/csv/sql/json.
EOS
my $allow_extra_arvg= 0;
my $config= _config();


sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}} };
  bless $self => $class;
  $self->handle_help;

  eval
  {
    $self->{instance}= Ytkit::MySQLServer->new($self->{_config}->{result});
  };

  if ($@)
  {
    ### die if can't connect to MySQL.
    croak("MySQL Connection failed. $@") if !($ENV{HARNESS_ACTIVE});
  }

  my @enable= grep { ref($self->{$_}) eq "HASH" && 
                     exists($self->{$_}->{enable}) && 
                     $self->{$_}->{enable} == 1 } keys(%$self);
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
    $self->{verbose}= 0;

    sleep($self->{interval});
  }
}

sub clear_cache
{
  my ($self)= @_;
  return $self->{instance}->clear_cache;
}

sub is_satisfied_requirement
{
  my ($self)= @_;
  return $self->{instance}->p_s_on;
}

sub print_query_latency
{
  my ($self)= @_;

  if (!($self->is_satisfied_requirement))
  {
    carp("--query_latency_enable=1 needs MySQL >= 5.6.8 and performance_schema = ON, " .
         "please check requirements are satisfied.") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  else
  {
    my $ps_digest= $self->{instance}->select_ps_digest($self->{query_latency}->{limit});
    return $self->print_low($ps_digest, $self->{query_latency}->{output_name});
  }
}

sub print_table_latency
{
  my ($self)= @_;

  if (!($self->is_satisfied_requirement))
  {
    carp("--table_latency_enable=1 needs MySQL >= 5.6.8 and performance_schema = ON, " .
         "please check requirements are satisfied.") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  else
  {
    my $ps_table= $self->{instance}->select_ps_table($self->{table_latency}->{limit});
    return $self->print_low($ps_table, $self->{table_latency}->{output_name});
  }
}

sub print_table_size
{
  my ($self)= @_;

  if ($self->{instance}->stats_on_metadata)
  {
    carp("--table-size-enable was falling-back to 0 ".
         "because innodb_stats_on_metadata = ON could cause performance problem " .
         "when accessing information_schema.tables and etc.") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  my $is_table= $self->{instance}->select_is_table_by_size($self->{table_size}->{limit});
  return $self->print_low($is_table, $self->{table_size}->{output_name});
}

sub print_innodb_metrics
{
  my ($self)= @_;

  if ($self->{instance}->mysqld_version < 50608)
  {
    carp("--innodb_metrics_enable=1 needs MySQL >= 5.6.8, " .
         "please check requirements are satisfied.") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
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

    if ($self->{verbose})
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
                        join($seperator, map { sprintf(q|"%s"|,
                                                       defined($row->{$_}) ? 
                                                         escape_backslash($row->{$_}) :
                                                         "")
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
                        join(",", map { sprintf(q|"%s":"%s"|,
                                                $_, defined($row->{$_}) ? 
                                                      escape_backslash($row->{$_}) :
                                                      "")
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
                        join(", ", map { defined($row->{$_}) ? 
                                           $self->{instance}->quote($row->{$_}) :
                                           "''"
                                       } @column));
      push(@buff, $info);
    }
    return sprintf("INSERT INTO %s (%s) VALUES %s;\n",
                   $table, join(", ", ("host", "port", @column)),
                   join(", ", @buff));
  }
  else
  {
    ### Unknown output-type
    croak(sprintf("Unknown --output = %s", $self->{output}));
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

sub _config
{
  my $output_name_text= "Specify name of table(--output=sql) or " .
                        "name of top-element(--output=json)";

  my $yt_collect_option=
  {
    table_size =>
    {
      enable => { default => 1,
                  isa => [0, 1],
                  text => "Querying information_schema.tables for collecting table_size." },
      limit => { default => 30,
                 text => qq{Using "ORDER BY index_length + data_length DESC LIMIT .."} .
                         qq{for collecting table_size.} },
      output_name => { default => "table_status_info",
                       text => $output_name_text },
    },
    table_latency =>
    {
      enable => { default => 1,
                  isa => [0, 1],
                  text => "Querying performance_schema.table_io_waits_summary_by_table for collecting latency." },
      limit => { default => 30,
                 text => qq{Using "ORDER BY count_star DESC LIMIT .."} .
                         qq{for collecting latency.} },
      output_name => { default => "ps_table_info",
                       text => $output_name_text },
    },
    innodb_metrics =>
    {
      enable => { default => 1,
                  isa => [0, 1],
                  text => "Querying information_schema.innodb_metrics." },
      output_name => { default => "is_innodb_metrics",
                       text => $output_name_text },
    },
    query_latency =>
    {
      enable      => { default => 1,
                       isa => [0, 1],
                       text => "Querying performance_schema.vents_statements_summary_by_digest for collecting latency." },
      limit       => { default => 30,
                       text => qq{Using "ORDER BY count_star DESC LIMIT .."} .
                               qq{for collecting latency.} },
      output_name => { default => "ps_digest_info",
                       text    => $output_name_text },
    },
    show_status =>
    {
      enable      => { default => 1,
                       isa => [0, 1],
                       text => qq{Querying "SHOW GLOBAL STATUS"} },
      output_name => { default => "status_info",
                       text => $output_name_text },
    },
    show_grants =>
    {
      enable      => { default => 0,
                       isa => [0, 1],
                       text => qq{Querying "SHOW GRANTS" } .
                               qq{for each account for collecting grant_string.} },
      output_name => { default => "grant_info",
                       text => $output_name_text }
    },
    show_slave =>
    {
      enable      => { default => 0,
                       isa => [0, 1],
                       text => qq{Querying "SHOW SLAVE STATUS" for collecting master_host and master_port.} },
      output_name => { default => "slave_info",
                       text => $output_name_text }
    },
    show_variables =>
    {
      enable => { default => 0,
                  isa => [0, 1],
                  text => qq{Querying "SHOW GLOBAL VARIABLES"} },
      output_name => { default => "variable_info",
                       text => $output_name_text }
    },
    interval       => { alias   => ["interval", "i", "sleep"],
                        default => 600,
                        text => "Sleep seconds during each collecting iterations." },
    iteration      => { alias   => ["iteration", "count", "c"],
                        default => 1,
                        text => "How many times does script collect information." },
    output         => { alias   => ["output", "o"],
                        default => "tsv",
                        isa     => [qw{tsv csv json sql}],
                        text => "Results output style." },
    record_path    => { alias   => ["record-path", "r"],
                        text => "When specified, each collection-methods write into the directory.\n" .
                                "  (When not set, write into STDOUT)" },
  };
  my $config= Ytkit::Config->new({ %$yt_collect_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
}

return 1;
