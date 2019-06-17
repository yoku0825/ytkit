package Ytkit::Collect;

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
use POSIX;
use IO::File;
use JSON qw{ to_json };
use base "Ytkit";
use Carp qw{ carp croak };

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
              %{$config->{result}}, };
  bless $self => $class;
  $self->handle_help;

  ### die if can't connect to MySQL.
  $self->test_connect;

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
    if ($self->{record_path} && $self->{output} ne "short")
    {
      my $filepath= sprintf("%s/%s_%s.%s", $self->{record_path}, $collection,
                                           strftime("%Y%m%d%H%M%S", localtime),
                                           $self->{output});
      $self->{$collection}->{fh}= IO::File->new($filepath, "a");
    }
    else
    {
      ### If --record_path isn't specified(or --output=short), set STDOUT for output channel.
      $self->{$collection}->{fh}= IO::Handle->new_from_fd(1, "w");
    }
  }
}

sub collect
{
  my ($self)= @_;
  my $infinity= $self->{iteration} == 0;

  while ($infinity || $self->{iteration}-- > 0)
  {
    $self->_collect_one_cycle;

    ### Don't print header again.
    $self->{verbose}= 0;

    sleep($self->{interval});
  }
}

sub _collect_one_cycle
{
  my ($self)= @_;

  ### Print to output-fd, each collection
  foreach (@{$self->{enable_list}})
  {
    my $method= sprintf("print_%s", $_);
    $self->{$_}->{fh}->print($self->$method);
    $self->{$_}->{fh}->flush;
  }

  ### Clear cache each time.
  $self->clear_cache;

  return 1;
}

sub is_satisfied_requirement
{
  my ($self)= @_;
  return $self->instance->p_s_on;
}

sub print_query_latency
{
  my ($self)= @_;
  my ($ret, $prev);

  ($ret, $prev)= $self->_calc_delta(["schema_name", "digest_text"],
                                    ["count_star", "sum_timer_wait"],
                                    $self->get_query_latency, $self->{_previous}->{query_latency});

  ### Calculate $ret or $prev is not there, override $prev by $current.
  $self->{_previous}->{query_latency}= $prev;

  return $self->print_low($ret, $self->{query_latency}->{output_name});
}

sub get_query_latency
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
    return $self->instance->select_ps_digest($self->{query_latency}->{limit});
  }
}

sub print_table_latency
{
  my ($self)= @_;
  my ($ret, $prev);

  ($ret, $prev)= $self->_calc_delta(["object_schema", "object_name"],
                                    ["count_read", "sum_timer_read", "count_write", "sum_timer_write"],
                                    $self->get_table_latency, $self->{_previous}->{table_latency});

  ### Calculate $ret or $prev is not there, override $prev by $current.
  $self->{_previous}->{table_latency}= $prev;

  return $self->print_low($ret, $self->{table_latency}->{output_name});
}

sub get_table_latency
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
    return $self->instance->select_ps_table($self->{table_latency}->{limit});
  }
}

sub print_table_size
{
  my ($self)= @_;
  return $self->print_low($self->get_table_size, $self->{table_size}->{output_name});
}

sub get_table_size
{
  my ($self)= @_;
  if ($self->{output} eq "short")
  {
    carp("--table-size-enable does not support --output=short") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }

  if ($self->instance->stats_on_metadata)
  {
    carp("--table-size-enable was falling-back to 0 ".
         "because innodb_stats_on_metadata = ON could cause performance problem " .
         "when accessing information_schema.tables and etc.") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }

  my $ret;
  eval
  {
    $ret= $self->instance->select_is_table_by_size($self->{table_size}->{limit});
  };
  if ($@)
  {
    carp("--table-size-enable was falling-back to 0 because $@") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  return $ret;
}

sub _calc_delta
{
  my ($self, $key_column, $val_column, $current, $prev)= @_;
  my @ret;

  ### Just returns as is if --delta=0
  return ($current, undef) if !($self->{delta});

  my $unit= $self->{delta_per_second} ? "/s" : sprintf("/%ds", $self->{interval});
  my $devide= $self->{delta_per_second} ? $self->{interval} : 1;
  my (%current_hash, $key_column_string);

  if (ref($key_column) eq "ARRAY")
  {
    foreach my $row (@$current)
    {
      $key_column_string= join(".", @$key_column);
      my $key= join(".", map { $row->{$_} // "NULL" } @$key_column);
      %current_hash= (%current_hash, $key => $row);
    }
    $key_column= $key_column_string;
  }
  else
  {
    %current_hash= map { $_->{$key_column} => $_ } @$current;
  }

  if ($prev)
  {
    my %prev_hash= %$prev;
    foreach (keys(%current_hash))
    {
      if (ref($val_column) eq "ARRAY")
      {
        my %buff= ($key_column => $_, last_update => $current_hash{$_}->{last_update});
        my $active= 0;
        foreach my $val_name (@$val_column)
        {
          ### Is numeric value?
          if ($current_hash{$_}->{$val_name} =~ /^\d+$/)
          {
            my $diff= $current_hash{$_}->{$val_name} - $prev_hash{$_}->{$val_name};
            $active= $active || $diff > 0;
            if ($active || $self->{idle_print})
            {
              %buff= (%buff, $val_name => $diff / $devide . $unit);
            }
          }
          else
          {
            $active= 1;
            %buff= (%buff, $val_name => $current_hash{$_}->{$val_name});
          }
        }
        push(@ret, \%buff) if $active || $self->{idle_print};
      }
      else
      {
        ### Is numeric value?
        if ($current_hash{$_}->{$val_column} =~ /^\d+$/)
        {
          ### Diff
          my $diff= $current_hash{$_}->{$val_column} - $prev_hash{$_}->{$val_column};
          push(@ret, { $key_column => $_,
                       $val_column => $diff / $devide . $unit,
                       last_update => $current_hash{$_}->{last_update} }) if ($self->{idle_print} || $diff > 0);
        }
        else
        {
          ### Non-numeric value, push value as is.
          push(@ret, { $key_column => $_,
                       $val_column => $current_hash{$_}->{$val_column},
                       last_update => $current_hash{$_}->{last_update} });
        }
      }
    }
  }

  ### Calculate $ret or $prev is not there, override $prev by $current.
  return (\@ret, \%current_hash);
}

sub print_innodb_metrics
{
  my ($self)= @_;
  my ($ret, $prev);

  ($ret, $prev)= $self->_calc_delta("name", "count", $self->get_innodb_metrics, $self->{_previous}->{innodb_metrics});

  ### Calculate $ret or $prev is not there, override $prev by $current.
  $self->{_previous}->{innodb_metrics}= $prev;

  return $self->print_low($ret, $self->{innodb_metrics}->{output_name});
}

sub get_innodb_metrics
{
  my ($self)= @_;

  if ($self->instance->mysqld_version < 50608)
  {
    carp("--innodb_metrics_enable=1 needs MySQL >= 5.6.8, " .
         "please check requirements are satisfied.") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  return $self->instance->select_is_metrics;
}

sub print_show_status
{
  my ($self)= @_;
  my ($ret, $prev);

  ($ret, $prev)= $self->_calc_delta("variable_name", "value", $self->get_show_status, $self->{_previous}->{show_status});

  ### Calculate $ret or $prev is not there, override $prev by $current.
  $self->{_previous}->{show_status}= $prev;

  return $self->print_low($ret, $self->{show_status}->{output_name});
}

sub get_show_status
{
  my ($self)= @_;

  ### Ytkit::MySQLServer::show_status returns hashref(not arrayref),
  ### should be fixed to arrayref.
  my $global_status= $self->instance->show_status;
  my @ret= map { +{ variable_name => $global_status->{$_}->{Variable_name},
                    value => $global_status->{$_}->{Value},
                    last_update => strftime("%Y-%m-%d %H:%M:%S", localtime) }
               } keys(%$global_status);
  return \@ret;
}

sub print_show_variables
{
  my ($self)= @_;
  return $self->print_low($self->get_show_variables, $self->{show_variables}->{output_name});
}

sub get_show_variables
{
  my ($self)= @_;

  ### Ytkit::MySQLServer::show_variables returns hashref(not arrayref),
  ### should be fixed to arrayref.
  my $global_variables= $self->instance->show_variables;
  my @ret= map { +{ variable_name => $global_variables->{$_}->{Variable_name},
                    value => $global_variables->{$_}->{Value},
                    last_update   => strftime("%Y-%m-%d %H:%M:%S", localtime) }
               } keys(%$global_variables);
  return \@ret;
}

sub print_show_grants
{
  my ($self)= @_;
  return $self->print_low($self->get_show_grants, $self->{show_grants}->{output_name});
}

sub get_show_grants
{
  my ($self)= @_;
  if ($self->{output} eq "short")
  {
    carp("--show-grants-enable does not support --output=short") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  my @ret;

  foreach my $user (@{$self->instance->select_user_list})
  {
    my @grants= map { $_->{grants} } @{$self->instance->show_grants($user->{user}, $user->{host})};
    push(@ret, +{ user_name => $user->{user}, user_host => $user->{host}, grants => join("; ", @grants) });
  }
  return \@ret;
}

sub print_show_slave
{
  my ($self)= @_;
  return $self->print_low($self->get_show_slave, $self->{show_slave}->{output_name});
}

sub get_show_slave
{
  my ($self)= @_;

  if ($self->{output} eq "short")
  {
    carp("--show-slave-enable does not support --output=short") if !($ENV{HARNESS_ACTIVE});
    return undef;
  }
  my @ret;

  foreach my $channel (@{$self->instance->show_slave_status})
  {
    ### Ignore named-channel(for Multi-Source Replication)
    next if exists($channel->{Channel_name}) && $channel->{Channel_name} ne "";

    push(@ret, { master_host => $channel->{Master_Host},
                 master_port => $channel->{Master_Port},
                 last_update => strftime("%Y-%m-%d %H:%M:%S", localtime), });
  }
  return \@ret;
}

sub print_low
{
  my ($self, $rs, $table)= @_;
  return undef if !($rs->[0]);

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
                        $self->{host} || "localhost", $seperator,
                        $self->{port} || 3306, $seperator,
                        join($seperator, map { sprintf(q|"%s"|,
                                                       defined($row->{$_}) ? 
                                                         escape_backslash($row->{$_}) :
                                                         "")
                                             } @column));
      push(@buff, $info);
    }

    return join("\n", @buff) . "\n";
  }
  elsif ($self->{output} eq "short")
  {
    foreach my $row (@$rs)
    {
      ### Add host/port information
      my $info= $row->{last_update} . "\t" . 
                  join("\t", map { sprintf("%s:%s", $_, $row->{$_} // "") } grep { $_ ne "last_update" } @column);
      push(@buff, $info);
    }
    return join("\n", @buff) . "\n";
  }
  elsif ($self->{output} eq "json")
  {
    return undef if !($table);
    my $header= { host => $self->{host} || "localhost",
                  port => $self->{port} || 3306, };
    return to_json({ $table => [map { +{ %$header, %$_, } } @$rs] });
  }
  elsif ($self->{output} eq "sql")
  {
    return undef if !($table);
    foreach my $row (@$rs)
    {
      ### Add host/port information
      my $info= sprintf(q|('%s', '%s', %s)|,
                        $self->{host} || "localhost",
                        $self->{port} || 3306,
                        join(", ", map { defined($row->{$_}) ? 
                                           $self->instance->quote($row->{$_}) :
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
                        default => 10,
                        text => "Sleep seconds during each collecting iterations." },
    iteration      => { alias   => ["iteration", "count", "c"],
                        default => 0,
                        text => "How many times does script collect information. (0 means infinity)" },
    output         => { alias   => ["output", "o"],
                        default => "tsv",
                        isa     => [qw{tsv csv json sql short}],
                        text => "Results output style." },
    record_path    => { alias   => ["record-path", "r"],
                        text => "When specified, each collection-methods write into the directory.\n" .
                                "  (When not set, write into STDOUT)" },
    delta => { alias => ["delta", "diff"],
               default => 0,
               isa => [0, 1],
               text => q{Output diff-ed Numeric values compared with previous iteration.} },
    delta_per_second => { alias => ["delta_per_second"],
                          default => 0,
                          isa   => [0, 1],
                          text => q{Calculate diff-ed value to per-seconds(if not, per --interval seconds)} },
    idle_print => { alias => ["idle_print", "idle", "H"],
                    default => 1,
                    isa     => [0, 1],
                    text    => "Print even diff-ed value is zero." },
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
