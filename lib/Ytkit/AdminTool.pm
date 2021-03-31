package Ytkit::AdminTool;

########################################################################
# Copyright (C) 2020, 2021  yoku0825
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
use Ytkit::AdminTool::DDL;
use Ytkit::Collect;

my $synopsis= q{  $ yt-admin --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password SUBCOMMAND};
my $script= sprintf("%s - Database-schema for cooperation working of ytkit scripts", $0);
my $description= << "EOS";
Management mysqlds using ytkit scripts.

SUBCOMMAND:
- initialize: CREATE SCHEMA admintool and adminview, for freshly installed admintool server.
- upgrade: Re-CREATE SCHEMA adminview. You should execute this when yt-admin is upgraded.
- register: INSERT INTO admintool.instance_info. Registering new mysqld into admintool.
- collect: Fetch data from registered mysqlds.
- list: Print registered mysqlds.
- full-collect: Fetch data from registered mysqlds, more information will be fetched than "collect".
EOS

my $allow_extra_arvg= 1;
my $config= _config();
my $subcommand= [qw{ initialize upgrade register collect list full-collect }];

sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
              _command => $config->{left_argv}->[0],
            };
  bless $self => $class;
  $self->handle_help;

  return $self;
}

sub run
{
  my ($self)= @_;
  my @argv= @{$self->{_config}->{left_argv}};
  my $command= shift(@argv);

  if (!($command))
  {
    _croakf("yt-admin have to specify SUBCOMMAND(%s)", $subcommand);
  }
  elsif (grep { $command eq $_ } @$subcommand)
  {
    $self->test_connect;

    if ($command eq "initialize")
    {
      $self->create_database_admintool;
      $self->create_database_adminview;
    }
    elsif ($command eq "upgrade")
    {
      ### Re-create adminview
      $self->create_database_adminview;
    }
    elsif ($command eq "register")
    {
      _croakf("No ipaddr:port is specified.\nyt-admin register ipaddr:port [ipaddr:port ..]") if !(@argv);

      ### register expects "ipaddr:port" or "ipaddr" (port is 3306 implicitly)
      foreach (@argv)
      {
        _debugf($_);
        my ($ipaddr, $port)= split_host_port($_);
        _croakf("Invalid host (%s)", $_) if !($ipaddr);
        _infof("Registering Host: %s, Port: %d", $ipaddr, $port);
        my $instance= $self->instance;

        ### Check already registered
        my $ret= $instance->_real_query_arrayref("SELECT ipaddr, port " .
                                                 "FROM admintool.instance_info " .
                                                 "WHERE (ipaddr, port) = (?, ?)", $ipaddr, $port);
        if (@$ret)
        {
          _carpf("Host: %s, Port: %d has been already registered. skippking.", $ipaddr, $port);
          next;
        }

        ### INSERT INTO admintool.instance_info
        $instance->exec_sql_with_croak("INSERT INTO admintool.instance_info " .
                                      "(ipaddr, port, last_update, monitoring_enable, last_status) " .
                                      "VALUES (?, ?, NOW(), DEFAULT, DEFAULT)", undef,
                                      $ipaddr, $port);

        ### Initial information fetching
        $self->full_collect($ipaddr, $port);
      }
    }
    elsif ($command eq "collect" || $command eq "full-collect")
    {
      my $instance_list;
      if (@argv)
      {
        foreach (@argv)
        {
          my ($ipaddr, $port)= split_host_port($_);
          push(@$instance_list, { ipaddr => $ipaddr, port => $port });
        }
      }
      else
      {
        $instance_list= $self->_fetch_instance_info;
      }

      ### typical_collect for registed in instance_info
      foreach my $row (@$instance_list)
      {
        next if $row->{healthcheck_role} eq "fabric";  ### yt-collect doesn't support mikasafabric.
        _infof("Fetcing for %s:%d", $row->{ipaddr}, $row->{port});

        if ($command eq "collect")
        {
          $self->typical_collect($row->{ipaddr}, $row->{port});
        }
        elsif ($command eq "full-collect")
        {
          $self->full_collect($row->{ipaddr}, $row->{port});
        }

        _infof("Fetcing done %s:%d", $row->{ipaddr}, $row->{port});
      }
    }
    elsif ($command eq "list")
    {
      foreach my $row (@{$self->list_instance_info})
      {
        _printf("%s\t%s\t%d\t%s\t%s\t%s\n",
                $row->{hostname},
                $row->{ipaddr},
                $row->{port},
                $row->{datadir},
                $row->{version},
                $row->{master});
      }
    }
    else
    {
      ### If you're here, $subcommand and implementation is inconsistent.
      _croakf("Unimplemented SUBCOMMAND(%s), this may be BUG", $command);
    }
  }
  else
  {
    _croakf("Unknown SUBCOMMAND %s (should be one of %s)", $command, $subcommand);
  }
}

sub create_database_admintool
{
  my ($self)= @_;

  _notef("Starting initializing");
  _infof("Starting CREATE DATABASE admintool");
  $self->instance->exec_sql("CREATE DATABASE IF NOT EXISTS admintool");

  if (@{$self->instance->warning})
  {
    ### Warning is maybe "already exists", abort.
    _croakf($self->instance->warning);
    return 0;
  }
  else
  {
    _infof("Starting CREATE TABLE in admintool");
    $self->instance->use("admintool");
    foreach (@{Ytkit::AdminTool::DDL::admintool_schema()})
    {
      $self->instance->exec_sql_with_croak($_);
    }
    _infof("Finished CREATE TABLE in admintool");

    _infof("Starting to fill initial data");
    $self->fill_initial_data;
    _infof("Finished to fill initial data");

    _notef("Finished initializing");
  }
}

sub fill_initial_data
{
  my ($self)= @_;

  my $initial_data=
  {
    healthcheck => [qw{ role
                        uptime_enable uptime_warning uptime_critial
                        slave_status_enable slave_status_warning slave_status_critial
                        long_query_enable long_query_warning long_query_critial
                        long_query_min_warning_thread long_query_min_critial_thread long_query_exclude_host
                        connection_count_enable connection_count_warning connection_count_critial
                        autoinc_usage_enable autoinc_usage_warning autoinc_usage_critial } ],
    collect => [qw{ table_size_enable table_size_limit
                    table_latency_enable table_latency_limit
                    show_status_enable
                    show_variables_enable
                    show_slave_enable
                    show_grants_enable
                    query_latency_enable query_latency_limit
                    innodb_metrics_enable } ],
  };
}

sub create_database_adminview
{
  my ($self)= @_;

  ### Always Re-CREATE
  _notef("Starting to upgrade adminview");
  _infof("Starting (Re-)CREATE DATABASE adminview");
  $self->instance->exec_sql("DROP DATABASE IF EXISTS adminview");
  $self->instance->exec_sql("CREATE DATABASE adminview");

  $self->instance->exec_sql("USE adminview");
  _infof("Starting CREATE VIEW in adminview");
  foreach (@{Ytkit::AdminTool::DDL::adminview_schema()})
  {
    $self->instance->exec_sql_with_croak($_);
  }

  ### Only 8.0 can use WITH RECURSIVE and WINDOW functions
  if ($self->instance->mysqld_version >= 80011)
  {
    foreach (@{Ytkit::AdminTool::DDL::adminview_schema_ex()})
    {
      $self->instance->exec_sql_with_croak($_);
    }
  }
  _infof("Finished CREATE VIEW in adminview");
  _infof("Finished (Re-)CREATE DATABASE adminview");
  _notef("Finished to upgrade adminview");
}

sub full_collect
{
  my ($self, $ipaddr, $port)= @_;
  my $instance= $self->instance;
  $instance->use("admintool");

  my $buff; ### For empty resultset (SHOW SLAVE STATUS for master, SELECT p_s. for p_s=OFF)
  my $collect= $self->_make_collector($ipaddr, $port);

  ### test connection.
  eval
  {
    $collect->prepare;
  };
  if ($@)
  {
    _carpf("%s, Collect data skipping", $@);
    ### Destroy for next collector
    delete($self->{_collector});

    return 1;
  }

  ### admintool.variable_info
  eval
  {
    $buff= $collect->print_show_variables;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### admintool.slave_info
  ### - INSERTing slave_info should be after DELETE.
  ###   Because old info could be remained when slave has promoted to master.
  $instance->exec_sql_with_carp("DELETE FROM admintool.slave_info WHERE (ipaddr, port) = (?, ?)", undef, $ipaddr, $port);
  eval
  {
    $buff= $collect->print_show_slave;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### admintool.grant_info
  eval
  {
    $buff= $collect->print_show_grants;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  $self->typical_collect($ipaddr, $port);
}

sub typical_collect
{
  my ($self, $ipaddr, $port)= @_;
  my $instance= $self->instance;
  $instance->use("admintool");

  my $buff; ### For empty resultset (SHOW SLAVE STATUS for master, SELECT p_s. for p_s=OFF)
  my $collect= $self->_make_collector($ipaddr, $port);
 
  ### test connection.
  eval
  {
    $collect->prepare;
  };
  if ($@)
  {
    _carpf("%s, Collect data skipping", $@);
    ### Destroy for next collector
    delete($self->{_collector});

    return 1;
  }

  ### admintool.table_status_info
  eval
  {
    $buff= $collect->print_table_size;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### admintool.ps_table_info
  eval
  {
    $buff= $collect->print_table_latency;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### admintool.is_innodb_metrics
  eval
  {
    $buff= $collect->print_innodb_metrics;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### admintool.ps_digest_info
  eval
  {
    $buff= $collect->print_query_latency;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### admintool.status_info
  eval
  {
    $buff= $collect->print_show_status;
  };
  _carpf($@) if $@;
  $instance->exec_sql_with_carp($buff) if $buff;

  ### Destroy for next collector
  delete($self->{_collector});
}

sub _make_collector
{
  my ($self, $ipaddr, $port)= @_;
  $self->{_collector} //= Ytkit::Collect->new("--host", $ipaddr,
                                              "--port", $port,
                                              "--user", $self->{monitor_user} // "''",
                                              "--password", $self->{monitor_password} // "''",
                                              "--output=sql",
                                              "--sql-update",
                                              "--interval=0",
                                              "--count=1");
  return $self->{_collector};
}

sub _fetch_instance_info
{
  my ($self)= @_;
  return $self->instance->query_arrayref("SELECT ipaddr, port, healthcheck_role " .
                                         "FROM admintool.instance_info " .
                                         "WHERE monitoring_enable = 1");
}

sub list_instance_info
{
  my ($self)= @_;
  return $self->instance->query_arrayref("SELECT hostname, ipaddr, port, datadir, version, master, monitor " .
                                         "FROM adminview.instance_list");
}

sub purge_old_records
{
  my ($self)= @_;

  foreach my $table (qw{ is_innodb_metrics ps_digest_info ps_table_info status_info table_status_info })
  {
    ### DELETE all records before 1 year ago
    my $purge_by_yearly= _sprintf("DELETE FROM admintool.%s USE INDEX(idx_lastupdate) " .
                                  "WHERE last_update < CURDATE() - INTERVAL 1 YEAR", $table);
    $self->instance->exec_sql_with_carp($purge_by_yearly);

    ### Hold recods on Monday before 1 month ago
    my $purge_by_weekly= _sprintf("DELETE FROM admintool.%s USE INDEX(idx_lastupdate) " .
                                  "WHERE last_update < CURDATE() - INTERVAL 1 MONTH AND " .
                                        "WEEKDAY(last_update) <> 1");
    $self->instance->exec_sql_with_carp($purge_by_weekly);
  }
}

sub _config
{
  my $own_option=
  {
    monitor_user => { alias => ["monitor_user"],
                      text  => "MySQL Username for healthcheck, collect, etc." },
    monitor_password => { alias => ["monitor_password"],
                          text  => "Passowrd correspond for --monitor-user" },
  };

  my $config= Ytkit::Config->new({ %$own_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
}

return 1;
