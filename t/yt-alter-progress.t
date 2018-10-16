#!/usr/bin/perl

#########################################################################
# Copyright (C) 2018  yoku0825
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
use Ytkit::AlterProgress;
require "$Bin/Test.pl";

no warnings "once";

### Dummy connection
my $prog= {};
bless $prog => "Ytkit::AlterProgress";
$prog->{instance}= {};
bless $prog->{instance} => "Ytkit::MySQLServer";
$prog->{instance}->{conn}= {};
#bless $prog->{instance}->{conn} => "DBI";

$ENV{HARNESS_ACTIVE}= 1;

subtest "Checking requirements" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  ok($prog->checking_requirement, "Checking Requirement(OK on ps=ON 5.7)");
  $prog->clear_cache;

  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES_55_PS_ON::VAR1;
  ok(!($prog->checking_requirement), "Checking Requirement(NG on ps=ON 5.5)");
  $prog->clear_cache;

  done_testing;
};

subtest "setup_instruments" => sub
{
  $prog->{instance}->{_fetch_p_s_stage_innodb_alter_table} = $Ytkit::Test::fetch_p_s_stage_innodb_alter_table::ALL_YES;
  is_deeply($prog->_search_instruments, [], "setup_instruments has been already set up");
  $prog->clear_cache;

  $prog->{instance}->{_fetch_p_s_stage_innodb_alter_table} = $Ytkit::Test::fetch_p_s_stage_innodb_alter_table::SOMETHING_NO;
  is_deeply($prog->_search_instruments, ["UPDATE performance_schema.setup_instruments SET enabled = 'YES', timed = 'YES' WHERE name = 'stage/innodb/alter table (end)'", "UPDATE performance_schema.setup_instruments SET enabled = 'YES', timed = 'YES' WHERE name = 'stage/innodb/alter table (flush)'","UPDATE performance_schema.setup_instruments SET enabled = 'YES', timed = 'YES' WHERE name = 'stage/innodb/alter table (insert)'"], "setup_instruments should be updated");
  $prog->clear_cache;

  done_testing;
};

subtest "setup_consumers" => sub
{
  $prog->{instance}->{_fetch_p_s_events_stages} = $Ytkit::Test::fetch_p_s_events_stages::ALL_YES;
  is_deeply($prog->_search_consumers, [], "setup_consumers has been already set up");
  $prog->clear_cache;

  $prog->{instance}->{_fetch_p_s_events_stages} = $Ytkit::Test::fetch_p_s_events_stages::ALL_NO;
  is_deeply($prog->_search_consumers, ["UPDATE performance_schema.setup_consumers SET enabled = 'YES' WHERE name = 'events_stages_current'","UPDATE performance_schema.setup_consumers SET enabled = 'YES' WHERE name = 'events_stages_history'","UPDATE performance_schema.setup_consumers SET enabled = 'YES' WHERE name = 'events_stages_history_long'"], "setup_consumers should be updated");
  $prog->clear_cache;

  done_testing;
};

subtest "alter_table_progress" => sub
{
  $prog->{instance}->{_alter_table_progress}= $Ytkit::Test::alter_table_progress::VAR1;
  is($prog->alter_table_progress, "[ 15.38% ( 11 sec | 2 sec) ] stage/innodb/alter table (read PK and internal sort) : ALTER TABLE t1 ADD KEY (charcol1, intcol1)", "Output progress");
  $prog->clear_cache;

  done_testing;
};

#subtest "restore settings" => sub
#{
#  ### This is hooked by bin/yt-alter-progress
#  $prog->restore_setting;
#};

subtest "config description" => sub
{
  my $prog2= Ytkit::AlterProgress->new;
  unlike($prog2->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;


exit 0;

