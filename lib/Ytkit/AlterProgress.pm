package Ytkit::AlterProgress;

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
use base "Ytkit";

use Ytkit::MySQLServer;

my $synopsis= q{  $ yt-alter-progress --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password --interval=1};
my $script= sprintf("%s - Display InnoDB ALTER TABLE progress", $0);
my $description= << "EOS";
yt-alter-progress displays InnoDB ALTER TABLE progress using performance_schema.

If these parameteres are NOT set Enabled ='Yes' and Timed = 'Yes',
yt-alter-progress will try turn on there parameters(This needs Update_priv for performance_schema)

- performance_schema.setup_consumers
  - events_stages_current
  - events_stages_history
  - events_stages_history_long

- performance_schema.setup_instruments
  - stage/innodb/alter table%

Already set these parameters, yt-alter-progress needs only Select_priv for performance_schema.
EOS
my $allow_extra_arvg= 0;
my $config= _config();


sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
              _saved_instrumentes => [],
              _saved_consumers => [],
              _fix_p_s => 0,
            };
  bless $self => $class;
  $self->handle_help;

  ### croak if can't connect to MySQL.
  $self->test_connect;

  ### Check performance_schema = ON.
  $self->checking_requirement;

  ### Check instruments.
  $self->setup_instruments;
  $self->setup_consumers;

  return $self;
}

sub checking_requirement
{
  my ($self)= @_;

  ### We needs MySQL >= 5.7.6
  if ($self->instance->mysqld_version < 50706)
  {
    $self->croakf("yt-alter-progress needs MySQL Version >= 5.7.6 but Server version is %d",
                  $self->instance->mysqld_version) if !($ENV{HARNESS_ACTIVE});
    return 0;
  }

  ### and performance_schema = ON
  if (!($self->instance->p_s_on))
  {
    $self->croakf("yt-alter-progress needs performance_schema = ON but actually off")
      if !($ENV{HARNESS_ACTIVE});
    return 0;
  }
  return 1;
}

sub setup_instruments
{
  my ($self)= @_;
  foreach my $sql (@{$self->_search_instruments})
  {
    $self->{_fix_p_s}= 1;
    $self->instance->exec_sql($sql);
  }
  return 1;
}

sub _search_instruments
{
  my ($self)= @_;
  my $rs= $self->instance->fetch_p_s_stage_innodb_alter_table;
  $self->{_saved_instrumentes}= $rs;

  my @ret;
  foreach my $row (@$rs)
  {
    if ($row->{enabled} ne "YES" || $row->{timed} ne "YES")
    {
      ### Update ENABLED = YES, TIMED = YES
      my $sql= sprintf("UPDATE performance_schema.setup_instruments SET enabled = 'YES', timed = 'YES' WHERE name = %s",
                       $self->instance->quote($row->{name}));
      $self->debugf("yt-alter-progress updates setup_instruments: { %s) }\n", $sql);
      push(@ret, $sql);
    }
  }
  return \@ret;
}

sub setup_consumers
{
  my ($self)= @_;

  foreach my $sql (@{$self->_search_consumers})
  {
    $self->{_fix_p_s}= 1;
    $self->instance->exec_sql($sql);
  }
  return 1;
}

sub _search_consumers
{
  my ($self)= @_;
  my $rs= $self->instance->fetch_p_s_events_stages;
  $self->{_saved_consumers}= $rs;
  my @ret;

  foreach my $row (@$rs)
  {
    if ($row->{enabled} ne "YES")
    {
      ### Update ENABLED = YES, TIMED = YES
      my $sql= sprintf("UPDATE performance_schema.setup_consumers SET enabled = 'YES' WHERE name = %s",
                       $self->instance->quote($row->{name}));
      $self->debugf("yt-alter-progress updates setup_consumers { %s }\n", $sql);
      push(@ret, $sql);
    }
  }
  return \@ret;
}

sub restore_setting
{
  my ($self)= @_;

  foreach my $sql (@{$self->_restore_setting_sql})
  {
    $self->debugf("yt-alter-progress restores performance_schema table { %s }\n", $sql);
    $self->instance->exec_sql($sql);
  }
  return 1;
}

sub _restore_setting_sql
{
  my ($self)= @_;
  my @sql;

  if ($self->{_fix_p_s})
  {
    foreach (@{$self->{_saved_consumers}})
    {
      push(@sql, sprintf("UPDATE performance_schema.setup_consumers SET enabled = %s WHERE name = %s",
                         $self->instance->quote($_->{enabled}),
                         $self->instance->quote($_->{name})));
    }

    foreach (@{$self->{_saved_instrumentes}})
    {
      push(@sql, sprintf("UPDATE performance_schema.setup_instruments SET enabled = %s, timed = %s WHERE name = %s",
                         $self->instance->quote($_->{enabled}),
                         $self->instance->quote($_->{timed}),
                         $self->instance->quote($_->{name})));
    }
  }
  return \@sql;
}

sub alter_table_progress
{
  my ($self)= @_;
  my $rs= $self->instance->alter_table_progress;
  my $row= $rs->[0];

  ### Don't cache.
  delete($self->instance->{_alter_table_progress});

  return sprintf("[ %4.2f%% ( %d sec | %d sec) ] %s : %s",
                 $row->{progress} // 0, $row->{estimated} // 0,
                 $row->{elapsed} // 0, $row->{event_name} // "",
                 $row->{sql_text} // "") if $row;
}

sub _config
{
  my $yt_alterprogress_option=
  {
    "interval" => { alias => ["interval", "i"],
                    default => 10,
                    text => q{Sleeping duration for each SELECT}, },
  };

  my $config= Ytkit::Config->new({ %$yt_alterprogress_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
}

return 1;
