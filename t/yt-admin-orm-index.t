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

use_ok("Ytkit::AdminTool::ORM::Index");

subtest "Simple 'new'" => sub
{
  ok(my $index= Ytkit::AdminTool::ORM::Index->new("--column_name=num"), "Object 1 column Secondary Index");
  is_deeply($index->init, { pre => q{ KEY `idx_num` (`num`)}, after => undef }, "Ytkit::AdminTool::ORM::Index::init");
  is_deeply($index->add, { pre => q{ADD  KEY `idx_num` (`num`)}, after => undef }, "1 column Secondary Index add");
  is_deeply($index->drop, { pre => q{DROP KEY `idx_num`}, after => undef }, "1 column Secondary Index drop");

  ok(my $multi_index= Ytkit::AdminTool::ORM::Index->new("--column_name=b", "--column_name=a"),
     "Object 2 column Secondary Index");
  is_deeply($multi_index->add, { pre => q{ADD  KEY `idx_b_a` (`b`, `a`)}, after => undef }, "2 column Secondary Index add");
  is_deeply($multi_index->drop, { pre => q{DROP KEY `idx_b_a`}, after => undef }, "2 column Secondary Index drop");

  ok(my $primary= Ytkit::AdminTool::ORM::Index->new("--column_name=id", "--is_primary=1"), "Object 1 column Primary Index");
  is_deeply($primary->add, { pre => q{ADD PRIMARY KEY (`id`)}, after => undef }, "1 column Primary Index add");
  is_deeply($primary->drop, { pre => q{DROP PRIMARY KEY}, after => undef }, "1 column Primary Index drop");

  ok(my $multi_primary= Ytkit::AdminTool::ORM::Index->new("--column_name=ipaddr", "--column_name=port", "--is_primary=1"),
     "Object 2 column Primary Index");
  is_deeply($multi_primary->add, { pre => q{ADD PRIMARY KEY (`ipaddr`, `port`)}, after => undef },
            "2 column Primary Index add");
  is_deeply($multi_primary->drop, { pre => q{DROP PRIMARY KEY}, after => undef },
            "2 column Primary Index drop");

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
