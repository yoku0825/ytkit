package Ytkit::BulkDelete;

########################################################################
# Copyright (C) 2023  yoku0825
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
use Ytkit::ReplTopology;
use Ytkit::WaitReplication;
use JSON qw{ from_json };
use Time::HiRes qw{ time sleep };

my $synopsis= q{  $ yt-bulk-delete --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password } .
              q{--table=d1.t1 --delete-row-start=1000 --delete-row-multiplier=2};
my $script= sprintf("%s - ", $0);
my $description= << "EOS";
Bulk delete-rows for specific table by "DELETE FROM table LIMIT ?" before DROP TABLE table.
Checking Seconds_Behind_Source and automatically changes LIMIT-Clause number.
EOS
my $allow_extra_arvg= 0;


sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self=
  {
    _config => $config,
    _replica_wait => [],
    %{$config->{result}},
  };
  bless $self => $class;
  $self->handle_help;

  return $self;
}

sub prepare
{
  my ($self)= @_;

  ### Multiplier >= 1?
  if ($self->{delete_row_multiplier} == 1)
  {
    _notef("delete_row_multiplier is 1, dinamic limit clause adjust turns off");
  }
  elsif ($self->{delete_row_multiplier} < 1)
  {
    _croakf("Can't set delete_row_multiplier < 1, at least delete_row_multiplier=1(means dinamic adjustment turns off)");
  }

  ### Server is not read_only?
  if ($self->instance->valueof("read_only") eq "ON")
  {
    _croakf("Specified MySQL is read_only = ON, aborting.");
  }

  ### The table is exists?
  ### The table has Primary Key? (Not PKE)
  $self->_table_check;

  ### Can connect replicas and can execute SHOW REPLICA STATUS?
  $self->_pickup_replica;
}

sub bulk_delete
{
  my ($self)= @_;
  my $delete_base  = sprintf("DELETE FROM %s ", $self->{table});
  my $current_limit= $self->{delete_row_start};
  my $smooth_time= 0;

  ### Initial wait for replication conversion.
  $self->wait_replica;
  while ()
  {
    sleep($self->{sleep});
    my $start= time();
    my $deleted_row= $self->instance->exec_sql($delete_base . " LIMIT $current_limit");
    my $end= time();
    _infof("%d rows are deleted during %3.3f sec", $deleted_row, $end - $start);

    if ($self->instance->error)
    {
      _croakf("DELETE statement failure by %s", $self->instance->error);
    }

    last if $deleted_row == 0;

    my $wait_replica_time= $self->wait_replica;
    _debugf("wait_replica_time: %f", $wait_replica_time);

    if ($wait_replica_time >= $self->{timer_wait})
    {
      ### Replication was too delay.
      $current_limit= int($current_limit / ($self->{delete_row_multiplier} ** int($wait_replica_time))) + 1;
      _notef("Replication was too delay (%3.3f sec), limit_clause decreasing to %d", $wait_replica_time, $current_limit);
      $smooth_time--;
    }
    else
    {
      if ($end - $start >= $self->{timer_wait})
      {
        ### Replication is smooth but DELETE statement took a time.
        $current_limit= int($current_limit / ($self->{delete_row_multiplier} ** int($end - $start))) + 1;
        _notef("DELETE statement takes %3.3f sec, limit_clause decreasing to %d", $end - $start, $current_limit);
        $smooth_time--;
      }
      else
      {
        if (++$smooth_time > $self->{accelerating_throttling})
        {
          ### Bumpup LIMIT Clause.
          $current_limit= int($current_limit * $self->{delete_row_multiplier});
          _notef("It seems well %d times, limit_clause increasing to %d", $smooth_time, $current_limit);
          $smooth_time= 0;
        }
      }
    }
  }

  _notef("Finished to cleanup %s", $self->{table});
}

sub _table_check
{
  my ($self)= @_;

  my $target_table= $self->{table};

  my $show_create_table= $self->instance->query_arrayref("SHOW CREATE TABLE $target_table");

  if ($self->instance->error)
  {
    ### Table does not exist or access denied.
    _croakf("Can't access %s. (%s)", $target_table, $@);
  }

  my $create_table_statement= $show_create_table->[0]->{"Create Table"};
  my $is_primary_key= 0;

  foreach (split(/\n/, $create_table_statement))
  {
    $is_primary_key= 1 if /PRIMARY KEY/;
  }

  if ($is_primary_key)
  {
    return 1;
  }
  else
  {
    ### No Primary Key
    if ($self->{force})
    {
      _carpf("%s doesn't have Primary Key, but --force has specified. Continuing..", $target_table);
    }
    else
    {
      _croakf("%s doesn't have Primary Key, aborting. (Use --force if you need bulk-delete forcefully.)", $target_table);
    }
  }
}

sub _pickup_replica
{
  my ($self)= @_;

  my $prog= Ytkit::ReplTopology->new("--output=json", $self->connect_param);
  $prog->run;
  my $topology= from_json($prog->topology);

  foreach my $key (keys(%$topology))
  {
    if (@{$topology->{$key}->{source}})
    {
      ### When it has source, it's replica.
      _infof("Detected replica: %s", $key);
      my ($host, $port)= split_host_port($key);
      push(@{$self->{_replica_wait}}, Ytkit::WaitReplication->new($self->connect_param,
                                                                  "--host", $host, ### Override
                                                                  "--port", $port, ### Override
                                                                  "--seconds_behind_master", $self->{timer_wait},
                                                                  "--sleep", 1));
    }
  }
}

sub wait_replica
{
  my ($self)= @_;

  my $start= time();
  foreach (@{$self->{_replica_wait}})
  {
    $_->wait_slave;
  }
  my $end= time();
  return $end - $start;
}

sub _config
{
  my $own_option=
  {
    table => { alias => ["table"],
               text => "Target table name. Should be specified <database>.<table>",
               mandatory => 1 },
    delete_row_start => { alias => ["delete_row_start", "delete_row_start_count"],
                          text  => "Start value of LIMIT Clause (DELETE FROM <table> LIMIT ?)",
                          default => 1000, },
    delete_row_multiplier => { alias => ["delete_row_multiplier"],
                               text  => "Change LIMIT Clause dinamically by multiplying this number. When script detects 'Smooth', next LIMIT Caluse is current_limit * delete_row_multiplier. " .
                                        "When script detects 'Busy', next LIMIT Clause is current_limit / delete_row_multiplier." .
                                        "If you specify --delete_row_multiplier=1, the script doesn't change LIMIT Clause value.",
                               default => 1.1 },
    accelerating_throttling => { text => "How many times DELETE succeed smoothly, before accelerating LIMIT Clause.",
                                 default => 2 },
    timer_wait => { alias => ["timer_wait"],
                    text  => "Seconds which allowed each iteration. \n" .
                             "   - Execution time of DELETE > --timer_wait, start throttling.\n" .
                             "   - Execution time of DELETE < --timer_wait, start accelerating.\n" .
                             "   - Seconds_Behind_Source > --timer_wait, script sleeping.\n" .
                             "   - Waiting time of Seconds_Behind_Source > --timer_wait, start throttling.",
                    default => 1 },
    sleep => { alias => ["sleep"],
               text => "Sleep interval for each DELETE statement.",
               default => 0.2 },
    force => { alias => ["force", "f"],
               text => "Force execute even if the table doesn't have Primary Key.",
               noarg => 1,
               default => 0,
               isa => sub { $ENV{ytkit_force}= 1; }},
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
