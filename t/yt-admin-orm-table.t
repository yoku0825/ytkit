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
use_ok("Ytkit::AdminTool::ORM::Table");


subtest "Ytkit::AdminTool::ORM::Table" => sub
{
  subtest "Simple 'new'" => sub
  {
    subtest "Without autoinc" => sub
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

      is($table->init, "CREATE TABLE `instance_info` (`ipaddr` VARCHAR(64) NOT NULL , `port` INT NOT NULL , `datadir` VARCHAR(64) NOT NULL , `last_update` DATETIME NOT NULL , PRIMARY KEY (`ipaddr`, `port`), UNIQUE KEY `uidx_ipaddr_datadir` (`ipaddr`, `datadir`),  KEY `idx_last_update` (`last_update`))", "CREATE TABLE statement");

      $table_struct->{foreign_key}= [make_fk("--column_name=ipaddr", "--column_name=port",
                                             "--references=dummy", "--action=cascade")];
      ok($table= Ytkit::AdminTool::ORM::Table->new($table_struct), "Ytkit::AdminTool::ORM::Table::new with FK");
      is($table->init, "CREATE TABLE `instance_info` (`ipaddr` VARCHAR(64) NOT NULL , `port` INT NOT NULL , `datadir` VARCHAR(64) NOT NULL , `last_update` DATETIME NOT NULL , PRIMARY KEY (`ipaddr`, `port`), UNIQUE KEY `uidx_ipaddr_datadir` (`ipaddr`, `datadir`),  KEY `idx_last_update` (`last_update`), CONSTRAINT `fidx_ipaddr_port` FOREIGN KEY `fidx_ipaddr_port` (`ipaddr`, `port`) REFERENCES `dummy` (`ipaddr`, `port`) ON UPDATE CASCADE ON DELETE CASCADE)", "CREATE TABLE statement with FK");

      my $table_struct_without_primary_key=
      {
        table_name    => "instance_info",
        column        => [make_column("--column_name=ipaddr", "--data_type=string"),
                          make_column("--column_name=port", "--data_type=int"),
                          make_column("--column_name=datadir", "--data_type=string"),
                          make_column("--column_name=last_update", "--data_type=datetime")],
        secondary_key => [make_index("--column_name=ipaddr", "--column_name=datadir", "--is_unique=1"),
                          make_index("--column_name=last_update")],
      };
      eval
      {
        $table= Ytkit::AdminTool::ORM::Table->new($table_struct_without_primary_key);
      };
      ok($@, "Table without PRIMARY KEY is croaked");

      done_testing;
    };

    subtest "With autoinc" => sub
    {
      my $table_struct=
      {
        table_name    => "instance_info",
        column        => [make_column("--column_name=seq", "--data_type=autoinc"),
                          make_column("--column_name=ipaddr", "--data_type=string"),
                          make_column("--column_name=port", "--data_type=int"),
                          make_column("--column_name=datadir", "--data_type=string"),
                          make_column("--column_name=last_update", "--data_type=datetime")],
        secondary_key => [make_index("--column_name=ipaddr", "--column_name=datadir", "--is_unique=1"),
                          make_index("--column_name=last_update")],
      };
      ok(my $table= Ytkit::AdminTool::ORM::Table->new($table_struct), "Ytkit::AdminTool::ORM::Table::new");

      is($table->init, "CREATE TABLE `instance_info` (`seq` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, `ipaddr` VARCHAR(64) NOT NULL , `port` INT NOT NULL , `datadir` VARCHAR(64) NOT NULL , `last_update` DATETIME NOT NULL , UNIQUE KEY `uidx_ipaddr_datadir` (`ipaddr`, `datadir`),  KEY `idx_last_update` (`last_update`))", "CREATE TABLE statement");

      my $table_struct_with_primary_key=
      {
        table_name    => "instance_info",
        column        => [make_column("--column_name=seq", "--data_type=autoinc"),
                          make_column("--column_name=ipaddr", "--data_type=string"),
                          make_column("--column_name=port", "--data_type=int"),
                          make_column("--column_name=datadir", "--data_type=string"),
                          make_column("--column_name=last_update", "--data_type=datetime")],
        primary_key   => make_index("--column_name=seq", "--is_primary=1"),
        secondary_key => [make_index("--column_name=ipaddr", "--column_name=datadir", "--is_unique=1"),
                          make_index("--column_name=last_update")],
      };

      eval
      {
        $table= Ytkit::AdminTool::ORM::Table->new($table_struct_with_primary_key);
      };
      ok($@, "Table with AUTO_INCREMENT and PRIMARY KEY is croaked");

      done_testing;
    };
    done_testing;
  };

  subtest "new_from_row" => sub
  {
    my @column_test_data= grep { $_->{table_name} eq "grant_info" } @{$Ytkit::Test::AdminTool::Column::columns};
    my @index_test_data = grep { $_->{table_name} eq "grant_info" } @{$Ytkit::Test::SELECT_FROM_i_s_statistics::indexes};

    ok(my $table= Ytkit::AdminTool::ORM::Table->new_from_row(\@column_test_data, \@index_test_data), "new_from_row");
    ### ForeignKey information is not support by new_from_row
    is($table->init, "CREATE TABLE `grant_info` (`ipaddr` VARCHAR(64) NOT NULL , `port` INT NOT NULL , `user_name` VARCHAR(64) NOT NULL , `user_host` VARCHAR(64) NOT NULL , `grants` TEXT NOT NULL , `last_update` DATETIME NOT NULL , PRIMARY KEY (`ipaddr`, `port`, `user_name`, `user_host`))", "new_from_row");

    my @column_test_data_with_autoinc= grep { $_->{table_name} eq "is_innodb_metrics" } @{$Ytkit::Test::AdminTool::Column::columns};
    my @index_test_data_with_autoinc = grep { $_->{table_name} eq "is_innodb_metrics" } @{$Ytkit::Test::SELECT_FROM_i_s_statistics::indexes};


    ok(my $table_with_autoinc= Ytkit::AdminTool::ORM::Table->new_from_row(\@column_test_data_with_autoinc, \@index_test_data_with_autoinc), "new_from_row with autoinc");
    is($table_with_autoinc->init, "CREATE TABLE `is_innodb_metrics` (`seq` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, `ipaddr` VARCHAR(64) NOT NULL , `port` INT NOT NULL , `name` VARCHAR(64) NOT NULL , `count` BIGINT UNSIGNED NOT NULL , `last_update` DATETIME NOT NULL ,  KEY `idx_last_update` (`last_update`))", "init with autoinc");
    done_testing;
  };

  subtest "compare" => sub
  {
    my @column_test_data= grep { $_->{table_name} eq "grant_info" } @{$Ytkit::Test::AdminTool::Column::columns};
    my @index_test_data = grep { $_->{table_name} eq "grant_info" } @{$Ytkit::Test::SELECT_FROM_i_s_statistics::indexes};

    ok(my $table_from_row = Ytkit::AdminTool::ORM::Table->new_from_row(\@column_test_data, \@index_test_data), "new_from_row");
    my $table_struct=
    {
      table_name    => "grant_info",
      column        => [make_column("--column_name=ipaddr", "--data_type=string"),
                        make_column("--column_name=port", "--data_type=int"),
                        make_column("--column_name=user_name", "--data_type=string"),
                        make_column("--column_name=user_host", "--data_type=string"),
                        make_column("--column_name=grants", "--data_type=clob"),
                        make_column("--column_name=last_update", "--data_type=datetime")],
      primary_key   => make_index("--column_name=ipaddr", "--column_name=port",
                                  "--column_name=user_name", "--column_name=user_host", "--is_primary=1"),
      foreign_key   => [make_fk("--column_name=ipaddr", "--column_name=port", "--references=instance_info", "--action=cascade")],
    };
 
    ok(my $table_from_hand= Ytkit::AdminTool::ORM::Table->new($table_struct), "new by hand");
    is($table_from_hand->compare($table_from_row), undef,
       "FK should be ignored, 2 objects are treated as same");

    my $table_struct2=
    {
      table_name    => "grant_info",
      column        => [make_column("--column_name=ipaddr", "--data_type=string"),
                        make_column("--column_name=port", "--data_type=int"),
                        make_column("--column_name=user_name", "--data_type=string"),
                        make_column("--column_name=user_host", "--data_type=string"),
                        make_column("--column_name=grants", "--data_type=clob"),
                        make_column("--column_name=last_update", "--data_type=datetime")],
      primary_key   => make_index("--column_name=ipaddr", "--column_name=port",
                                  "--column_name=user_name", "--column_name=user_host", "--is_primary=1"),
    };
    ok(my $table_from_hand_without_fk= Ytkit::AdminTool::ORM::Table->new($table_struct2), "new by hand without FK");
    is($table_from_hand_without_fk->compare($table_from_row), undef,
       "FK is already ignored, 2 objects are treated as same");

    my $table_struct3=
    {
      table_name    => "grant_info",
      column        => [make_column("--column_name=ipaddr", "--data_type=string"),
                        make_column("--column_name=port", "--data_type=int"),
                        make_column("--column_name=user_name", "--data_type=string"),
                        make_column("--column_name=user_host", "--data_type=string"),
                        make_column("--column_name=grants", "--data_type=clob"),],
      primary_key   => make_index("--column_name=ipaddr", "--column_name=port",
                                  "--column_name=user_name", "--column_name=user_host", "--is_primary=1"),
    };
    ok(my $table_from_hand_missed_col= Ytkit::AdminTool::ORM::Table->new($table_struct3), "new by hand without last_update");
    is($table_from_hand_missed_col->compare($table_from_row), 'ALTER TABLE `grant_info` DROP `last_update`;',
       "last_update should be dropped.");
    is($table_from_row->compare($table_from_hand_missed_col),
       q{ALTER TABLE `grant_info` ADD `last_update` DATETIME NOT NULL DEFAULT '1999-12-31 00:00:00';ALTER TABLE `grant_info` MODIFY `last_update` DATETIME NOT NULL ;},
       "last_update should be added (2-phase).");

    my $table_struct4=
    {
      table_name    => "grant_info",
      column        => [make_column("--column_name=ipaddr", "--data_type=string"),
                        make_column("--column_name=port", "--data_type=int"),
                        make_column("--column_name=user_name", "--data_type=string"),
                        make_column("--column_name=user_host", "--data_type=string"),
                        make_column("--column_name=grants", "--data_type=clob"),
                        make_column("--column_name=last_update", "--data_type=datetime")],
      primary_key   => make_index("--column_name=ipaddr", "--column_name=port",
                                  "--column_name=user_name", "--column_name=user_host", "--is_primary=1"),
      secondary_key => [make_index("--column_name=last_update"),
                        make_index("--column_name=user_host", "--column_name=user_name")],
      foreign_key   => [make_fk("--column_name=ipaddr", "--column_name=port", "--references=instance_info", "--action=cascade")],
    };
    ok(my $table_from_hand_add_index= Ytkit::AdminTool::ORM::Table->new($table_struct4), "new by hand add indexes");
    is($table_from_hand_add_index->compare($table_from_row),
       'ALTER TABLE `grant_info` ADD  KEY `idx_last_update` (`last_update`), ADD  KEY `idx_user_host_user_name` (`user_host`, `user_name`);',
       "Index added");
    is($table_from_row->compare($table_from_hand_add_index), undef, "extra INDEX should not be dropped");
    done_testing;
  };
  done_testing;
};


done_testing;

