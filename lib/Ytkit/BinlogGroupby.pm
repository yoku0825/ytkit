package Ytkit::BinlogGroupby;

########################################################################
# Copyright (C) 2014, 2018  yoku0825
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

  my $self= { _config => $config,
              %{$config->{result}} };
  bless $self => $class;
  $self->handle_help;

  $self->{group_by}= sort_csv($self->{group_by});
  $self->set_parser;
  return 0 if !($self->{header_parser}) || !($self->{print_format});

  return $self;
}

sub parse
{
  my ($self, $line)= @_;

  ### parsing datetime from comment line.
  if ($line =~ /$self->{header_parser}/)
  {
    ### This is header-comment of each event.
    $self->{time_string}  = $1;
    $self->{first_seen} ||= $1;
    $self->{last_seen}    = $1;
    $self->{exec_time}    = $2;
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

    if ($self->{time_string} && $dml && $table)
    {
      if ($self->compare_groupby("exec,statement,table,time", "all,exec"))
      {
        $self->{count_hash}->{$self->{time_string}}->{$table}->{$dml}->{$self->{exec_time}}++;
      }
      elsif ($self->compare_groupby("all", "statement,table,time"))
      {
        $self->{count_hash}->{$self->{time_string}}->{$table}->{$dml}++;
        push(@{$self->{exec_time_hash}->{$self->{time_string}}->{$table}->{$dml}}, $self->{exec_time});
      }
      elsif ($self->compare_groupby("table,time"))
      {
        $self->{count_hash}->{$self->{time_string}}->{$table}++;
        push(@{$self->{exec_time_hash}->{$self->{time_string}}->{$table}}, $self->{exec_time});
      }
      elsif ($self->compare_groupby("time"))
      {
        $self->{count_hash}->{$self->{time_string}}++;
        push(@{$self->{exec_time_hash}->{$self->{time_string}}}, $self->{exec_time});
      }
      elsif ($self->compare_groupby("table"))
      {
        $self->{count_hash}->{$table}++;
        push(@{$self->{exec_time_hash}->{$table}}, $self->{exec_time});
      }
      elsif ($self->compare_groupby("statement"))
      {
        $self->{count_hash}->{$dml}++;
        push(@{$self->{exec_time_hash}->{$dml}}, $self->{exec_time});
      }
      elsif ($self->compare_groupby("statement,time"))
      {
        $self->{count_hash}->{$self->{time_string}}->{$dml}++;
        push(@{$self->{exec_time_hash}->{$self->{time_string}}->{$dml}}, $self->{exec_time});
      }
      elsif ($self->compare_groupby("statement,table"))
      {
        $self->{count_hash}->{$table}->{$dml}++;
        push(@{$self->{exec_time_hash}->{$table}->{$dml}}, $self->{exec_time});
      }

      $self->{time_string}= $self->{exec_time}= $dml= $table= "";
    }
  }
}

sub output
{
  my ($self)= @_;
  my @ret= ();

  printf("binlog entries between %s and %s\n",
         sprintf($self->{print_format}, $self->{first_seen}),
         sprintf($self->{print_format}, $self->{last_seen})) if $self->{verbose};

  my $count_hash    = $self->{count_hash};
  my $exec_time_hash= $self->{exec_time_hash};

  if ($self->compare_groupby("table", "statement"))
  {
    ### Only have 1 element.
    foreach my $element (sort(keys(%$count_hash)))
    {
      push(@ret, $self->build_line($element, $count_hash->{$element},
                                   $exec_time_hash->{$element}));
    }
  }
  elsif ($self->compare_groupby("statement,table"))
  {
    ### Have 2 elements without "time"
    foreach my $table (sort(keys(%$count_hash)))
    {
      foreach my $dml (sort(keys(%{$count_hash->{$table}})))
      {
        push(@ret, $self->build_line($table, $dml, $count_hash->{$table}->{$dml},
                                     $exec_time_hash->{$table}->{$dml}));
      }
    }
  }
  else
  {
    ### starting with "time"
    foreach my $time (sort(keys(%$count_hash)))
    {
      my $time_printable= sprintf($self->{print_format}, $time);
  
      if ($self->compare_groupby("time"))
      {
        push(@ret, $self->build_line($time_printable, $count_hash->{$time},
                                     $exec_time_hash->{$time}));
      }
      elsif ($self->compare_groupby("table,time", "statement,time"))
      {
        foreach my $element (sort(keys(%{$count_hash->{$time}})))
        {
          push(@ret, $self->build_line($time_printable, $element,
                                       $count_hash->{$time}->{$element},
                                       $exec_time_hash->{$time}->{$element}));
        }
      }
      elsif ($self->compare_groupby("all", "statement,table,time"))
      {
        foreach my $table (sort(keys(%{$count_hash->{$time}})))
        {
          foreach my $dml (sort(keys(%{$count_hash->{$time}->{$table}})))
          {
            push(@ret, $self->build_line($time_printable, $table, $dml,
                                         $count_hash->{$time}->{$table}->{$dml},
                                         $exec_time_hash->{$time}->{$table}->{$dml}));
          }
        }
      }
      elsif ($self->compare_groupby("all,exec", "exec,statement,table,time"))
      {
        foreach my $table (sort(keys(%{$count_hash->{$time}})))
        {
          foreach my $dml (sort(keys(%{$count_hash->{$time}->{$table}})))
          {
            foreach my $exec (sort(keys(%{$count_hash->{$time}->{$table}->{$dml}})))
            {
              push(@ret, $self->build_line($time_printable, $table, $dml,
                                           "exec_time:" . $exec,
                                           $count_hash->{$time}->{$table}->{$dml}->{$exec}, {}));
            }
          }
        }
      }
    }
  }

  return \@ret;
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

sub compare_csv
{
  my ($csv1, $csv2)= @_;
  return 0 if !(defined($csv1)) || !(defined($csv2));

  $csv1= sort_csv($csv1);
  $csv2= sort_csv($csv2);
  return $csv1 eq $csv2;
}

sub compare_groupby
{
  my ($self, @groupby_list)= @_;
  
  foreach (@groupby_list)
  {
    return 1 if compare_csv($self->{group_by}, $_);
  }
  return 0;
}

sub _config
{
  my $yt_binloggroupby_option=
  {
    cell     => { alias => ["cell", "c"],
                  isa   => [qw{s second 1s 10s m minute 1m 10m h hour 1h}],
                  default => "10m",
                  text  => "Unit of aggregation." },
    group_by => { alias => ["group-by", "g"],
                  default => "time",
                  text  => qq{Part of aggregation.\n} .
                           qq{  "time" [default], "table", "statement", "time,table", "time,statement",\n} .
                           qq{  "table,statement", "all", "time,table,statement" (same as "all")\n} .
                           qq{  "all,exec", "exec,time,table,statement" (same as "all,exec")} },
    output   => { alias => ["output", "o"],
                  isa   => ["csv", "tsv"],
                  default => "tsv",
                  text  => "Output type" },
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
