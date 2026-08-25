package Ytkit::MDLChecker;

########################################################################
# Copyright (C) 2026  yoku0825
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

my $progname= "yt-mdl-checker";
my $synopsis= qq{  \$ $progname --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password --interval=1};
my $script= sprintf("%s - Check performance_schema.metadata_locks and KILL caused connection", $0);
my $description= << "EOS";
$progname checks performance_schema.metadata_locks.

If these parameteres are NOT set Enabled ='Yes' and Timed = 'Yes',
$progname will try turn on there parameters(This needs Update_priv for performance_schema)

- performance_schema.setup_instruments
  - wait/lock/metadata/sql/mdl

Already set these parameters, $progname needs only Select_priv for performance_schema (if you use "--kill", needs also Super or CONNECTION_ADMIN).
EOS
my $allow_extra_argv= 0;


sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
              _saved_instrumentes => [],
              _saved_consumers => [],
              _fix_p_s => 0,
            };
  bless $self => $class;
  $self->handle_help;

  return $self;
}

sub prepare
{
  my ($self)= @_;

  ### croak if can't connect to MySQL.
  $self->test_connect;

  ### Check performance_schema = ON.
  $self->checking_requirement;

  ### Check instruments.
  $self->setup_instruments;
}

sub checking_requirement
{
  my ($self)= @_;

  ### We needs MySQL >= 5.7.6
  if ($self->instance->mysqld_version < 50706)
  {
    _croakf("%s needs MySQL Version >= 5.7.6 but Server version is %d",
            $progname, $self->instance->mysqld_version);
    return 0;
  }

  ### and performance_schema = ON
  if (!($self->instance->p_s_on))
  {
    _croakf("%s needs performance_schema = ON but actually off", $progname);
    return 0;
  }
  return 1;
}

sub setup_instruments
{
  my ($self)= @_;
  foreach my $sql (@{$self->_setup_instruments})
  {
    $self->{_fix_p_s}= 1;
    $self->instance->exec_sql($sql);
  }
  return 1;
}

sub _setup_instruments
{
  my ($self)= @_;
  my $rs= $self->instance->fetch_p_s_instrument_metadata_locks;
  $self->{_saved_instrumentes}= $rs;

  my @ret;
  foreach my $row (@$rs)
  {
    if ($row->{enabled} ne "YES" || $row->{timed} ne "YES")
    {
      ### Update ENABLED = YES, TIMED = YES
      my $sql= sprintf("UPDATE performance_schema.setup_instruments SET enabled = 'YES', timed = 'YES' WHERE name = %s",
                       $self->instance->quote($row->{name}));
      _debugf("%s updates setup_instruments: { %s) }\n", $progname, $sql);
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
    _debugf("%s restores performance_schema table { %s }\n", $progname, $sql);
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

sub print_or_kill_connection
{
  my ($self)= @_;

  ### Remove old cache of fetch_metadata_locks method
  delete $self->instance->{__fetch_metadata_locks_for_57};
  delete $self->instance->{__fetch_metadata_locks_with_cte};

  foreach my $blocking_trx (@{$self->instance->fetch_metadata_locks})
  {
    ### Ex. {blocker_thread_id => 46, lock_status => GRANTED, object_name => t1, object_schema => d1, trx_query => , trx_rows_locked => 0, trx_rows_modified => 0, trx_started => 2026-08-24 05:24:26}
    _notef("Blocking transaction detected: %s", $blocking_trx);
    if ($self->{kill})
    {
      foreach (@{$self->instance->fetch_processlistid_from_threadid($blocking_trx->{blocker_thread_id})})
      {
        my $sql= sprintf("KILL CONNECTION %d", $_->{processlist_id});
        _notef($sql);
        $self->instance->exec_sql_with_carp($sql); ### KILL could be failed by "Unknown thread id"(log-out naturally)
      }
    }
  }
}

sub _config
{
  my $yt_alterprogress_option=
  {
    "interval" => { alias => ["interval", "i"],
                    default => 10,
                    text => q{Sleeping duration for each SELECT}, },
    "kill" => { alias => ["kill"],
                default => 0,
                noarg => 1,
                text => q{KILL Metadata-Locked connection}, },
  };

  my $config= Ytkit::Config->new({ %$yt_alterprogress_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_argv;
  return $config;
}

return 1;
