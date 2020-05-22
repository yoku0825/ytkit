package Ytkit::AdminTool;

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
use Ytkit::MySQLServer;
use Ytkit::AdminTool::DDL;

my $synopsis= q{  $ yt-admin --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password SUBCOMMAND};
my $script= sprintf("%s - Database-schema for cooperation working of ytkit scripts", $0);
my $description= << "EOS";
FIXME
EOS
my $allow_extra_arvg= 1;
my $config= _config();
my $subcommand= [qw{ initialize upgrade }];

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

  if (!($self->{_command}))
  {
    _croakf("yt-admin have to specify SUBCOMMAND(%s)", $subcommand);
  }
  elsif (grep { $self->{_command} eq $_ } @$subcommand)
  {
    $self->test_connect;

    if ($self->{_command} eq "initialize")
    {
      $self->create_database_admintool;
      ### Treat upgrade after CREATE DATABAse
      $self->{_command}= "upgrade";
    }

    if ($self->{_command} eq "upgrade")
    {
      ### Re-create adminview
      $self->create_database_adminview;
    }
  }
  else
  {
    _croakf("Unknown SUBCOMMAND %s (should be one of %s)", $self->{_command}, $subcommand);
  }

  return $self;
}

sub create_database_admintool
{
  my ($self)= @_;

  $self->instance->exec_sql("CREATE DATABASE IF NOT EXISTS admintool");

  if (@{$self->instance->warning})
  {
    ### Warning is maybe "already exists", abort.
    _croakf($self->instance->warning);
    return 0;
  }
  else
  {
    $self->instance->exec_sql("USE admintool");
    foreach (@{Ytkit::AdminTool::DDL::admintool_schema()})
    {
      $self->instance->exec_sql($_);
      _croakf($self->instance->error) if $self->instance->error;
      _carpf($self->instance->warning) if @{$self->instance->warning};
    }
  }
}

sub create_database_adminview
{
  my ($self)= @_;

  ### Always Re-CREATE
  $self->instance->exec_sql("DROP DATABASE IF EXISTS adminview");
  $self->instance->exec_sql("CREATE DATABASE adminview");

  $self->instance->exec_sql("USE adminview");
  foreach (@{Ytkit::AdminTool::DDL::adminview_schema()})
  {
    $self->instance->exec_sql($_);
    _croakf($self->instance->error) if $self->instance->error;
    _carpf($self->instance->warning) if @{$self->instance->warning};
  }

  ### Only 8.0 can use WITH RECURSIVE and WINDOW functions
  if ($self->instance->mysqld_version >= 80011)
  {
    foreach (@{Ytkit::AdminTool::DDL::adminview_schema_ex()})
    {
      $self->instance->exec_sql($_);
      _croakf($self->instance->error) if $self->instance->error;
      _carpf($self->instance->warning) if @{$self->instance->warning};
    }
  }
}





sub _config
{
  my $own_option=
  {
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
