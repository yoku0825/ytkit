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




subtest "Ytkit::AdminTool::ORM::ForeignKey" => sub
{
  subtest "Simple 'new'" => sub
  {
    ok(my $index= Ytkit::AdminTool::ORM::ForeignKey->new("--column_name=num",
                                                         "--reference_table=t2"), "Object 1 column Secondary Index");
    is_deeply($index->init, { pre   => q{CONSTRAINT `fidx_num` FOREIGN KEY `fidx_num` (`num`) REFERENCES `t2` (`num`) ON UPDATE RESTRICT ON DELETE RESTRICT}, 
                              after => undef },
              "Ytkit::AdminTool::ORM::ForeignKey::init");
    is_deeply($index->add, { pre   => q{ADD CONSTRAINT `fidx_num` FOREIGN KEY `fidx_num` (`num`) REFERENCES `t2` (`num`) ON UPDATE RESTRICT ON DELETE RESTRICT},
                             after => undef },
              "1 column FK Index add");
    is_deeply($index->drop, { pre => q{DROP FOREIGN KEY `fidx_num`}, after => undef }, "1 column FK drop");

    ok(my $multi_index= Ytkit::AdminTool::ORM::ForeignKey->new("--column_name=b", "--column_name=a",
                                                               "--references=t2"),
       "Object 2 column FK Index");
    is_deeply($multi_index->add, { pre => q{ADD CONSTRAINT `fidx_b_a` FOREIGN KEY `fidx_b_a` (`b`, `a`) REFERENCES `t2` (`b`, `a`) ON UPDATE RESTRICT ON DELETE RESTRICT},
                                  after => undef }, "2 column FK Index add");
    is_deeply($multi_index->drop, { pre => q{DROP FOREIGN KEY `fidx_b_a`}, after => undef }, "2 column FK Index drop");

    done_testing;
  };
 
  subtest "new_from_row" => sub
  {
    #+----------------+------------+---------------------------------+
    #| index_name     | non_unique | _columns                        |
    #+----------------+------------+---------------------------------+
    #| idx_lastupdate |          1 | last_update                     |
    #+----------------+------------+---------------------------------+
    my $test_hashref_simple= $Ytkit::Test::SELECT_FROM_i_s_statistics::schema_table_name->{admintool}->{status_info}->{idx_lastupdate};
    ok(my $index= Ytkit::AdminTool::ORM::Index->new_from_row($test_hashref_simple), "1 Column Secondary Index new_from_row");
    is_deeply($index->add, { pre => q{ADD  KEY `idx_last_update` (`last_update`)},
                             after => undef },
              "Add 1 column Secondary Index");
    is_deeply($index->drop, { pre => q{DROP KEY `idx_last_update`}, after => undef },
              "Drop 1 column Secondary Index");
 
    my $empty_hashref= {};
    my $empty= Ytkit::AdminTool::ORM::Index->new_from_row($empty_hashref);
    is($empty, undef, "new_from_row vs empty");

    my $test_2columns_hashref= $Ytkit::Test::SELECT_FROM_i_s_statistics::schema_table_name->{admintool}->{table_status_info}->{idx_dummy};
    ok(my $index_2_secondary= Ytkit::AdminTool::ORM::Index->new_from_row($test_2columns_hashref),
       "2 Column Secondary Index new_from_row");
    is_deeply($index_2_secondary->add, { pre => q{ADD UNIQUE KEY `uidx_last_update_dummy_column` (`last_update`, `dummy_column`)},
                                         after => undef },
              "Add 2 column Secondary Index");
    is_deeply($index_2_secondary->drop, { pre => q{DROP KEY `uidx_last_update_dummy_column`}, after => undef },
              "Drop 2 column Secondary Index");
 
    my $simple_pkey_hashref= $Ytkit::Test::SELECT_FROM_i_s_statistics::schema_table_name->{admintool}->{table_status_info}->{PRIMARY};
    ok(my $simple_pkey= Ytkit::AdminTool::ORM::Index->new_from_row($simple_pkey_hashref),
       "1 Column Primary Index new_from_row");
    is_deeply($simple_pkey->add, { pre => q{ADD PRIMARY KEY (`seq`)}, after => undef },
              "Add 1 column Primary Index");
    is_deeply($simple_pkey->drop, { pre => q{DROP PRIMARY KEY}, after => undef },
              "Drop 1 column Primary Index");
 
    my $complexed_pkey_hashref= $Ytkit::Test::SELECT_FROM_i_s_statistics::schema_table_name->{admintool}->{ytkit_option}->{PRIMARY};
    ok(my $complexed_pkey= Ytkit::AdminTool::ORM::Index->new_from_row($complexed_pkey_hashref),
       "2 Column Primary Index new_from_row");
    is_deeply($complexed_pkey->add, { pre => q{ADD PRIMARY KEY (`program_name`, `option_name`)}, after => undef },
              "Add 2 column Primary Index");
    is_deeply($simple_pkey->drop, { pre => q{DROP PRIMARY KEY}, after => undef },
              "Drop 2 column Primary Index");
 
    done_testing;
  };
  done_testing;
};


subtest "Ytkit::AdminTool::ORM::Table" => sub
{
  subtest "Simple 'new'" => sub
  {
    my $table_struct=
    {
      table_name    => "instance_info",
      column        => [make_column("--column_name=ipaddr", "--data_type=string"),
                        make_column("--column_name=port", "--data_type=int"),
                        make_column("--column_name=datadir", "--data_type=string"),
                        make_column("--column_name=last_update", "--data_type=datetime")],
      primary_key   => make_index("--column_name=ipaddr", "--column_name=port", "--is_primary=1"),
      secondary_key => [make_index("--column_name=ipaddr", "--column_name=datadir", "--is_unique=1"),
                        make_index("--column_name=last_update")],
    };
    ok(my $table= Ytkit::AdminTool::ORM::Table->new($table_struct), "Ytkit::AdminTool::ORM::Table::new");

    is($table->init, "CREATE TABLE instance_info (`ipaddr` VARCHAR(64) NOT NULL , `port` INT NOT NULL , `datadir` VARCHAR(64) NOT NULL , `last_update` DATETIME NOT NULL , PRIMARY KEY (`ipaddr`, `port`), UNIQUE KEY `uidx_ipaddr_datadir` (`ipaddr`, `datadir`),  KEY `idx_last_update` (`last_update`))", "CREATE TABLE statement");
    
  };

  subtest "new_from_row" => sub
  {
    #+-------------+-----------+-------------+----------------+
    #| column_name | data_type | is_nullable | column_default |
    #+-------------+-----------+-------------+----------------+
    #| User        | char      | NO          |                |
    #+-------------+-----------+-------------+----------------+
    my $test_hashref_user= $Ytkit::Test::SELECT_FROM_is_columns::mysql_user->{User};
    ok(my $column= Ytkit::AdminTool::ORM::Column->new_from_row($test_hashref_user), "new_from_row");
    is_deeply($column->add, { pre => q{ADD `User` VARCHAR(64) NOT NULL DEFAULT ''},
                              after => undef },
              "add method normalizes char to VARCHAR");
    is_deeply($column->modify, { pre => q{MODIFY `User` VARCHAR(64) NOT NULL DEFAULT ''},
                                 after => undef },
              "modify method normalizes char to VARCHAR");
    
    my $empty_hashref= {};
    my $empty= Ytkit::AdminTool::ORM::Column->new_from_row($empty_hashref);
    is($empty, undef, "new_from_row vs empty");
    done_testing;
  };

  subtest "compare" => sub
  {
    ok(my $column_from_hand= Ytkit::AdminTool::ORM::Column->new("--column_name=User",
                                                                "--data_type=string",
                                                                "--not_null=1",
                                                                "--default=''",
                                                                "--no-default=0"), "new by hand");
 
    #+-------------+-----------+-------------+----------------+
    #| column_name | data_type | is_nullable | column_default |
    #+-------------+-----------+-------------+----------------+
    #| User        | char      | NO          |                |
    #+-------------+-----------+-------------+----------------+
    my $test_hashref_user= $Ytkit::Test::SELECT_FROM_is_columns::mysql_user->{User};
    ok(my $column_from_row= Ytkit::AdminTool::ORM::Column->new_from_row($test_hashref_user), "new_from_row");

    is_deeply($column_from_hand->compare($column_from_row),
              { pre => undef, after => undef }, "2 columns are same");

    ok(my $another_attribute= Ytkit::AdminTool::ORM::Column->new("--column_name=User",
                                                                 "--data_type=clob",
                                                                 "--not_null=1",
                                                                 "--default=''",
                                                                 "--no-default=0"), "another by hand");
    is_deeply($column_from_hand->compare($another_attribute),
              { pre => q{MODIFY `User` VARCHAR(64) NOT NULL DEFAULT ''}, after => undef },
              "Use MODIFY to substitude different attribute");
 
    my $column_from_empty_row= Ytkit::AdminTool::ORM::Column->new_from_row({});
    is($column_from_empty_row, undef, "new_from_row vs Empty column");
    is_deeply($column_from_hand->compare($column_from_empty_row),
              { pre => q{ADD `User` VARCHAR(64) NOT NULL DEFAULT ''}, after => undef },
              "Use ADD to add a new column");

    my $another_hashref= $Ytkit::Test::SELECT_FROM_is_columns::mysql_user->{Host};
    my $another_column= Ytkit::AdminTool::ORM::Column->new_from_row($another_hashref);
    eval
    {
      $column_from_hand->compare($another_column);
    };
    ok($@, "call _croakf('Column names are different')");

    done_testing;
  };




};


done_testing;

