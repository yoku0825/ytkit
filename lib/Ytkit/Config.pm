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
use Carp qw{carp croak};

use Ytkit::Config::Option;

my $_version= "0.1.9";

our $CONNECT_OPTION=
{
  user => { alias => ["u", "user"],
            text  => "MySQL account using for connection and checking\n" .
            "  (need REPLICATION CLIENT, PROCESSLIST and global SELECT priv)" },
  host => { alias => ["h", "host"],
            default => "localhost",
            text  => "MySQL host" },
  port => { alias => ["P", "port"],
            text  => "MySQL port number" },
  socket => { alias => ["S", "socket"],
              text  => "Path to mysql.sock\n" .
                       "  (this parameter is used when --host=localhost)" },
  password => { alias => ["p", "password"],
                default => $ENV{MYSQL_PWD} // "",
                text  => "Password for the user specified by --user" },
  timeout  => { alias => ["timeout"], default => 1,
                text  => "Seconds before timeout\n" .
                         "  (Set into read_timeout, write_timeout, connect_timeout)" },
};

our $COMMON_OPTION=
{
  help => { alias => ["help", "usage"],
            text  => "Show this message",
            noarg => 1 },
  verbose => { alias => ["verbose", "v"],
               text  => "Verbose output mode",
               noarg => 1 },
  version => { alias => ["version", "V"],
               text  => "Show ytkit version",
               noarg => 1 },
};


sub new
{
  my ($class, $definition)= @_;
  my ($buffer, $dict);

  ### Normalize { parent => { child => { option_hash } } } style
  ###  to { parent_child => { option_hash } } style.
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
  my $self=
  {
    dict     => $dict,
    buffer   => $buffer,
    script   => $0,
    synopsis => undef,
    description => undef,
  };

  bless $self => $class;
  return $self;
}

sub options
{
  ### Deprecated, left for compatibility
  my ($definition, @argv)= @_;
  my $config= Ytkit::Config->new($definition);
  $config->parse_argv(@argv);
  return ($config->{result}, @{$config->{left_argv}});
}

sub parse_argv
{
  my ($self, @argv)= @_;
  my @left_argv;

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
      if ($arg =~ /^--([^\s]+)$/ || $arg =~ /^-([^-])$/)
      {
        ### "--option"(bool style) or first element in "--option value" style
        ###   or "-o"(bool style) or first element in "-o value" style
        $key= $1;

        ### Decide bool style or "--option value", "-o value" style.
        my $next= shift(@argv);

        ### Next element doesn't exists(last part of argv is evaluating now) or
        ### next element starts with "-", current part is bool style option.
        ###   TODO: How about a negative number?
        if (!($next) || $next =~ /^-/)
        {
          ### bool style
          $value= 1;
          ### write back next element.
          unshift(@argv, $next);
        }
        else
        {
          ### "--option value" style.
          $value= $next;
        }
      }

      ### Normalize
      $key =~ s/-/_/g if $key;
    }

    ### if any $key and $value is not set, treated as argument and push into left_argv later.

    ### Is known option?
    my $opt= $key ? $self->{dict}->{$key} // undef : undef;
    if ($opt)
    {
      if ($opt->{noarg})
      {
        $opt->set_value(1);
        unshift(@argv, $value) if $value ne "1";
      }
      else
      {
        while ($opt->set_value($value) == 0)
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

  my $ret;
  while (my ($key, $value)= each(%{$self->{buffer}}))
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
  $self->{result}= $ret;
  $self->{left_argv}= \@left_argv;

  return 1;
}

sub show_option_text
{
  my ($self)= @_;
  my @ret;

  while (my ($key, $value)= each(%{$self->{buffer}}))
  {
    if (ref($value) eq "Ytkit::Config::Option")
    {
      push(@ret, _extract_for_usage($value));
    }
    else
    {
      ### Recursive
      while (my ($child_key, $child_value)= each(%$value))
      {
        push(@ret, _extract_for_usage($child_value));
      }
    }
  }
  @ret= sort(@ret);
  return \@ret;
}

sub _extract_for_usage
{
  my ($opt)= @_;

  ### Decide to print "-s=value" or "-s"
  my $arg;
  if ($opt->{noarg})
  {
    $arg= "";
  }
  else
  {
    if ($opt->{isa})
    {
      $arg= sprintf("=%s", ref($opt->{isa}) eq "ARRAY" ? 
                             "[" . join(", ", @{$opt->{isa}}) . "]" :
                             $opt->{isa});
    }
    else
    {
      $arg= "=value";
    }
  }

  ### If multi => 1, add "(multiple)" after aliases.
  my $multi= $opt->{multi} ? " (multiple)" : "";

  ### Add default information.
  my $default= (exists($opt->{default}) && length($opt->{default} // "") > 0 && !($opt->{noarg})) ? 
                 sprintf(" { Default: %s }", $opt->{default}) : 
                 "";

  ### Expand each aliases
  my @aliases;
  foreach my $alias (@{$opt->{alias}})
  {
    if (length($alias) == 1)
    {
      ### 1 character alias must specified with single-hyphen.
      push(@aliases, sprintf("-%s%s", $alias, $arg));
    }
    else
    {
      ### 2 or more characters must specified with double-hypen.
      ### Normalize to print "_" to "-".
      $alias =~ s/_/-/g;
      push(@aliases, sprintf("--%s%s", $alias, $arg));
    }
  }
  return sprintf("* %s%s%s\n  %s\n", join(", ", sort(@aliases)), $multi, $default, $opt->{text});
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

  if (!(-r $config_file))
  {
    carp("$config_file isn't readable or not found");
    return $opt;
  }

  open(my $fh, "<", $config_file);

  my $current_section= 1; ### MAGIC_NUMBER for unknown section
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
      
      $opt->{$key} ||= $value;
    }
    else
    {
      ### Only key.
      $opt->{$line} ||= 1;
    }
  }
  close($fh);

  return $opt;
}

sub version
{
  my ($self)= @_;
  my $prefix= $self->{_script} ? sprintf("%s - ", $self->{_script}) : "";
  return sprintf("%sytkit Ver. %s\n", $prefix, $_version);
}

sub usage
{
  my ($self)= @_;

  return sprintf("%s\n%s\n%s\n",
                 $self->{_synopsis},
                 "-" x 20,
                 join("\n", @{$self->show_option_text}));
}

sub help
{
  my ($self)= @_;

  return sprintf("%s\n%s\n%s\n%s\n",
                 $self->{_script},
                 "=" x 20,
                 $self->{_description},
                 "=" x 20);
}


return 1;
