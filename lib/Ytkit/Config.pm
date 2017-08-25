package Ytkit::Config;

########################################################################
# Copyright (C) 2017  yoku0825
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

use Exporter qw{import};
our @EXPORT= qw{options load_config};

sub options
{
  my ($option_struct, @argv)= @_;

  ### Change struct from { variable => [expression1 expression2] }
  ###   to { expression1 => variable, expression2 => variable, }
  my $evaluate_struct;
  foreach my $opt (keys(%$option_struct))
  {
    foreach (@{$option_struct->{$opt}})
    {
      $evaluate_struct->{$_}= $opt;
    }
  }

  ### Evaluate arguments
  my ($ret, @left_argv);
  while(@argv)
  {
    my ($key, $value);
    my $arg= shift(@argv);
    given($arg)
    {
      ### --option=value style.
      when(/^--([^=]+)=(.*)$/)
      {
        ($key, $value)= ($1, $2);
      };

      ### only --option(bool style) or first element in --option value style
      when(/^--([^\s]+)$/)
      {
        $key= $1;

        ### Decide bool style or --option value style.
        my $next= shift(@argv);

        ### Next element doesn't exists(last part of argv is evaluating now) or
        ### next element starts with "-", current part is bool style option.
        ###   TODO: How about a negative number?
        if (!($next) || $next =~ /^-/)
        {
          ### bool style.
          $value= 1;

          ### Write back next element.
          unshift(@argv, $next);
        }
        else
        {
          ### --option value style.
          $value= $next;
        }
      };

      ### -o=value style
      when(/^-([^=-])=(.*)$/)
      {
        ($key, $value)= ($1, $2);
      };

      ### only -o(bool style) or first element in -o value style
      when(/^-([^-])$/)
      {
        $key= $1;

        ### Decide bool style or -o value style.
        my $next= shift(@argv);

        ### Next element doesn't exists(last part of argv is evaluating now) or
        ### next element starts with "-", current part is bool style option.
        ###   TODO: How about a negative number?
        if (!($next) || $next =~ /^-/)
        {
          ### bool style.
          $value= 1;

          ### Write back next element.
          unshift(@argv, $next);
        }
        else
        {
          ### --option value style.
          $value= $next;
        }
      };

      ### -oValue style.
      when(/^-([^-])(.+)$/)
      {
        ($key, $value)= ($1, $2);
      };

      ### if any $key and $value is set, treated as argument and push into left_argv later.
    };

    ### Is known option?
    if ($key && $evaluate_struct->{$key})
    {
      ### Remove quote
      $value =~ s/^"([^"]*)"$/$1/;
      $value =~ s/^'([^']*)'$/$1/;

      $ret->{$evaluate_struct->{$key}}= $value;
    }
    else
    {
      ### Unknown option.
      push(@left_argv, $arg);
    }
    ($key, $value)= ();
  } ### End while.

  return $ret, @left_argv;
}

sub load_config
{
  my ($opt, $config_file, $config_section)= @_;

  return 0 unless -r $config_file;
  open(my $fh, "<", $config_file);

  my $current_section= "";
  while (my $line= <$fh>)
  {
    chomp($line);

    given($line)
    {
      ### Skip blank line
      when(/^\s*$/)
      {
        next;
      };

      ### [section_name]
      when(/^\[([^\[\]]+)\]$/)
      {
        $current_section= $1;
        next;
      };

      next if $current_section ne $config_section;

      ### key=value
      when(/^([^\s=]+)\s*=\s*(.*)$/)
      {
        my ($key, $value)= ($1, $2);

        ### Remove quote
        $value =~ s/^"([^"]*)"$/$1/;
        $value =~ s/^'([^']*)'$/$1/;
        
        ### Add $original_opt(options from command-line) only that doesn't exist.
        $opt->{$key} ||= $value;
      };

      ### bool
      default
      {
        ### Add $original_opt(options from command-line) only that doesn't exist.
        $opt->{$line} ||= 1;
      };
    };
  }

  return $opt;
}

return 1;
