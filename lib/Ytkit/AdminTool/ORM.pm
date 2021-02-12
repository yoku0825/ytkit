package Ytkit::AdminTool::ORM;

########################################################################
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

use base "Exporter";
our @EXPORT= qw{ make_column make_index make_fk make_table };

use Ytkit::Config;
use Ytkit::AdminTool::ORM::Column;
use Ytkit::AdminTool::ORM::Index;
use Ytkit::AdminTool::ORM::ForeignKey;
use Ytkit::AdminTool::ORM::Table;

sub make_column
{
  return Ytkit::AdminTool::ORM::Column->new(@_);
}

sub make_index
{
  return Ytkit::AdminTool::ORM::Index->new(@_);
}

sub make_fk
{
  return Ytkit::AdminTool::ORM::ForeignKey->new(@_);
}

sub make_table
{
  return Ytkit::AdminTool::ORM::Table->new(@_);
}

return 1;
