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
our $VERSION= '0.1.0';
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
  my ($definition, @argv)= @_;
  my ($buffer, $dict, @left_argv);
  #$buffer->{orig_argv}= [@argv];

$DB::single= 1 if grep { $_ =~ /parent-child1/ } @argv;
  ### Normalize { parent => { child => { option_hash } } } style
  ###  to { parent_child => { option_hash } style.
  while (my ($parent_key, $child)= each(%$definition))
  {
    my $option;
    if (ref($child) eq "HASH")
    {
      ### Empty-hash "{ parent_key => {} }" comes here.
      $child->{alias}= [$parent_key] if !(%$child);

      while (my ($child_key, $child_value)= each(%$child))
      {
        if (ref($child_value) eq "HASH")
        {
          ### { parent_key => { child_key => { default => .., } } } style.
          my $option_name= sprintf("%s_%s", $parent_key, $child_key);

          ### If alias is not set, its name set to alias
          $child_value->{alias} ||= [$option_name];
          $option= Ytkit::Config::Option->new($child_value);
          $buffer->{$parent_key}->{$child_key}= $option;
        }
        else
        {
          ### { parent_key => { default => .., } } style.
          ### If alias is not set, its name set to alias
          $child->{alias} ||= [$parent_key];
          $option= Ytkit::Config::Option->new($child);
          $buffer->{$parent_key}= $option;
        }

        ### Making dict should be in loop.
        foreach my $alias (@{$option->{alias}})
        {
          $dict->{$alias}= $option;
        }
      }
    }
    else
    {
      ### Maybe { parent => ["aliases"] } style.
      $option= Ytkit::Config::Option->new({ alias => [@$child] });
      $buffer->{$parent_key}= $option;
    }

    foreach my $alias (@{$option->{alias}})
    {
      $dict->{$alias}= $option;
    }
  }

  ### Evaluate arguments
  while(@argv)
  {
    last unless defined($argv[0]);
    my $arg= shift(@argv);

    my ($key, $value)= _simple_parse($arg);

    if (defined($value))
    {
      ### ok
    }
    else
    {
      if ($arg =~ /^--([^\s]+)$/)
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
      $key =~ s/-/_/g if $key;
    }

    ### if any $key and $value is not set, treated as argument and push into left_argv later.

    ### Is known option?
    if ($key && $dict->{$key})
    {
      if ($dict->{$key}->{noarg})
      {
        $dict->{$key}->set_value(1);
        ### Force set 1 and return $value into @argv if isa eq "bool"
        unshift(@argv, $value);
      }
      else
      {
        while ($dict->{$key}->set_value($value) == 0)
        {
          ### if $value was quoted and include space, need more argument.
          $value .= " " . shift(@argv);
        }
      }
    }
    else
    {
      ### Unknown option, left in argv.
      push(@left_argv, $arg);
    }
    ($key, $value)= ();
  } ### End while parsing argument.
  #$buffer->{left_argv}= [@left_argv];

  my $ret;
  while (my ($key, $value)= each(%$buffer))
  {
    if (ref($value) eq "Ytkit::Config::Option")
    {
      $ret->{$key}= $value->{value};
    }
    else
    {
      ### Recursive
      while (my ($child_key, $child_value)= each(%$value))
      {
        $ret->{$key}->{$child_key}= $child_value->{value};
      }
    }
  }

  return $ret, @left_argv;
}

sub _simple_parse
{
  my ($arg)= @_;
  my ($key, $value);

  if ($arg =~ /^--([^=]+)=(.*)$/)
  {
    ### "--option=value" style.
    ($key, $value)= ($1, $2);
  }
  elsif ($arg =~ /^--([^\s]+)$/)
  {
    ### Can't decide simply.
    ### Should decide bool style or "--option value" style.
    return undef;
  }
  elsif ($arg =~ /^-([^-])$/)
  {
    ### Can't decide simply.
    ### Should decide bool style or "-o value" style.
    return undef;
  }
  elsif ($arg =~ /^-([^=-])=(.*)$/)
  {
    ### "-o=value" style
    ($key, $value)= ($1, $2);
  }
  elsif ($arg =~ /^-([^-])(.+)$/)
  {
    ### -oValue style.
    ($key, $value)= ($1, $2);
  }
  else
  {
    return undef;
  }

  ### Normalize "-" to "_"
  $key =~ s/-/_/g;
  return ($key, $value);
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


package Ytkit::Config::Option;

use strict;
use warnings;
use utf8;
use Carp qw{carp};

sub new
{
  my ($class, $opt)= @_;
  my $self;

  if (ref($opt) eq "ARRAY")
  {
    ### { param_name => ["aliases"] } style.
    $self->{alias}= $opt;
  }
  elsif (ref($opt) eq "HASH")
  {
    $self=
    {
      multi   => $opt->{multi} // undef,
      noarg   => $opt->{noarg} // undef,
      isa     => $opt->{isa} // undef,
      value   => $opt->{multi} ? 
                   $opt->{default} ? [$opt->{default}] : [] :
                   $opt->{default} // undef,
      alias   => _normalize_hyphen($opt->{alias}) // undef,
    }
  }

  bless $self => $class;
  return $self;
}

sub _normalize_hyphen
{
  my ($array)= @_;
  return undef if !($array);
  my @ret;

  foreach (@$array)
  {
    s/-/_/g;
    push(@ret, $_);
  }
  return \@ret;
}

sub set_value
{
  my ($self, $value)= @_;

  ### Return 0 means 
  ###   "Need next argument, please call me again with next argument"
  if ($value =~ /^"([^"]*)/)
  {
    ### Start with doublequote should be ended with doublequote.
    return 0 if !($value =~ /"$/);

    ### Trim doublequote.
    $value =~ s/^"([^"]*)"$/$1/;
  }
  elsif ($value =~ /^'([^']*)/)
  {
    ### Start with singlequote should be ended with singlequote.
    return 0 if !($value =~ /'$/);

    ### Trim singlequote
    $value =~ s/^'([^']*)'$/$1/;
  }

  if ($self->{multi})
  {
    push(@{$self->{value}}, $value);
  }
  else
  {
    if (_check_isa($value, $self->{isa}))
    {
      $self->{value}= $value;
    }
    else
    {
      my $msg= sprintf("%s is not satisfied %s", $value,
                       ref($self->{isa}) eq "ARRAY" ?
                         "[" . join(", ", @{$self->{isa}}) . "]" :
                         $self->{isa});

      carp($msg);
    }
  }
  return 1;
}

sub _check_isa
{
  my ($value, $isa)= @_;
  return 1 if !(defined($isa));

  ### Validation.
  if (ref($isa) eq "ARRAY")
  {
    ### Array-style isa, grep
    return grep {$value eq $_} @$isa;
  }
  elsif (ref($isa) eq "Regexp")
  {
    ### Evaluate regexp
    return $value =~ $isa;
  }
}

return 1;
