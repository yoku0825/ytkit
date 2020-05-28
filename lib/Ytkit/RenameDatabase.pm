package Ytkit::RenameDatabase;

########################################################################
# Copyright (C) 2020  yoku0825
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

my $synopsis= q{  $ yt-rename-database --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password --from=d1 --to=d2 };
my $script= sprintf("%s - Emulate RENAME DATABASE <from> TO <to>", $0);
my $description= << "EOS";
Emulate 'RENMAE DATABASE <from> TO <to>' as RENAME TABLE statements.

If you have TRIGGERS, ROUTINES, EVENTS, VIEWS and Foreign Keys in from-schema,
please do NOT use this script because this doesn't care them.
EOS
my $allow_extra_arvg= 0;
my $config= _config();


sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
            };
  bless $self => $class;
  $self->handle_help;

  return $self;
}

sub run
{
  my ($self)= @_;

  $self->test_connect;
  my $src= $self->{from};
  my $dst= $self->{to};

  _notef("-- Emulating RENAME DATABASE %s TO %s\n", $src, $dst);

  _croakf("From-database %s does not exist.", $src) if !(grep { $src eq $_ } $self->fetch_dbname);
  _croakf("To-database %s already exists.", $dst) if grep { $dst eq $_ } $self->fetch_dbname;

  _croak_or_carp(_sprintf("%s has TRIGGERS, not supporting.(For *forcing-execution*, use --ignore-trigger or --force)", $src),
                 $self->{ignore_trigger}) if $self->fetch_trigger_count;
  _croak_or_carp(_sprintf("%s has Foreign Keys, not supporting.(For *forcing-execution*, use --ignore-fk or --force)", $src),
                 $self->{ignore_fk}) if $self->fetch_fk_count;
  _croak_or_carp(_sprintf("%s has ROUTINES, not supporting.(For *forcing-execution*, use --ignore-routine or --force)", $src),
                 $self->{ignore_routine}) if $self->fetch_routine_count;
  _croak_or_carp(_sprintf("%s has VIEWS, not supporting.(For *forcing-execution*, use --ignore-view or --force)", $src),
                 $self->{ignore_view}) if $self->fetch_view_count;
  _croak_or_carp(_sprintf("%s has EVENTS, not supporting.(For *forcing-execution*, use --ignore-event or --force)", $src),
                 $self->{ignore_event}) if $self->fetch_event_count;

  $self->_do_or_echo('CREATE DATABASE `%s`', $dst);
  
  foreach ($self->fetch_tablename)
  {
    $self->_do_or_echo('RENAME TABLE `%s`.`%s` TO `%s`.`%s`', $src, $_, $dst, $_);
  }
  
  $self->_do_or_echo('DROP DATABASE `%s`', $src);
}

sub _croak_or_carp
{
  my ($msg, $ignore)= @_;

  if ($ignore)
  {
    _carpf($msg);
  }
  else
  {
    _croakf($msg);
  }
}

sub fetch_tablename
{
  my ($self)= @_;
  my $sql= "SELECT table_name AS table_name FROM information_schema.tables WHERE table_schema = ?";
  return map { $_->{table_name} } @{$self->instance->query_arrayref($sql, $self->{from})};
}

sub fetch_dbname
{
  my ($self)= @_;
  my $sql= "SELECT schema_name AS schema_name FROM information_schema.schemata";
  return map { $_->{schema_name} } @{$self->instance->query_arrayref($sql)}
}

sub fetch_trigger_count
{
  my ($self)= @_;
  my $sql= "SELECT COUNT(*) AS c FROM information_schema.triggers WHERE trigger_schema = ?";
  return $self->instance->query_arrayref($sql, $self->{from})->[0]->{c};
}

sub fetch_fk_count
{
  my ($self)= @_;
  my $sql= "SELECT COUNT(*) AS c FROM information_schema.referential_constraints WHERE constraint_schema = ? OR unique_constraint_schema = ?";
  return $self->instance->query_arrayref($sql, $self->{from}, $self->{from})->[0]->{c};
}

sub fetch_routine_count
{
  my ($self)= @_;
  my $sql= "SELECT COUNT(*) AS c FROM information_schema.routines WHERE routine_schema = ?";
  return $self->instance->query_arrayref($sql, $self->{from})->[0]->{c};
}

sub fetch_view_count
{
  my ($self)= @_;
  my $sql= "SELECT COUNT(*) AS c FROM information_schema.views WHERE table_schema = ?";
  return $self->instance->query_arrayref($sql, $self->{from})->[0]->{c};
}

sub fetch_event_count
{
   my ($self)= @_;
  my $sql= "SELECT COUNT(*) AS c FROM information_schema.events WHERE event_schema = ?";
  return $self->instance->query_arrayref($sql, $self->{from})->[0]->{c};
}

sub _do_or_echo
{
  my ($self, $format, @argv)= @_;
  my $sql= _sprintf($format, @argv);

  if ($self->{execute} == 1)
  {
    _infof("Executing '%s'\n", $sql);
    $self->instance->exec_sql($sql);
    $self->instance->raise_if_error;
  }
  else
  {
    _notef("-- I'm dry-run mode. Specify --execute if you wish to execute statements by script.");
    _notef($sql . ";\n");
  }
}


sub _config
{
  my $own_option=
  {
    execute => { alias => ["execute"],
                 text => "Execute statements. If --execute is not specified, only print statements.",
                 default => 0,
                 noarg => 1 },
    from => { alias => ["source", "src", "from"],
              text  => "Database-name moving from",
              mandatory => 1 },
    to => { alias => ["destination", "dest", "dst", "to"],
              text  => "Database-name moving to",
              mandatory => 1 },
    ignore_trigger => { alias => ["ignore-trigger", "ignore-triggers"],
                        text  => "Force RENAME if --to has TRIGGERS.",
                        noarg => 1,
                        default => 0 },
    ignore_event => { alias => ["ignore-event", "ignore-events"],
                        text  => "Force RENAME if --to has EVENTS.",
                        noarg => 1,
                        default => 0 },
    ignore_routine => { alias => ["ignore-routine", "ignore-routines"],
                        text  => "Force RENAME if --to has ROUTINES.",
                        noarg => 1,
                        default => 0 },
    ignore_fk => { alias => ["ignore-fk"],
                   text  => "Force RENAME if --to has ROUTINES.",
                   noarg => 1,
                   default => 0 },
    ignore_view => { alias => ["ignore-view", "ignore-views"],
                   text  => "Force RENAME if --to has VIEWS.",
                   noarg => 1,
                   default => 0 },
    force => { alias => ["force", "f"],
               text => "Force RENAME if --to has TRIGGERS, EVENTS, ROUTINES, VIEWS, and Foreign Keys.",
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
