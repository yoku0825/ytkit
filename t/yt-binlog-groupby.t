#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017, 2020  yoku0825
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

use_ok("Ytkit::BinlogGroupby");

subtest "--sort (old-behavior compatibility)" => sub
{
  subtest "--group-by=all --sort" => sub
  {
    my @option= qw{--group-by=all --cell=1m --output=tsv --sort};
    run_test("01_parse_sbr_57.txt", "01_parse_sbr_57.r", @option);
    run_test("01_parse_rbr_57.txt", "01_parse_rbr_57.r", @option);
    run_test("mysqlbinlog_rbr_80.txt", "mysqlbinlog_rbr_80_all_1m_tsv.r", @option);
    run_test("mysqlbinlog_sbr_80.txt", "mysqlbinlog_sbr_80_all_1m_tsv.r", @option);
    done_testing;
  };
  
  subtest "--group-by=all,exec --sort" => sub
  {
    no warnings "qw";
    my @option= qw{--group-by=all,exec --cell=1m --output=tsv --sort};
    run_test("01_parse_sbr_57.txt", "01_parse_sbr_57_all_exec.r", @option);
    run_test("mysqlbinlog_rbr_80.txt", "mysqlbinlog_rbr_80_allexec_1m_tsv.r", @option);
    run_test("mysqlbinlog_sbr_80.txt", "mysqlbinlog_sbr_80_allexec_1m_tsv.r", @option);
    done_testing;
  };
};

subtest "without --sort" => sub
{
  subtest "--group-by=all --output=tsv" => sub
  {
    my @option= qw{ --group-by=all --cell=1m --output=tsv };
    run_test("01_parse_sbr_57.txt", "01_parse_sbr_57.r", @option);
    run_test("01_parse_rbr_57.txt", "01_parse_rbr_57.r", @option);
    run_test("mysqlbinlog_rbr_80.txt", "mysqlbinlog_rbr_80_all_1m_tsv.r", @option);
    run_test("mysqlbinlog_sbr_80.txt", "mysqlbinlog_sbr_80_all_1m_tsv.r", @option);

    done_testing;
  };
  
  subtest "--group-by=all,exec --output=tsv" => sub
  {
    no warnings "qw";
    my @option= qw{ --group-by=all,exec --cell=1m --output=tsv };
    run_test("01_parse_sbr_57.txt", "01_parse_sbr_57_all_exec.r", @option);
    run_test("mysqlbinlog_rbr_80.txt", "mysqlbinlog_rbr_80_allexec_1m_tsv.r", @option);
    run_test("mysqlbinlog_sbr_80.txt", "mysqlbinlog_sbr_80_allexec_1m_tsv.r", @option);
    done_testing;
  };

  subtest "--group-by=all --output=csv" => sub
  {
    my @option= qw{ --group-by=all --cell=1m --output=csv };
    run_test("01_parse_sbr_57.txt", "01_parse_sbr_57_csv.r", @option);
    run_test("01_parse_rbr_57.txt", "01_parse_rbr_57_csv.r", @option);
    run_test("mysqlbinlog_rbr_80.txt", "mysqlbinlog_rbr_80_all_1m_csv.r", @option);
    run_test("mysqlbinlog_sbr_80.txt", "mysqlbinlog_sbr_80_all_1m_csv.r", @option);

    done_testing;
  };
  
  subtest "--group-by=all,exec --output=csv" => sub
  {
    no warnings "qw";
    my @option= qw{ --group-by=all,exec --cell=1m --output=csv };
    run_test("01_parse_sbr_57.txt", "01_parse_sbr_57_all_exec_csv.r", @option);
    run_test("mysqlbinlog_rbr_80.txt", "mysqlbinlog_rbr_80_allexec_1m_csv.r", @option);
    run_test("mysqlbinlog_sbr_80.txt", "mysqlbinlog_sbr_80_allexec_1m_csv.r", @option);
    done_testing;
  };

  done_testing;
};

subtest "parse all group-by" => sub
{
  my @elements= qw{time statement table};

  subtest "1 element" => sub
  {
    foreach (@elements)
    {
      my $optstr= $_;
      my $prog= Ytkit::BinlogGroupby->new("--group-by", $optstr);
      eval
      {
        $prog->output();
      };
      ok(!($@), "group_by $optstr handles without error");
    }
    done_testing;
  };

  subtest "2 elements" => sub
  {
    foreach my $first (@elements)
    {
      foreach my $second (@elements)
      {
        next if $first eq $second;
        my $optstr= sprintf("%s,%s", $first, $second);
        my $prog= Ytkit::BinlogGroupby->new("--group-by", $optstr);
        eval
        {
          $prog->output();
        };
        ok(!($@), "group_by $optstr handles without error");
      }
    }
    done_testing;
  };

  subtest "3 elements" => sub
  {
    my $optstr= join(",", @elements);
    my $prog= Ytkit::BinlogGroupby->new("--group-by", $optstr);
    eval
    {
      $prog->output();
    };
    ok(!($@), "group_by $optstr handles without error");

    done_testing;
  };
};

subtest "Regression tests" => sub
{
  run_test("issue_23.txt", "issue_23.r", "--group-by=table");
  run_test("issue_33.txt", "issue_33.r", "--group-by=all");
  done_testing;
};


subtest "config description" => sub
{
  my $prog= Ytkit::BinlogGroupby->new();
  unlike($prog->help, qr/FIXME/, "config description shouldn't have FIXME");
  done_testing;
};

done_testing;


exit 0;


sub run_test
{
  my ($infile, $resultfile, @argv)= @_;

  my $prog= Ytkit::BinlogGroupby->new(@argv);
  open(my $in, "<", sprintf("%s/data/%s", $Bin, $infile)) or die;
  open(my $expect, "<", sprintf("%s/data/r/%s", $Bin, $resultfile)) or die;
  
  while (<$in>)
  {
    $prog->parse($_);
  }

  my @expect= <$expect>;
  close($in);
  close($expect);

  is_deeply($prog->output, \@expect, $resultfile);
}
