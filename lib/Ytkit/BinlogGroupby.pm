package Ytkit::BinlogGroupby;

########################################################################
# Copyright (C) 2014, 2019  yoku0825
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
use Carp qw{carp croak};

use constant
{
  SBR_REGEX => qr/^(insert|update|delete|replace)\s+(?:ignore\s+)?(?:(?:into|from)?\s+)?(\S+?)\s+/i,
  RBR_REGEX => qr/^\#\#\#\s+(INSERT|UPDATE|DELETE)\s+(?:(?:INTO|FROM)?\s+)?(\S+)/,
};

my $synopsis= q{ $ mysqlbinlog -vv /path/to/binlog | yt-binlog-groupby [options] };
my $script= sprintf("%s - MySQL binlog aggregator cli", $0);
my $description= << "EOS";
yt-binlog-groupby aggregates stdout of mysqlbinlog.
EOS
my $allow_extra_arvg= 0;
my $config= _config();


sub new
{
  my ($class, @orig_argv)= @_;
  $config->parse_argv(@orig_argv);

  my $self=
  {
    _config => $config,
    %{$config->{result}},
    _counter => _decide_counter($config->{result}->{group_by}),
  };
  bless $self => $class;
  $self->handle_help;

  $self->set_parser;
  return 0 if !($self->{header_parser}) || !($self->{print_format});

  return $self;
}

sub _decide_counter
{
  my ($group_by)= @_;
  $group_by= sort_csv($group_by);

  if ($group_by eq "table")
  {
    return Ytkit::BinlogGroupby::Groupby_Table->new;
  }
  elsif ($group_by eq "statement")
  {
    return Ytkit::BinlogGroupby::Groupby_Statement->new;
  }
  elsif ($group_by eq "time")
  {
    return Ytkit::BinlogGroupby::Groupby_Time->new;
  }
  elsif ($group_by eq "statement,time")
  {
    return Ytkit::BinlogGroupby::Groupby_TimeStatement->new;
  }
  elsif ($group_by eq "statement,table")
  {
    return Ytkit::BinlogGroupby::Groupby_TableStatement->new;
  }
  elsif ($group_by eq "table,time")
  {
    return Ytkit::BinlogGroupby::Groupby_TimeTable->new;
  }
  elsif ($group_by eq "all" || $group_by eq "statement,table,time")
  {
    return Ytkit::BinlogGroupby::Groupby_TimeTableStatement->new;
  }
  elsif ($group_by eq "all,exec" || $group_by eq "exec,statement,table,time")
  {
    return Ytkit::BinlogGroupby::Groupby_TimeTableStatementExec->new;
  }
  else
  {
    return undef;
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

    if ($self->{time_string} && $dml && $table)
    {
      if (!($self->{sort}) && $self->{previous_time})
      {
        if ($self->{previous_time} ne $self->{time_string})
        {
          my $buff= $self->{_counter}->result;
          $self->{_counter}->clear;
          $self->{previous_time}= $self->{time_string};
          return $buff;
        }
      }
      else
      {
        $self->{previous_time}= $self->{time_string};
      }
      $self->{_counter}->increment($event);

      $self->{time_string}= $self->{exec_time}= $dml= $table= "";
    }
  }
  return 0;
}

sub output
{
  my ($self)= @_;
  my @ret= ();

  printf("binlog entries between %s and %s\n",
         sprintf($self->{print_format}, $self->{first_seen}),
         sprintf($self->{print_format}, $self->{last_seen})) if $self->{verbose};

  return $self->{_counter}->result;
}

sub sort_csv
{
  my ($csv)= @_;
  return join(",", sort(split(/,/, $csv)));
}

sub build_line
{
  my ($self, @args)= @_;
  my $seperator= $self->{output} eq "tsv" ? "\t" : $self->{output} eq "csv" ? "," : "\n";

  ### last element of @args is exec_time_hash_element
  my $exec_time_hash_element= pop(@args);

  if ($exec_time_hash_element && $self->{verbose})
  {
    my @sorted= sort { $a <=> $b } @$exec_time_hash_element;
    push(@args, sprintf("mid:%d", $sorted[int($#sorted / 2)]));
    push(@args, sprintf("max:%d", $sorted[$#sorted]));
  }
  return sprintf("%s\n", join($seperator, @args));
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

package Ytkit::BinlogGroupby::Groupby_Base;

use strict;
use warnings;
use utf8;

sub new
{
  my ($class)= @_;
  return bless {} => $class;
}

sub clear
{
  my ($self)= @_;
  foreach (keys(%$self))
  {
    delete($self->{$_})
  }
}

sub increment
{
  ### This should be implemented in each class.
  ...;
}

sub _print_n_element
{
  my ($hash, $n)= @_;
  my @ret;

  if ($n == 1)
  {
    foreach (sort(keys(%$hash)))
    {
      push(@ret, sprintf("%s\t%d\n", $_, $hash->{$_}));
    }
  }
  else
  {
    foreach (sort(keys(%$hash)))
    {
      foreach my $buff (@{_print_n_element($hash->{$_}, $n - 1)})
      {
        push(@ret, sprintf("%s\t%s", $_, $buff));
      }
    }
  }
  return \@ret;
}

package Ytkit::BinlogGroupby::Groupby_Time;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(1);
}
 
package Ytkit::BinlogGroupby::Groupby_Table;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{table}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(1);
}
 
package Ytkit::BinlogGroupby::Groupby_Statement;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(1);
}
 
package Ytkit::BinlogGroupby::Groupby_TimeStatement;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(2);
}

package Ytkit::BinlogGroupby::Groupby_TimeTable;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{table}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(2);
}

package Ytkit::BinlogGroupby::Groupby_TableStatement;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{table}}->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(2);
}

package Ytkit::BinlogGroupby::Groupby_TimeTableStatement;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(3);
}
 
package Ytkit::BinlogGroupby::Groupby_TimeTableStatementExec;

use base "Ytkit::BinlogGroupby::Groupby_Base";

sub increment
{
  my ($self, $event)= @_;
  $self->{$event->{time_string}}->{$event->{table}}->{$event->{statement}}->{$event->{exec_time}}++;
}

sub result
{
  my ($self)= @_;
  $self->_print_n_element(4);
}
 

return 1;
