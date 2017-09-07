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
  my ($ret, @left_argv);

  ### Change struct from { variable => [expression1, expression2] }
  ###   to { expression1 => variable, expression2 => variable, }
  my $evaluate_struct;
  foreach my $opt (keys(%$option_struct))
  {
    ### use option-name as variable-name if alias is not set.
    $option_struct->{$opt}->{alias} ||= [$opt];
    foreach (@{$option_struct->{$opt}->{alias}})
    {
      ### Normalize "-" to "_" in key.
      s/-/_/g;
      $evaluate_struct->{$_}= $opt;

      ### Set default value.
      $ret->{$opt}= $option_struct->{$opt}->{default} if $option_struct->{$opt}->{default};
    }
  }

  ### Evaluate arguments
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

    ### Normalize "-" to "_" in $key.
    $key =~ s/-/_/g if $key;

    ### Is known option?
    if ($key && $evaluate_struct->{$key})
    {
      if ($value =~ /^"([^"]*)/)
      {
        ### Start with doublequote should be ended with doublequote.
        while (!($value =~ /"$/))
        {
          $value .= " " . shift(@argv);
        }
        ### Trim doublequote.
        $value =~ s/^"([^"]*)"$/$1/;
      }
      elsif ($value =~ /^'([^']*)/)
      {
        ### Start with singlequote should be ended with singlequote.
        while (!($value =~ /'$/))
        {
          $value .= " " . shift(@argv);
        }
        ### Trim singlequote
        $value =~ s/^'([^']*)'$/$1/;
      }

      ### isa is set?
      if (my $isa= $option_struct->{$evaluate_struct->{$key}}->{isa})
      {
        ### Validation.
        if (ref($isa) eq "ARRAY")
        {
          ### Array-style isa, grep
          $ret->{$evaluate_struct->{$key}}= ((grep {$value eq $_} @$isa) ? $value : undef);
        }
        elsif (ref($isa) eq "Regexp")
        {
          ### Evaluate regexp
          $ret->{$evaluate_struct->{$key}}= (($value =~ $isa) ? $value : undef);
        }
        else
        {
          ### isa is non-supported type.
          $ret->{$evaluate_struct->{$key}}= undef;
        }
      }
      else
      {
        ### Don't need to validate.
        $ret->{$evaluate_struct->{$key}}= $value;
      }
    }
    else
    {
      ### Unknown option, left in argv.
      push(@left_argv, $arg);
    }
    ($key, $value)= ();
  } ### End while parsing argument.

  return $ret, @left_argv;
}

sub load_config
{
  my ($opt, $config_file, $config_section)= @_;

  ### return as is.
  return $opt unless -r $config_file;


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
  close($fh);

  return $opt;
}

return 1;
