package Ytkit::Config::CLI;

########################################################################
# Copyright (C) 2021  yoku0825
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
use JSON qw{ to_json from_json };

my $synopsis= q{  $ yt-config --json='{"host": {"alias": ["h", "host"], "default": "localhost"}, "port": {..}}' } .
              q{-h 192.168.0.1 };
my $script= sprintf("%s - Ytkit::Config wrapper for shell script", $0);
my $description= << "EOS";
--json= Jsoned option structure for Ytkit::Config,
after options are returned eval-able environment variable.
EOS
my $allow_extra_argv= 1;


sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
            };
  bless $self => $class;
  $self->handle_help;
  $self->generate_config_parser;

  return $self;
}

sub generate_config_parser
{
  my ($self)= @_;

  my $new_config=
  {
    %{from_json($self->{json_option_struct})},
    $self->{use_connect} ? %$Ytkit::Config::CONNECT_OPTION : (),
  };
  
  my $parser= Ytkit::Config->new($new_config);
  $parser->parse_argv(@{$self->{_config}->{left_argv}});

  $self->{_handle}= $parser;
  return 1;
}

sub print
{
  my ($self)= @_;

  my $result= $self->{_handle}->{result};
  my $variable= join(" ", map { sprintf("%s=%s", $_, $result->{$_} // "") } sort(keys(%$result)));
  my $new_argv= join(" ", @{$self->{_handle}->{left_argv}});

  if ($self->{output} eq "command")
  {
    return sprintf("%s %s %s", $variable, $self->{program_name} ? $self->{program_name} : "%s", $new_argv);
  }
  elsif ($self->{output} eq "export" || $self->{output} eq "variable")
  {
    return sprintf("export %s", $variable);
  }
}


sub _config
{
  my $own_option=
  {
    use_connect =>
    {
      alias => ["use_connect", "use_connect_option", "include_connect"],
      text => "Include Ytkit::Config::CONNECT_OPTION definition",
      isa => [0, 1],
      default => 0,
    },
    json_option_struct =>
    {
      alias => ["json"],
      text => "JSONed Ytkit::Config definition.",
      isa => sub { my $json= shift; to_json(from_json($json)); }, ### Validation
      mandatory => 1,
    },
    program_name =>
    {
      alias => ["program_name", "program"],
      text  => "Program name for --output=command",
    },
    output =>
    {
      alias => ["output", "o"],
      text => "Output style",
      isa => ["command", "export", "variable"],
      default => "variable",
    },
  };

  my $config= Ytkit::Config->new({ %$own_option, 
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_argv;
  return $config;
}

return 1;
