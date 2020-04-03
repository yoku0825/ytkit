#!/usr/bin/perl

#########################################################################
# Copyright (C) 2019  yoku0825
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
use Test::mysqld;

use Ytkit::MySQLServer;

my $test=
{
  #"5.0.96" => { mysqld => "/usr/mysql/5.0.96/libexec/mysqld", mysql_install_db => "/usr/mysql/5.0.96/bin/mysql_install_db" },
  #"5.1.72" => { mysqld => "/usr/mysql/5.1.73/libexec/mysqld", mysql_install_db => "/usr/mysql/5.1.73/bin/mysql_install_db" },
  #"5.5.62" => { mysqld => "/usr/mysql/5.5.62/bin/mysqld", mysql_install_db => "/usr/mysql/5.5.62/scripts/mysql_install_db" },
  #"5.6.46" => { mysqld => "/usr/mysql/5.6.46/bin/mysqld", mysql_install_db => "/usr/mysql/5.6.46/scripts/mysql_install_db" },
  "5.7.29" => { mysqld => "/usr/mysql/5.7.29/bin/mysqld" },
  "8.0.19" => { mysqld => "/usr/mysql/8.0.19/bin/mysqld" },
};

### Put test-binaries into /usr/mysql/X.X.XX 
foreach my $version (sort(keys(%$test)))
{
  subtest "Testing via $version" => sub
  {
    $test->{$version}->{my_cnf}=
    {
      server_id => 1,
      log_bin   => "mysql-bin",
    };
    my $mysqld= Test::mysqld->new($test->{$version});

    my $server= Ytkit::MySQLServer->new({ host   => "localhost",
                                          socket => $mysqld->base_dir . "/tmp/mysql.sock",
                                          user   => "root", });
    $server->conn;
    ok(!($server->error), "Connect to mysqld");

    my $file_path= "$Bin/../lib/Ytkit/MySQLServer.pm";
    my @method   = `grep "^sub" $file_path | awk '{print \$2}'`;
    my @ignore   = qw{ conn new DESTROY query_arrayref query_hashref 
                       warning error show_grants exec_sql valueof 
                       errno _print_table _print_vtable clear_cache };
    
    foreach my $func (@method)
    {
      chomp($func);
      next if !($func);
      next if grep { $func eq $_ } @ignore;
    
      eval
      {
        $server->$func;
      };
    
      ok(!($@) && !($server->error), "$func has executed without error.") or diag($server->error);
    }
    done_testing;
  };
}

done_testing;
