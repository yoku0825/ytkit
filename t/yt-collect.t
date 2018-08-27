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

use Test::MockTime;
Test::MockTime::set_fixed_time("2018-06-06 12:27:34 +0900", "%Y-%m-%d %H:%M:%S %z");

use FindBin qw{$Bin};
use lib "$Bin/../lib";
use Ytkit::Collect;
require "$Bin/Test.pl";

no warnings "once";

### Dummy connection
my $prog= {};
bless $prog => "Ytkit::Collect";
$prog->{instance}= {};
bless $prog->{instance} => "Ytkit::MySQLServer";
$prog->{instance}->{conn}= {};
#bless $prog->{instance}->{conn} => "DBI";
$prog->{print_header}= 0;

### Fix output-tablename
$prog->{query_latency}->{output_name}= "ps_digest_info";
$prog->{table_latency}->{output_name}= "ps_table_info";
$prog->{table_size}->{output_name}   = "is_table_info";
$prog->{show_grants}->{output_name}  = "user_grants";
$prog->{slave_status}->{output_name} = "slave_status";


subtest "checking requirements" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  is($prog->is_satisfied_requirement, 1, "Accept MySQL 5.7 && performance_schema = ON");
  $prog->clear_cache;

  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES_57_PS_OFF::VAR1;
  is($prog->is_satisfied_requirement, 0, "Reject MySQL 5.7 && performance_schema = OFF");
  $prog->clear_cache;

  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES_55_PS_ON::VAR1;
  is($prog->is_satisfied_requirement, 0, "Reject MySQL 5.5 && performance_schema = ON");
  $prog->clear_cache;

  done_testing;
};

subtest "events_statements_summary_by_digest" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->{instance}->{_select_ps_digest}= $Ytkit::Test::SELECT_FROM_ps_digest::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_query_latency, read_file("$Bin/data/select_from_ps_digest_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_query_latency, read_file("$Bin/data/select_from_ps_digest_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is($prog->print_query_latency, read_file("$Bin/data/select_from_ps_digest_into_json.r"), "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_query_latency, read_file("$Bin/data/select_from_ps_digest_into_sql.r"), "Print SQL style");

  $prog->clear_cache;
  done_testing;
};

subtest "table_io_waits_summary_by_table" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->{instance}->{_select_ps_table}= $Ytkit::Test::SELECT_FROM_ps_table::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_table_latency, read_file("$Bin/data/select_from_ps_table_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_table_latency, read_file("$Bin/data/select_from_ps_table_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is($prog->print_table_latency, read_file("$Bin/data/select_from_ps_table_into_json.r"), "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_table_latency, read_file("$Bin/data/select_from_ps_table_into_sql.r"), "Print SQL style");

  $prog->clear_cache;
  done_testing;
};

subtest "i_s.tables" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->{instance}->{_select_is_table_by_size}= $Ytkit::Test::SELECT_FROM_is_table::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_table_size, read_file("$Bin/data/select_from_is_table_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_table_size, read_file("$Bin/data/select_from_is_table_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is($prog->print_table_size, read_file("$Bin/data/select_from_is_table_into_json.r"), "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_table_size, read_file("$Bin/data/select_from_is_table_into_sql.r"), "Print SQL style");

  $prog->clear_cache;
  done_testing;
};

#subtest "SHOW GLOBAL STATUS" => sub
#{
#  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
#  $prog->{instance}->{_show_status}= $Ytkit::Test::SHOW_STATUS::VAR1;
#
#  $prog->clear_cache;
#  done_testing;
#};

#subtest "i_s.innodb_metrics" => sub
#{
#  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
#  $prog->{instance}->{_select_is_metrics}= $Ytkit::Test::SELECT_FROM_is_metrics::VAR1;
#
#  $prog->clear_cache;
#  done_testing;
#};

subtest "user_grants" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->{instance}->{_select_user_list}= $Ytkit::Test::SELECT_user_list::VAR1;

  ### show_grants clears cache each time.
  $prog->{instance}->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "tsv";
  is($prog->print_show_grants, read_file("$Bin/data/show_grants_into_tsv.r"), "Print TSV style");

  $prog->{instance}->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "csv";
  is($prog->print_show_grants, read_file("$Bin/data/show_grants_into_csv.r"), "Print CSV style");

  $prog->{instance}->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "json";
  is($prog->print_show_grants, read_file("$Bin/data/show_grants_into_json.r"), "Print JSON style");

  $prog->{instance}->{_show_grants}= $Ytkit::Test::SHOW_GRANTS::VAR1;
  $prog->{output}= "sql";
  is($prog->print_show_grants, read_file("$Bin/data/show_grants_into_sql.r"), "Print SQL style");
};

#subtest "SHOW GLOBAL VARIABLES" => sub
#{
#  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
#
#  $prog->clear_cache;
#  done_testing;
#};

subtest "SHOW SLAVE STATUS" => sub
{
  $prog->{instance}->{_show_variables}= $Ytkit::Test::SHOW_VARIABLES::VAR1;
  $prog->{instance}->{_show_slave_status}= $Ytkit::Test::SHOW_SLAVE_STATUS_OK::VAR1;

  $prog->{output}= "tsv";
  is($prog->print_show_slave, read_file("$Bin/data/show_slave_status_into_tsv.r"), "Print TSV style");

  $prog->{output}= "csv";
  is($prog->print_show_slave, read_file("$Bin/data/show_slave_status_into_csv.r"), "Print CSV style");

  $prog->{output}= "json";
  is($prog->print_show_slave, read_file("$Bin/data/show_slave_status_into_json.r"), "Print JSON style");

  $prog->{output}= "sql";
  is($prog->print_show_slave, read_file("$Bin/data/show_slave_status_into_sql.r"), "Print SQL style");

  $prog->clear_cache;
  done_testing;
};



done_testing;


exit 0;


sub read_file
{
  my ($filename)= @_;
  open(my $fh, "<", $filename);
  my @buff= <$fh>;
  close($fh);
  return join("", @buff);
}
