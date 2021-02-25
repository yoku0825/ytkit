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

use_ok("Ytkit::AdminTool::ORM::ForeignKey");

subtest "Ytkit::AdminTool::ORM::ForeignKey" => sub
{
  subtest "Simple 'new'" => sub
  {
    ok(my $index= Ytkit::AdminTool::ORM::ForeignKey->new("--column_name=num",
                                                         "--reference_table=t2"), "Object 1 column Secondary Index");
    is_deeply($index->init, { pre   => q{CONSTRAINT `fidx_num` FOREIGN KEY `fidx_num` (`num`) REFERENCES `t2` (`num`) ON UPDATE RESTRICT ON DELETE RESTRICT}, 
                              after => undef },
              "Ytkit::AdminTool::ORM::ForeignKey::init");

    ok(my $multi_index= Ytkit::AdminTool::ORM::ForeignKey->new("--column_name=b", "--column_name=a",
                                                               "--references=t2"),
       "Object 2 column FK Index");
    is_deeply($multi_index->init, { pre => q{CONSTRAINT `fidx_b_a` FOREIGN KEY `fidx_b_a` (`b`, `a`) REFERENCES `t2` (`b`, `a`) ON UPDATE RESTRICT ON DELETE RESTRICT},
                                    after => undef }, "2 column FK Index init");
    done_testing;
  };
 
  done_testing;
};

done_testing;
