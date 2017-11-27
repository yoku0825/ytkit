package Ytkit::BinlogGroupby;

########################################################################
# Copyright (C) 2014, 2017  yoku0825
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
use 5.010;

use constant DEFAULT_OPTION =>
{
  cell     => { alias => ["cell", "c"],  isa => [qw{s second 1s 10s m minute 1m 10m h hour 1h}], default => "10m" },
  group_by => { alias => ["group-by", "g"], default => "time" },
  output   => { alias => ["output", "o"], default => "tsv" },
  help     => { alias => ["help", "usage", "h"] },
};

sub new
{
  my ($class, $opt)= @_;

  my ($header_parser, $print_format)= set_parser($opt->{cell});
  return 0 unless $header_parser;

  my $self=
  {
    cell            => $opt->{cell},
    output          => $opt->{output},
    group_by        => sort_csv($opt->{group_by}),
    print_format    => $print_format,
    time_string     => undef,
    first_seen      => undef,
    last_seen       => undef,
    exec_time       => undef,
    header_parser   => $header_parser,
    count_hash      => undef,
    exec_time_hash  => undef,
    sbr_regex       => qr/^(insert|update|delete|replace)\s+(?:ignore\s+)?(?:(?:into|from)?\s+)?(\S+?)\s+/i,
    rbr_regex       => qr/^\#\#\#\s+(INSERT|UPDATE|DELETE)\s+(?:(?:INTO|FROM)?\s+)?(\S+)/,
  };

  bless $self => $class;
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
  ### parsing dml-line (only parse simple INSERT, UPDATE, DELETE, REPLACE)
  elsif ($line =~ $self->{sbr_regex} ||
         $line =~ $self->{rbr_regex})
  {
    my ($dml, $table)= (uc($1), lc($2));
    $table =~ s/`//g;
    if ($table =~ /([^\(]+)\(/)
    {
      $table= $1;
    }
    if ($self->{time_string} && $dml && $table)
    {
      given($self->{group_by})
      {
        when(["exec,statement,table,time"])
        {
          $self->{count_hash}->{$self->{time_string}}->{$table}->{$dml}->{$self->{exec_time}}++;
        };
        when(["all", "statement,table,time"])
        {
          $self->{count_hash}->{$self->{time_string}}->{$table}->{$dml}++;
          push(@{$self->{exec_time_hash}->{$self->{time_string}}->{$table}->{$dml}}, $self->{exec_time});
        };
        when(["table,time"])
        {
          $self->{count_hash}->{$self->{time_string}}->{$table}++;
          push(@{$self->{exec_time_hash}->{$self->{time_string}}->{$table}}, $self->{exec_time});
        };
        when(["time"])
        {
          $self->{count_hash}->{$self->{time_string}}++;
          push(@{$self->{exec_time_hash}->{$self->{time_string}}}, $self->{exec_time});
        };
        when(["table"])
        {
          $self->{count_hash}->{$table}++;
          push(@{$self->{exec_time_hash}->{$table}}, $self->{exec_time});
        };
        when(["statement"])
        {
          $self->{count_hash}->{$dml}++;
          push(@{$self->{exec_time_hash}->{$dml}}, $self->{exec_time});
        };
        when(["statement,time"])
        {
          $self->{count_hash}->{$self->{time_string}}->{$dml}++;
          push(@{$self->{exec_time_hash}->{$self->{time_string}}->{$dml}}, $self->{exec_time});
        };
        when(["statement,table"])
        {
          $self->{count_hash}->{$table}->{$dml}++;
          push(@{$self->{exec_time_hash}->{$table}->{$dml}}, $self->{exec_time});
        };
      };
        
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
         sprintf($self->{print_format}, $self->{last_seen}));

  my $count_hash    = $self->{count_hash};
  my $exec_time_hash= $self->{exec_time_hash};
  given($self->{group_by})
  {
    when(["table", "statement"])
    {
      ### Only have 1 element.
      foreach my $element (sort(keys(%$count_hash)))
      {
        my $fixed_hash= fix_array(@{$exec_time_hash->{$element}});
        push(@ret, $self->build_line($element, $count_hash->{$element}, $fixed_hash->{mid}, $fixed_hash->{max}));
      }
    };
    when(["statement,table"])
    {
      ### Have 2 elements without "time"
      foreach my $table (sort(keys(%$count_hash)))
      {
        foreach my $dml (sort(keys(%{$count_hash->{$table}})))
        {
          my $fixed_hash= fix_array(@{$exec_time_hash->{$table}->{$dml}});
          push(@ret, $self->build_line($table, $dml, $count_hash->{$table}->{$dml}, $fixed_hash->{mid}, $fixed_hash->{max}));
        }
      }
    };

    ### else
    ### starting with "time"
    foreach my $time (sort(keys(%$count_hash)))
    {
      my $time_printable= sprintf($self->{print_format}, $time);
  
      given($self->{group_by})
      {
        when(["time"])
        {
          my $fixed_hash= fix_array(@{$exec_time_hash->{$time}});
          push(@ret, $self->build_line($time_printable, $count_hash->{$time}, $fixed_hash->{mid}, $fixed_hash->{max}));
        };
        when(["table,time", "statement,time"])
        {
          foreach my $element (sort(keys(%{$count_hash->{$time}})))
          {
            my $fixed_hash= fix_array(@{$exec_time_hash->{$time}->{$element}});
            push(@ret, $self->build_line($time_printable, $element, $count_hash->{$time}->{$element}, $fixed_hash->{mid}, $fixed_hash->{max}));
          }
        };
        when(["all", "statement,table,time"])
        {
          foreach my $table (sort(keys(%{$count_hash->{$time}})))
          {
            foreach my $dml (sort(keys(%{$count_hash->{$time}->{$table}})))
            {
              my $fixed_hash= fix_array(@{$exec_time_hash->{$time}->{$table}->{$dml}});
              push(@ret, $self->build_line($time_printable, $table, $dml, $count_hash->{$time}->{$table}->{$dml}, $fixed_hash->{mid}, $fixed_hash->{max}));
            }
          }
        };
      };
    }
  };

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

  return sprintf("%s\n", join($seperator, @args));
}

### set regexp for parsing datetime.
sub set_parser
{
  my ($cell)= @_;
  my ($parse, $format);

  given($cell)
  {
    when([qw/d day 1d/])
    {
      $parse = qr/^#(\d{2}\d{2}\d{2})\s+\d{1,2}:\d{2}:\d{2}.+exec_time=(\d+)/;
      $format= "%s";
    };
    when([qw/h hour 1h/])
    {
      $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}):\d{2}:\d{2}.+exec_time=(\d+)/;
      $format= "%s:00";
    };
    when([qw/m minute 1m/])
    {
      $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{2}):\d{2}.+exec_time=(\d+)/;
      $format= "%s";
    };
    when([qw/10m/])
    {
      $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{1})\d{1}:\d{2}.+exec_time=(\d+)/;
      $format= "%s0";
    };
    when([qw/10s/])
    {
      $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{2}:\d{1})\d{1}.+exec_time=(\d+)/;
      $format= "%s0";
    };
    when([qw/s second 1s/])
    {
      $parse = qr/^#(\d{2}\d{2}\d{2}\s+\d{1,2}:\d{2}:\d{2}).+exec_time=(\d+)/;
      $format= "%s";
    };
    default
    {
      $parse = undef;
      $format= undef;
    };
  }

  return ($parse, $format);
}

sub fix_array
{
  my @sorted= sort { $a <=> $b } @_;
  return {min => sprintf("min:%d", $sorted[0]),
          max => sprintf("max:%d", $sorted[$#sorted]),
          mid => sprintf("mid:%d", $sorted[int($#sorted / 2)])};

}

return 1;
