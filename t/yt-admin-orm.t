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

use_ok("Ytkit::AdminTool::ORM");



subtest "Simple 'new'" => sub
{
  ok(my $column= Ytkit::AdminTool::ORM::Column->new("--column_name=num",
                                                    "--data_type=uulong",
                                                    "--not_null=1"), "Make a NOT NULL NO DEFAULT object");
  is_deeply($column->modify, { pre   => q{MODIFY `num` BIGINT UNSIGNED NOT NULL },
                               after => undef },
            "Ytkit::AdminTool::ORM::Column::modify");
  is_deeply($column->drop, { pre   => q{DROP `num`}, after => undef },
            "Ytkit::AdminTool::ORM::Column::drop");
  is_deeply($column->add, { pre   => q{ADD `num` BIGINT UNSIGNED NOT NULL DEFAULT '0'},
                            after => q{MODIFY `num` BIGINT UNSIGNED NOT NULL } },
            "Ytkit::AdminTool::ORM::Column::add(2-phase)");
  
  ok($column= Ytkit::AdminTool::ORM::Column->new("--column_name=val",
                                                 "--data_type=string",
                                                 "--not_null=0",
                                                 "--no_default=1"), "Make a NULLABLE NO DEFAULT object");
  is_deeply($column->modify, { pre   => q{MODIFY `val` VARCHAR(64)  },
                               after => undef },
            "Ytkit::AdminTool::ORM::Column::modify");
  is_deeply($column->drop, { pre   => q{DROP `val`}, after => undef },
            "Ytkit::AdminTool::ORM::Column::drop");
  is_deeply($column->add, { pre   => q{ADD `val` VARCHAR(64)  },
                            after => undef },
            "Ytkit::AdminTool::ORM::Column::add(1-phase)");
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
      is_deeply($column->add, { pre   => q{ADD `colname` INT NOT NULL DEFAULT '0'},
                                after => q{MODIFY `colname` INT NOT NULL } },
                "not_null=1, default is undef, no no_default");

      eval
      {
        $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--no-default=0");
      };
      ok($@, "not_null=1, default is undef, with no_default=0 is invalid combination.");

      $column= Ytkit::AdminTool::ORM::Column->new(@param, "--not_null=1", "--no-default=1");
      is_deeply($column->add, { pre   => q{ADD `colname` INT NOT NULL DEFAULT '0'},
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
      is_deeply($column->add, { pre   => q{ADD `colname` INT NOT NULL DEFAULT '9'},
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
      is_deeply($column->add, { pre   => q{ADD `colname` INT  DEFAULT '9'},
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

subtest "new_from_row" => sub
{
  my $test_hashre_user= $Ytkit::Test::SELECT_FROM_is_columns::mysql_user->{User};
  ok(my $column= Ytkit::AdminTool::ORM::Column->new_from_row($test_hashre_user), "new_from_row");
  #is_deeply($column->add, { pre => q{ADD `User` VARCHAR(64) NOT NULL },
  #                          after => undef },
  #          "add method normalizes char to VARCHAR");

  done_testing;
};





### new_from_row should be test
### compare should be test

done_testing;

