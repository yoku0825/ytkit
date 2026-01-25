#!/usr/bin/perl

#########################################################################
# Copyright (C) 2019, 2026  yoku0825
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
no warnings "once";
use utf8;
use Test::More;
use File::Temp qw{ tempdir };

use FindBin qw{$Bin};
use lib "$Bin/../lib";
require "$Bin/xTest.pl";

use Ytkit::MySQLServer;
use Ytkit::Sandbox;

foreach my $version (@Ytkit::xTest::sandboxes)
{
  subtest "Testing via $version" => sub
  {
    my $sandbox_home= tempdir(DIR => $Ytkit::xTest::sandbox_tmp);
    my $sandbox= Ytkit::Sandbox->new("--mysqld", $version, "--sandbox_home", $sandbox_home);
    $sandbox->prepare;
    $sandbox->setup_replication;

    my $server= Ytkit::MySQLServer->new({ host   => $sandbox->info->[0],
                                          user   => "root", });
    $server->conn;
    ok(!($server->error), "Connect to mysqld");
    $server->{_ignore_unsupport_version}= 1 if $ENV{HARNESS_ACTIVE};

    my $file_path= "$Bin/../lib/Ytkit/MySQLServer.pm";
    my @method   = `grep "^sub" $file_path | awk '{print \$2}'`;
    my @ignore   = qw{ conn new DESTROY query_arrayref query_hashref 
                       warning error show_grants exec_sql valueof 
                       errno clear_cache describe_table raise_if_error warn_if_error
                       exec_sql_with_croak exec_sql_with_carp use support_version }; ### Almost cases are 'need argument(s)'
    
    foreach my $func (@method)
    {
      chomp($func);
      next if !($func);
      next if grep { $func eq $_ } @ignore;
      next if substr($func, 0, 1) eq "_"; ### private methods
    
      eval
      {
        $server->$func;
      };
    
      ok(!($@) && !($server->error), "$func has executed without error.") or diag($server->error);
    }
    $sandbox->delete_sandbox;
    done_testing;
  };
}

done_testing;
