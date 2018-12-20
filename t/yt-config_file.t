#!/usr/bin/perl

#########################################################################
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
use Test::More;

use FindBin qw{$Bin};
use lib "$Bin/../lib";

use_ok("Ytkit::Config");
use_ok("Ytkit::Config::File");

subtest "new Ytkit::Config::File interface" => sub
{
  my $file= Ytkit::Config::File->new("$Bin/data/yt-config_file.conf");
  is_deeply($file, { server1 => ["--host=123.456.789.10",
                                 "--port=3306",
                                 "--user=abcdef",
                                 "--password=hogehoge"],
                     server2 => ["--host=localhost"],
                     server3 => ["--socket=/var/lib/mysql/mysql.sock"],
                     server4 => ["--user=aaa ### Inline comment is NOT supported"],
                     space_around_equal => ["--user=mysql",
                                            "--abc=def",
                                            "--ghi=jkl"],
                     quotes => ["--one=\"aaa bbb\"",
                                "--two='\"aaa bbb'",
                                "--three=\"ccc\"ddd",
                                "--four='ef"],
                   }, "Parse .conf file");

  subtest "Call Ytkit::Config->new" => sub
  {
    subtest "Parse server1" => sub
    {
      my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);

      $config->parse_argv(@{$file->{server1}});
      is_deeply($config->{result}, { host => "123.456.789.10",
                                     port => 3306,
                                     user => "abcdef",
                                     password => "hogehoge",
                                     timeout => 1,
                                     socket => undef }, "Parse server1");
      done_testing;
    };

    subtest "Parse server2" => sub
    {
      my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);
      $config->parse_argv(@{$file->{server2}});
      is_deeply($config->{result}, { host => "localhost",
                                     port => undef,
                                     user => undef,
                                     password => "",
                                     timeout => 1,
                                     socket => undef }, "Parse server2");
      done_testing;
    };
 
    subtest "no_setting_section" => sub
    {
      my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);
      $config->parse_argv(@{$file->{no_setting_section}});
      is_deeply($config->{result}, { host => undef,
                                     port => undef,
                                     user => undef,
                                     password => "",
                                     timeout => 1,
                                     socket => undef }, "empty section");
      done_testing;
    };

    subtest "Not options(arguments)" => sub
    {
      my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);
      $config->parse_argv(@{$file->{quotes}});
      is_deeply($config->{result}, { host => undef,
                                     port => undef,
                                     user => undef,
                                     password => "",
                                     timeout => 1,
                                     socket => undef }, "empty section");
      is_deeply($config->{left_argv}, [q{--one="aaa bbb"},
                                       q{--two='"aaa bbb'},
                                       q{--three="ccc"ddd},
                                       q{--four='ef}], "Treat as arguments");
      done_testing;
    };

    subtest "Options and arguments" => sub
    {
      my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);
      $config->parse_argv(@{$file->{space_around_equal}});
      is_deeply($config->{result}, { host => undef,
                                     port => undef,
                                     user => "mysql",
                                     password => "",
                                     timeout => 1,
                                     socket => undef }, "Treat as options");
      is_deeply($config->{left_argv}, [q{--abc=def},
                                       q{--ghi=jkl}], "Treat as arguments");
      done_testing;
    };
 
    done_testing;
  };
  done_testing;
};

subtest "with [global] section" => sub
{
  my $file= Ytkit::Config::File->new("$Bin/data/yt-config_file_global.conf", { use_global => 1 });

  subtest "server1" => sub
  {
    my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);
    $config->parse_argv(@{$file->{server1}});
    is_deeply($config->{result}, { host => "123.456.789.10",
                                   port => 3306,
                                   user => "abcdef",
                                   password => "hogehoge",
                                   socket => undef,
                                   timeout => 1}, "[global] should be overrided");
    done_testing;
  };

  subtest "server2" => sub
  {
    my $config= Ytkit::Config->new($Ytkit::Config::CONNECT_OPTION);
    $config->parse_argv(@{$file->{server2}});
    is_deeply($config->{result}, { host => "localhost",
                                   port => undef,
                                   user => "global_user",
                                   password => "",
                                   socket => undef,
                                   timeout => 1 }, "[global] should be applied");
    done_testing; 
  };
};

done_testing;
