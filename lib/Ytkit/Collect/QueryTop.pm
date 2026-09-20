package Ytkit::Collect::QueryTop;

########################################################################
# Copyright (C) 2018, 2026  yoku0825
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
use JSON qw{ from_json };
use Term::ReadKey;
use base "Ytkit";
use Ytkit::Collect;

my $synopsis= q{ $ yt-querytop --host=mysql_host --port=mysql_port } .
              q{--user=mysql_account --password=mysql_password } .
              q{--interval=1  ### collect p_s.events_statements_summary_by_digest and top-like display every seconds };
my $script= sprintf("%s - Collect data from performance_schema.events_statements_summary_by_digest", $0);
my $description= << "EOS";
yt-querytop shows top-like display from performance_schema.events_statements_summary_by_digest
EOS
my $allow_extra_argv= 0;


my @collect_opt= qw{ --iteration=0 --delta=1 --delta-per-second=1 --innodb-metrics-enable=0
                     --query-latency-enable=1 --table-latency-enable=0 --table-size-enable=0
                     --show-grants-enable=0 --show-slave-enable=0 --show-status-enable=0
                     --show-variables-enable=0 --output=json };

my ($width, $height, $width_pixels, $height_pixels) = GetTerminalSize();

sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  ### If there's --help argument, not pass to the Ytkit::Collect
  my $self= { _config => $config,
              _collect => undef,
              %{$config->{result}}, };
  bless $self => $class;
  $self->handle_help;

  ### If there's not --help, create Ytkit::Collect instance.
  $self->{_collect}= Ytkit::Collect->new(@collect_opt, @orig_argv);

  return $self;
}

sub collect
{
  my ($self)= @_;
  return $self->{_collect};
}

sub one_cycle
{
  my ($self)= @_;

  ### Get "delta"-ed result as JSON
  my $json= $self->collect->print_query_latency();

  ### The very first time, $json is empty(because can't calc delta)
  if ($json)
  {
    my $digest_info= from_json($json)->{ps_digest_info};
    ### $digest_info=
    ### [
    ###   {
    ###     'last_update' => '2026-09-17 01:27:22',
    ###     'ipaddr' => 'localhost',
    ###     'port' => 3306,
    ###     'sum_timer_wait' => '410057000/s',
    ###     'schema_name.digest_text' => 'xxx',
    ###     'count_star' => '1/s'
    ###   },
    ###   {
    ###     'count_star' => '2/s',
    ###     'schema_name.digest_text' => 'NULL.SELECT ?',
    ###     'sum_timer_wait' => '208349000/s',
    ###     'port' => 3306,
    ###     'ipaddr' => 'localhost',
    ###     'last_update' => '2026-09-17 01:27:22'
    ###   }
    ### ];

    my $buff;
    foreach (@$digest_info)
    {
      ### Trim "xxx/s"
      my ($count_star)= $_->{count_star} =~ /(\d+)/;
      my ($timer_wait_diff_pico)= $_->{sum_timer_wait} =~ /(\d+)/;

      ### Translate picosecond to second
      my $timer_wait_diff_sec = sprintf("%0.4f", $timer_wait_diff_pico / 1_000_000_000_000);

      ### Separate schema and digest_text from "ddd.sql_digest" 
      my ($schema, $sql) = $_->{"schema_name.digest_text"} =~ /([^\.]+)\.(.+)/;

      my $hash = { schema => $schema,
                   sql => $sql,
                   timer_wait => $timer_wait_diff_sec, };
      if (defined($buff->{$count_star}))
      {
        push(@{$buff->{$count_star}}, $hash);
      }
      else
      {
        $buff->{$count_star}= [$hash];
      }
    }
    $self->collect->clear_cache();
    return $self->sprint_result($buff);
  }
}

sub sprint_result
{
  my ($self, $buff)= @_;

  my @ret;
  ### ORDER BY count_star DESC
  foreach my $count_star (sort { $b <=> $a } (keys(%$buff)))
  {
    foreach (@{$buff->{$count_star}})
    {
      my $line= sprintf("%d\t%0.4f\t%0.4f\t%s\t%s",
                        $count_star,
                        $_->{timer_wait},
                        $_->{timer_wait} / ($count_star ? $count_star : 1),   ### Second/Query
                        $_->{schema},
                        $_->{sql});
      ### Trim if not --verbose
      push(@ret, substr($line, 0, $self->{verbose} ? -1 : $width - int($width / 10)));
    }
  }
  return \@ret;
}

sub _config
{
  my $program_option=
  {
    interval       => { alias   => ["interval", "i", "sleep"],
                        default => 1,
                        text => "Sleep seconds during each collecting iterations." },
    idle_print => { alias => ["idle_print", "idle", "H"],
                    default => 1,
                    isa     => [0, 1],
                    text    => "Print even diff-ed value is zero." },
    batch => { alias => ["b", "batch"],
               default => 0,
               noarg => 1,
               text => "Don't clear terminal" },
  };
  my $config= Ytkit::Config->new({ %$program_option, 
                                   %$Ytkit::Config::CONNECT_OPTION,
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_argv;
  return $config;
}

return 1;
