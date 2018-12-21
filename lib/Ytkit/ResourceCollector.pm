package Ytkit::ResourceCollector;

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

use Ytkit::Collect;

my $synopsis= q{ $ yt-resource-collector --config=/path/to/conf --record-path=/tmp/resource --auto-restart=0 };
my $script= sprintf("%s - Launch yt-collect processes following by conf-file", $0);
my $description= << "EOS";
yt-resource-collector launches yt-collect processes following by conf-file
EOS
my $allow_extra_arvg= 0;
my $config= _config();
my $sleep_time= 10;

sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}}, };
  bless $self => $class;
  $self->handle_help;

  mkdir($self->{record_path}) if !(-d $self->{record_path});
  return $self;
}

sub _load_config_file
{
  my ($config_file)= @_;
  return undef if !(-e $config_file) || !(-r $config_file);

  return Ytkit::Config::File->new($config_file, {use_global => 1});
}

sub collect
{
  my ($self)= @_;
  my $config_file= $self->{_config}->{result}->{config_file};
  my @children_pid;

  $SIG{"CHLD"}= 'IGNORE';
  $SIG{"INT"}= $SIG{"HUP"}= $SIG{"USR1"}= sub { exit 0; };
  if (my $proc_config= _load_config_file($config_file))
  {
    while (my ($instance, $conf)= each(%$proc_config))
    {
      my $pid= fork();

      if (!($pid))
      {
        ### Child (collecting process)
        my $dirname= sprintf("%s/%s", $self->{record_path}, $instance);
        mkdir($dirname) if !(-d $dirname);

        while ()
        {
          carp("Starting to connect to $instance") if !($ENV{HARNESS_ACTIVE});

          eval
          {
            my $prog= Ytkit::Collect->new(@$conf, "--record-path=$dirname", "--verbose=1");
            $prog->collect;
          };

          carp("$instance has been disconnected. ($@)") if !($ENV{HARNESS_ACTIVE});

          ### --auto-restart=0, break loop to exit.
          last if !($self->{auto_restart});
          sleep $sleep_time;
        }
        exit 1;
      }
    }
    ### Parent waits signal.
    while ()
    {
      sleep $sleep_time;
    }
  }
  else
  {
    croak(sprintf("Can't read config_file %s", $config_file));
  }
}

sub _config
{
  my $yt_resource_collector_option=
  {
    config_file =>
    {
      alias   => ["config_file", "c", "config"],
      default => "/usr/local/etc/ytkit/yt-resource-collector.conf",
      text    => "Path to config file",
    },
    record_path =>
    {
      alias   => ["record-path", "r"],
      default => "/tmp/yt-resource-collector",
      text => "When specified, each collection-methods write into the directory.",
    },
    auto_restart =>
    {
      alias   => ["auto-restart"],
      default => 1,
      isa     => [1,0],
      text    => "Restart when child process has downed.",
    },
  };
  my $config= Ytkit::Config->new({ %$yt_resource_collector_option, 
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
}

return 1;
