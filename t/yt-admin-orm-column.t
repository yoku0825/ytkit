#!/usr/bin/perl

#########################################################################
# Copyright (C) 2021  yoku0825
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
require "$Bin/Test.pl";

no warnings "once";
use_ok("Ytkit::AdminTool::ORM::Column");

subtest "Simple 'new'" => sub
{
  subtest "uulong" => sub
  {
    ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=num", "--data_type=uulong"), "new");
    is_deeply($column->init, { pre   => "`num` BIGINT UNSIGNED NOT NULL ",
                               after => undef }, "init");
    is_deeply($column->modify, { pre   => q{MODIFY `num` BIGINT UNSIGNED NOT NULL },
                                 after => undef }, "modify");
    is_deeply($column->drop, { pre => q{DROP `num`}, after => undef }, "drop");
    is_deeply($column->add, { pre   => q{ADD `num` BIGINT UNSIGNED NOT NULL DEFAULT 0},
                              after => q{MODIFY `num` BIGINT UNSIGNED NOT NULL } },
              "add(2-phase)");
    done_testing;
  };

  subtest "string" => sub
  {
    ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=val", "--data_type=string"), "new");
    is_deeply($column->init, { pre => q{`val` VARCHAR(64) NOT NULL }, after => undef }, "init");
    is_deeply($column->modify, { pre => q{MODIFY `val` VARCHAR(64) NOT NULL }, after => undef },
              "modify");
    is_deeply($column->drop, { pre => q{DROP `val`}, after => undef }, "drop");
    is_deeply($column->add, { pre   => q{ADD `val` VARCHAR(64) NOT NULL DEFAULT ''},
                              after => q{MODIFY `val` VARCHAR(64) NOT NULL } },
              "add(2-phase)");
    done_testing;
  };

  subtest "int" => sub
  {
    ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=int", "--data_type=int"), "new");
    is_deeply($column->init, { pre => q{`int` INT NOT NULL }, after => undef }, "init");
    is_deeply($column->modify, { pre => q{MODIFY `int` INT NOT NULL }, after => undef }, "modify");
    is_deeply($column->drop, { pre => q{DROP `int`}, after => undef }, "drop");
    is_deeply($column->add, { pre   => q{ADD `int` INT NOT NULL DEFAULT 0},
                              after => q{MODIFY `int` INT NOT NULL } },
              "add(2-phase)");
    done_testing;
  };

  subtest "clob" => sub
  {
    ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=clob", "--data_type=clob"), "new");
    is_deeply($column->init, { pre => q{`clob` TEXT NOT NULL }, after => undef }, "init");
    is_deeply($column->modify, { pre => q{MODIFY `clob` TEXT NOT NULL }, after => undef }, "modify");
    is_deeply($column->drop, { pre => q{DROP `clob`}, after => undef }, "drop");
    is_deeply($column->add, { pre   => q{ADD `clob` TEXT NOT NULL DEFAULT ('')},
                              after => q{MODIFY `clob` TEXT NOT NULL } },
              "add(2-phase)");
    done_testing;
  };

  subtest "datetime" => sub
  {
    ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=dt", "--data_type=datetime"), "new");
    is_deeply($column->init, { pre => q{`dt` DATETIME NOT NULL }, after => undef }, "init");
    is_deeply($column->modify, { pre => q{MODIFY `dt` DATETIME NOT NULL }, after => undef }, "modify");
    is_deeply($column->drop, { pre => q{DROP `dt`}, after => undef }, "drop");
    is_deeply($column->add, { pre   => q{ADD `dt` DATETIME NOT NULL DEFAULT '1999-12-31 00:00:00'},
                              after => q{MODIFY `dt` DATETIME NOT NULL } },
              "add(2-phase)");
    done_testing;
  };

  subtest "autoinc" => sub
  {
    ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=ai", "--data_type=autoinc"), "new");
    is_deeply($column->init, { pre => q{`ai` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT}, after => undef }, "init");
    is_deeply($column->modify, { pre => undef, after => undef }, "modify is not supported");
    is_deeply($column->drop, { pre => q{DROP `ai`}, after => undef }, "drop");
    is_deeply($column->add, { pre   => undef, after => undef }, "add is not supported");
    done_testing;
  };

  done_testing;
};

subtest "Variations not_null, default, no_default" => sub
{
  my $column;
  my @param= ("--column_name=colname", "--data_type=int");

  subtest "not_null=1" => sub
  {
    subtest "not_null=1, default is undef" => sub
    {
      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1");
      is_deeply($column->add, { pre   => q{ADD `colname` INT NOT NULL DEFAULT 0},
                                after => q{MODIFY `colname` INT NOT NULL } },
                "not_null=1, default is undef, no no_default");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--no-default=0");
      };
      ok($@, "not_null=1, default is undef, with no_default=0 is invalid combination.");

      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--no-default=1");
      is_deeply($column->add, { pre   => q{ADD `colname` INT NOT NULL DEFAULT 0},
                                after => q{MODIFY `colname` INT NOT NULL } },
                "not_null=1, default is undef, with no_default=1");
      done_testing;
    };

    subtest "not_null=1, default is 9" => sub
    {
      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--default=9");
      };
      ok($@, "not_null=1, default is 9, no no_default is invalid combination(have to use --no-default=0)");

      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--default=9", "--no-default=0");
      is_deeply($column->add, { pre   => q{ADD `colname` INT NOT NULL DEFAULT 9},
                                after => undef },
                "not_null=1, default is 9, with no_default=9");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--default=9", "--no-default=1");
      };
      ok($@, "not_null=1, default is 9, with no_default=1 is invalid combination.");

      done_testing;
    };

    done_testing;
  };

  subtest "not_null=0" => sub
  {
    subtest "not_null=0, default is undef" => sub
    {
      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0");
      is_deeply($column->add, { pre   => q{ADD `colname` INT  },
                                after => undef },
                "not_null=0, default is undef, no no_default");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--no-default=0");
      };
      ok($@, "not_null=0, default is undef, with no_default=0 is invalid combination.");


      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--no-default=1");
      is_deeply($column->add, { pre   => q{ADD `colname` INT  },
                                after => undef },
                "not_null=0, default is undef, with no_default=1");
      done_testing;
    };

    subtest "not_null=0, default is 9" => sub
    {
      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--default=9");
      };
      ok($@, "not_null=0, default is 9, no no_default is invalid combination(have to use --no-default=0)");

      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--default=9", "--no-default=0");
      is_deeply($column->add, { pre   => q{ADD `colname` INT  DEFAULT 9},
                                after => undef },
                "not_null=0, default is 9, with no_default=9");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--default=9", "--no-default=1");
      };
      ok($@, "not_null=0, default is 9, with no_default=1 is invalid combination.");

      done_testing;
    };
    done_testing;
  };

  done_testing;
};

subtest "autoinc ignores all parameter variations" => sub
{
  my $column;
  my @param= ("--column_name=colname", "--data_type=autoinc");

  subtest "not_null=1" => sub
  {
    subtest "not_null=1, default is undef" => sub
    {
      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1");
      is_deeply($column->init, { pre   => q{`colname` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT},
                                 after => undef },
                "not_null=1, default is undef, no no_default");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--no-default=0");
      };
      ok($@, "not_null=1, default is undef, with no_default=0 is invalid combination.");

      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--no-default=1");
      is_deeply($column->init, { pre   => q{`colname` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT},
                                 after => undef },
                "not_null=1, default is undef, no_default=1");
      done_testing;
    };

    subtest "not_null=1, default is 9" => sub
    {
      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--default=9");
      };
      ok($@, "not_null=1, default is 9, no no_default is invalid combination(have to use --no-default=0)");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--default=9", "--no-default=0");
      };
      ok($@, "not_null=1, default is 9, with no_default=9, autoinc doesn't accept --default");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--default=9", "--no-default=1");
      };
      ok($@, "not_null=1, default is 9, with no_default=1 is invalid combination.");

      done_testing;
    };

    done_testing;
  };

  subtest "not_null=0" => sub
  {
    subtest "not_null=0, default is undef" => sub
    {
      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0");
      };
      ok($@, "not_null=0, default is undef, no no_default, autoinc doesn't accept --not_null=0");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--no-default=0");
      };
      ok($@, "not_null=0, default is undef, with no_default=0 is invalid combination.");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--no-default=1");
      };
      ok($@, "not_null=0, default is undef, with no_default=1, autoinc doesn't accept --not_null=0");
      done_testing;
    };

    subtest "not_null=0, default is 9" => sub
    {
      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--default=9");
      };
      ok($@, "not_null=0, default is 9, no no_default is invalid combination(have to use --no-default=0)");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--default=9", "--no-default=0");
      };
      ok($@, "not_null=0, default is 9, with no_default=9, autoinc doesn't accept --not_null=0");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=0", "--default=9", "--no-default=1");
      };
      ok($@, "not_null=0, default is 9, with no_default=1 is invalid combination.");

      done_testing;
    };
    done_testing;
  };

  done_testing;
};

subtest "new_from_row" => sub
{
  #+-------------+-----------+-------------+----------------+
  #| column_name | data_type | is_nullable | column_default |
  #+-------------+-----------+-------------+----------------+
  #| User        | char      | NO          |                |
  #+-------------+-----------+-------------+----------------+
  my $test_data= $Ytkit::Test::AdminTool::Column::columns;
  my $test_hashref_user= $test_data->[40];
  ok(my $column= Ytkit::AdminTool::ORM::Column->new_from_row($test_hashref_user), "new_from_row");
  is_deeply($column->add, { pre => q{ADD `ipaddr` VARCHAR(64) NOT NULL DEFAULT ''},
                            after => undef },
            "add method normalizes char to VARCHAR");
  is_deeply($column->modify, { pre => q{MODIFY `ipaddr` VARCHAR(64) NOT NULL DEFAULT ''},
                                after => undef },
            "modify method normalizes char to VARCHAR");
  
  my $empty_hashref= {};
  my $empty= Ytkit::AdminTool::ORM::Column->new_from_row($empty_hashref);
  is($empty, undef, "new_from_row vs empty");
  done_testing;
};

subtest "compare" => sub
{
  ok(my $column_from_hand= Ytkit::AdminTool::ORM::Column->new("--column_name=ipaddr",
                                                              "--data_type=string",
                                                              "--not_null=1",
                                                              q{--default="''"},
                                                              "--no-default=0"), "new by hand");

  #+-------------+-----------+-------------+----------------+
  #| column_name | data_type | is_nullable | column_default |
  #+-------------+-----------+-------------+----------------+
  #| User        | char      | NO          |                |
  #+-------------+-----------+-------------+----------------+
  my $test_data= $Ytkit::Test::AdminTool::Column::columns;
  my $test_hashref_user= $test_data->[40];
  ok(my $column_from_row= Ytkit::AdminTool::ORM::Column->new_from_row($test_hashref_user), "new_from_row");

  is_deeply($column_from_hand->compare($column_from_row),
            { pre => undef, after => undef }, "2 columns are same");

  ok(my $another_attribute= Ytkit::AdminTool::ORM::Column->new("--column_name=ipaddr",
                                                                "--data_type=clob",
                                                                "--not_null=1",
                                                                "--default=''",
                                                                "--no-default=0"), "another by hand");
  is_deeply($column_from_hand->compare($another_attribute),
            { pre => q{MODIFY `ipaddr` VARCHAR(64) NOT NULL DEFAULT ''}, after => undef },
            "Use MODIFY to substitude different attribute");

  my $column_from_empty_row= Ytkit::AdminTool::ORM::Column->new_from_row({});
  is($column_from_empty_row, undef, "new_from_row vs Empty column");
  is_deeply($column_from_hand->compare($column_from_empty_row),
            { pre => q{ADD `ipaddr` VARCHAR(64) NOT NULL DEFAULT ''}, after => undef },
            "Use ADD to add a new column");

  my $another_hashref= $test_data->[41];
  my $another_column= Ytkit::AdminTool::ORM::Column->new_from_row($another_hashref);
  eval
  {
    $column_from_hand->compare($another_column);
  };
  ok($@, "call _croakf('Column names are different')");

  done_testing;
};

done_testing;
