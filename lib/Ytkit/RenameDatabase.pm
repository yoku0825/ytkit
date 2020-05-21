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
my $script= sprintf("%s - Show SELECT statement which is extracted '*'", $0);
my $description= << "EOS";
Emulate 'RENMAE DATABASE <from> TO <to>'
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

  _notef("Emulating RENAME DATABASE %s TO %s\n", $src, $dst);

  _croakf("From-database %s does not exist.", $src) if !(grep { $src eq $_ } $self->fetch_dbname);
  _croakf("To-database %s already exists.", $dst) if grep { $dst eq $_ } $self->fetch_dbname;

  $self->_do_or_echo('CREATE DATABASE `%s`', $dst);
  
  foreach ($self->fetch_tablename)
  {
    $self->_do_or_echo('RENAME TABLE `%s`.`%s` TO `%s`.`%s`', $src, $_, $dst, $_);
  }
  
  $self->_do_or_echo('DROP DATABASE `%s`', $src);
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

sub _do_or_echo
{
  my ($self, $format, @argv)= @_;
  my $sql= _sprintf($format, @argv);

  if ($self->{execute} == 1)
  {
    _infof("Executing '%s'\n", $sql);
    $self->instance->exec_sql($sql);
    _croakf($self->instance->error) if $self->instance->error;
    _carpf($self->instance->warning) if @{$self->instance->warning};
  }
  else
  {
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
