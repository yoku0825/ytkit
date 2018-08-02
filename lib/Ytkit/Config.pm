package Ytkit::Config;

########################################################################
# Copyright (C) 2017, 2018  yoku0825
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

use Exporter qw{import};
our @EXPORT= qw{options load_config version};
our $VERSION= '0.0.19';
our $CONNECT_OPTION=
{
  user     => { alias => ["u", "user"] },
  host     => { alias => ["h", "host"] },
  port     => { alias => ["P", "port"] },
  socket   => { alias => ["S", "socket"] },
  password => { alias => ["p", "password"] },
  timeout  => { alias => ["timeout"], default => 1 },
};
our $COMMON_OPTION=
{
  help        => { alias => ["help", "usage"] },
  version     => { alias => ["version", "V"], default => 0 },
  config_file => { alias => ["c", "config-file"] },
};

sub options
{
  my ($option_struct, @argv)= @_;
  my ($ret, @left_argv);
  $ret->{orig_argv}= [@argv];

  ### Normalize { parent => { child => { option_hash } } } style
  ###  to { parent_child => { option_hash } style.
  while (my ($parent_key, $child)= each(%$option_struct))
  {
    ### if already { parent => [alias1, alias2] } style, next.
    next if !(ref($child) eq "HASH");

    while (my ($child_key, $child_value)= each(%$child))
    {
      ### decide { parent => { child => { .. } } } style or { parent => { default => .., } } style.
      next if !(ref($child_value) eq "HASH");
      my $new_option= sprintf("%s_%s", $parent_key, $child_key);
      $option_struct->{$new_option}= $option_struct->{$parent_key}->{$child_key};
      delete($option_struct->{$parent_key}->{$child_key});

      ### Delete parent if all children are normalized.
      delete($option_struct->{$parent_key}) unless %{$option_struct->{$parent_key}};
    }
  }

  ### Change struct from { variable => [expression1, expression2] }
  ###   to { expression1 => variable, expression2 => variable, }
  my $alias_dict;
  foreach my $opt (keys(%$option_struct))
  {
    ### use option-name as variable-name if alias is not set.
    if (ref($option_struct->{$opt}) eq "ARRAY")
    {
      my $save= $option_struct->{$opt};
      delete($option_struct->{$opt});
      $option_struct->{$opt}->{alias}= $save;
    }
    $option_struct->{$opt}->{alias} ||= [$opt];
    foreach (@{$option_struct->{$opt}->{alias}})
    {
      ### Normalize "-" to "_" in key.
      s/-/_/g;
      $alias_dict->{$_}= $opt;

      ### Set default value.
      $ret->{$opt}= $option_struct->{$opt}->{default} if exists($option_struct->{$opt}->{default});
    }
  }

  ### Evaluate arguments
  while(@argv)
  {
    last unless defined($argv[0]);
    my ($key, $value);
    my $arg= shift(@argv);

    if ($arg =~ /^--([^=]+)=(.*)$/)
    {
      ### "--option=value" style.
      ($key, $value)= ($1, $2);
    }
    elsif ($arg =~ /^--([^\s]+)$/)
    {
      ### only "--option"(bool style) or first element in "--option value" style
      $key= $1;

      ### Decide bool style or "--option value" style.
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
        ### "--option value" style.
        $value= $next;
      }
    }
    elsif ($arg =~ /^-([^=-])=(.*)$/)
    {
      ### "-o=value" style
      ($key, $value)= ($1, $2);
    }
    elsif ($arg =~ /^-([^-])$/)
    {
      ### only "-o"(bool style) or first element in "-o value" style
      $key= $1;

      ### Decide bool style or "-o value" style.
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
        ### "-o value" style.
        $value= $next;
      }
    }
    elsif ($arg =~ /^-([^-])(.+)$/)
    {
      ### -oValue style.
      ($key, $value)= ($1, $2);
    }

    ### if any $key and $value is set, treated as argument and push into left_argv later.

    ### Normalize "-" to "_" in $key.
    $key =~ s/-/_/g if $key;

    ### Is known option?
    if ($key && $alias_dict->{$key})
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
      if (my $isa= $option_struct->{$alias_dict->{$key}}->{isa})
      {
        ### Validation.
        if (ref($isa) eq "ARRAY")
        {
          ### Array-style isa, grep
          $ret->{$alias_dict->{$key}}= ((grep {$value eq $_} @$isa) ? $value : undef);
        }
        elsif (ref($isa) eq "Regexp")
        {
          ### Evaluate regexp
          $ret->{$alias_dict->{$key}}= (($value =~ $isa) ? $value : undef);
        }
        elsif ($isa eq "noarg" || $isa eq "NOARG")
        {
          ### Force set 1 and return $value into @argv if isa eq "bool"
          $ret->{$alias_dict->{$key}}= 1;
          unshift(@argv, $value);
        }
        elsif ($isa eq "multi" || $isa eq "MULTI" || $isa eq "multiple" || $isa eq "MULTIPLE")
        {
          ### Multiple choise (store into array) option.
          ###  TODO: How to validate each value?
          push(@{$ret->{$alias_dict->{$key}}}, $value);
        }
        else
        {
          ### isa is non-supported type.
          $ret->{$alias_dict->{$key}}= undef;
        }
      }
      else
      {
        ### Don't need to validate.
        $ret->{$alias_dict->{$key}}= $value;
      }
    }
    else
    {
      ### Unknown option, left in argv.
      push(@left_argv, $arg);
    }
    ($key, $value)= ();
  } ### End while parsing argument.
  $ret->{left_argv}= [@left_argv];

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

    if ($line =~/^\s*$/)
    {
      ### Skip blank line
      next;
    }
    elsif ($line =~ /^\s*#/)
    {
      ### Comment when started by "#"
      next;
    }
    elsif ($line =~ /^\[([^\[\]]+)\]$/)
    {
      ### [section_name]
      $current_section= $1;
      next;
    }
    next if $current_section ne $config_section;

    if ($line =~/^([^\s=]+)\s*=\s*(.*)$/)
    {
      ### key=value
      my ($key, $value)= ($1, $2);

      ### Remove quote
      $value =~ s/^"([^"]*)"$/$1/;
      $value =~ s/^'([^']*)'$/$1/;
      
      ### Add $original_opt(options from command-line) only that doesn't exist.
      $opt->{$key} ||= $value;
    }
    else
    {
      ### Add $original_opt(options from command-line) only that doesn't exist.
      $opt->{$line} ||= 1;
    }
  }
  close($fh);

  return $opt;
}

sub version
{
  return $VERSION;
}

return 1;
