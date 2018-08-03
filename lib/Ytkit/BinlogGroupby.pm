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

use Ytkit::Config;

my $default_option=
{
  cell     => { alias => ["cell", "c"],
                isa   => [qw{s second 1s 10s m minute 1m 10m h hour 1h}],
                default => "10m" },
  group_by => { alias => ["group-by", "g"],
                default => "time" },
  output   => { alias => ["output", "o"],
                default => "tsv" },
  help     => { alias => ["help", "usage", "h"] },
  verbose  => { alias => ["verbose", "v"], default => 0 },
  version  => { alias => ["version", "V"], default => 0 },
};
$default_option= { %$default_option, %$Ytkit::Config::COMMON_OPTION };

sub new
{
  my ($class, @orig_argv)= @_;
  my ($opt, @argv)= options($default_option, @orig_argv);
  return -255 if $opt->{help};
  return -254 if $opt->{version};
  return -253 if @argv;

  my ($header_parser, $print_format)= set_parser($opt->{cell});
  return 0 unless $header_parser;

  my $self=
  {
    cell            => $opt->{cell},
    output          => $opt->{output},
    print_header    => $opt->{print_header},
    group_by        => sort_csv($opt->{group_by}),
    print_format    => $print_format,
    time_string     => undef,
    first_seen      => undef,
    last_seen       => undef,
    exec_time       => undef,
    current_schema  => undef,
    header_parser   => $header_parser,
    count_hash      => undef,
    exec_time_hash  => undef,
    verbose         => $opt->{verbose},
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
  ### USE statement
  elsif ($line =~ /^use\s([^\/]+)/)
  {
    $self->{current_schema}= $1;
    $self->{current_schema} =~ s/`//g;
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
         sprintf($self->{print_format}, $self->{last_seen})) if $self->{print_header};

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
  my ($cell)= @_;
  my ($parse, $format);

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

  return ($parse, $format);
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

return 1;
