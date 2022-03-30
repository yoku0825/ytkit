package Ytkit::BinlogGroupby;

########################################################################
# Copyright (C) 2014, 2021  yoku0825
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
use Ytkit::GroupbyHelper;

use constant
{
  SBR_REGEX => qr/^(insert|update|delete|replace)\s+
                   (?:(?:ignore|low_priority|delayed|high_priority)\s+)?
                   (?:(?:into|from)?\s+)?
                   (\S+?)\s+/ix,
  RBR_REGEX => qr/^\#\#\#\s+(INSERT|UPDATE|DELETE)\s+(?:(?:INTO|FROM)?\s+)?(\S+)/,
};

my $synopsis= q{ $ mysqlbinlog -vv /path/to/binlog | yt-binlog-groupby [options] };
my $script= sprintf("%s - MySQL binlog aggregator cli", $0);
my $description= << "EOS";
yt-binlog-groupby aggregates stdout of mysqlbinlog.
EOS
my $allow_extra_arvg= 0;
### $config is mutable, should be move into "new" (but testcase is wrong)


sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self=
  {
    _config => $config,
    %{$config->{result}},
  };
  bless $self => $class;
  $self->handle_help;

  $self->set_parser;
  $self->decide_counter;
  return 0 if !($self->{header_parser}) || !($self->{print_format});

  return $self;
}

sub decide_counter
{
  my ($self)= @_;

  my $need_full_sort;
  ($need_full_sort, $self->{_counter})= Ytkit::GroupbyHelper::make_group_by_class($self->{_config}->{result}->{group_by});

  if ($need_full_sort)
  {
    ### Force set "--sort", see https://github.com/yoku0825/ytkit/issues/23
    $self->{sort}= 1;
    _debugf("Truning on --sort for --group-by=%s", $self->{_config}->{result}->{group_by});
  }
}

sub parse
{
  my ($self, $line)= @_;

  ### parsing datetime from comment line.
  if ($line =~ /$self->{header_parser}/)
  {
    ### This is header-comment of each event.
    $self->{time_string}  = sprintf($self->{print_format}, $1);
    $self->{first_seen} ||= $1;
    $self->{last_seen}    = $1;
    $self->{exec_time}    = sprintf("exec_time:%d", $2);
  }
  ### USE statement
  elsif ($line =~ /^use\s([^\/]+)/)
  {
    $self->{current_schema}= $1;
    $self->{current_schema} =~ s/`//g;
  }
  ### parsing dml-line (only parse simple INSERT, UPDATE, DELETE, REPLACE)
  elsif ($line =~ SBR_REGEX || $line =~ RBR_REGEX)
  {
    _debugf($line);
    my ($dml, $table)= (uc($1), lc($2));
    $table =~ s/`//g;

    if ($table =~ /([^\(]+)\(/)
    {
      $table= $1;
    }

    if ($table !~ /\./)
    {
      $table= sprintf("%s.%s", $self->{current_schema}, $table) if $self->{current_schema};
    }
    my $event= { time_string => $self->{time_string},
                 table       => $table,
                 statement   => $dml,
                 exec_time   => $self->{exec_time} };

    _debugf({ %$event, previous_time => $self->{previous_time} });

    if ($self->{time_string} && $dml && $table)
    {
      if (!($self->{sort}) && $self->{previous_time})
      {
        if ($self->{previous_time} ne $self->{time_string})
        {
          my $buff= $self->{_counter}->result;
          $self->{_counter}->clear;
          $self->{previous_time}= $self->{time_string};
          $self->{_counter}->increment($event);
          return $buff;
        }
      }
      else
      {
        $self->{previous_time}= $self->{time_string};
      }
      $self->{_counter}->increment($event);
    }
  }
  return 0;
}

sub output
{
  my ($self)= @_;
  my @ret= ();

  _infof("binlog entries between %s and %s\n",
         _sprintf($self->{print_format}, $self->{first_seen} // ""),
         _sprintf($self->{print_format}, $self->{last_seen} // ""));

  return $self->{_counter}->result;
}

### set regexp for parsing datetime.
sub set_parser
{
  my ($self)= @_;
  my ($parse, $format);
  my $cell= $self->{cell};

  if (grep { $cell eq $_ } qw{d day 1d})
  {
    $parse = qr/^#(\d{2}\d{2}\d{2})\s+\d{1,2}:\d{2}:\d{2}.+exec_time=(\d+)/;
    $format= "%s";
  }
  elsif (grep { $cell eq $_ } qw{h hour 1h})
  {
    $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}):\d{2}:\d{2}.+exec_time=(\d+)/;
    $format= "%s:00";
  }
  elsif (grep { $cell eq $_ } qw{m minute 1m})
  {
    $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{2}):\d{2}.+exec_time=(\d+)/;
    $format= "%s";
  }
  elsif (grep { $cell eq $_ } qw{10m})
  {
    $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{1})\d{1}:\d{2}.+exec_time=(\d+)/;
    $format= "%s0";
  }
  elsif (grep { $cell eq $_ } qw{10s})
  {
    $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{2}:\d{1})\d{1}.+exec_time=(\d+)/;
    $format= "%s0";
  }
  elsif (grep { $cell eq $_ } qw{s second 1s})
  {
    $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{2}:\d{2}).+exec_time=(\d+)/;
    $format= "%s";
  }
  else
  {
    $parse = undef;
    $format= undef;
  }
  _debugf("Parse REGEXP: %s", $parse);
  $self->{header_parser}= $parse;
  $self->{print_format} = $format;
}

sub _config
{
  my $yt_binloggroupby_option=
  {
    cell     => { alias => ["cell", "c"],
                  isa   => [qw{s second 1s 10s m minute 1m 10m h hour 1h d 1d}],
                  default => "10m",
                  text  => "Unit of aggregation." },
    group_by => { alias => ["group-by", "g"],
                  default => "time",
                  text  => qq{Part of aggregation.\n} .
                           qq{  "time", "table", "statement", "time,table", "time,statement",\n} .
                           qq{  "table,statement", "all", "time,table,statement" (same as "all")\n} .
                           qq{  "all,exec", "exec,time,table,statement" (same as "all,exec")} },
    output   => { alias => ["output", "o"],
                  isa   => ["csv", "tsv"],
                  default => "tsv",
                  text  => "Output type" },
    sort     => { alias => ["sort", "full-sort", "complete-sort"],
                  noarg => 1,
                  text => "When set this, yt-binlog-groupby sorts *after* calculate group_by(it's slow)\n" .
                          "This should be on if STDIN(mysqlbinlog) has *NOT* been queued up." },
  };
  my $config= Ytkit::Config->new({ %$yt_binloggroupby_option, 
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_arvg;
  return $config;
} 


return 1;
