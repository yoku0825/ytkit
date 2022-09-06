package Ytkit::xTest;

#########################################################################
# Copyright (C) 2020, 2022  yoku0825
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

our $mysql55= "5.5.62";
our $mysql56= "5.6.51";
our $mysql57= "5.7.39";
our $mysql80= "8.0.30";

our $version=
{
  $mysql55 => { mysqld => "/usr/mysql/$mysql55/bin/mysqld", mysql_install_db => "/usr/mysql/$mysql55/scripts/mysql_install_db" },
  $mysql56 => { mysqld => "/usr/mysql/$mysql56/bin/mysqld", mysql_install_db => "/usr/mysql/$mysql56/scripts/mysql_install_db" },
  $mysql57 => { mysqld => "/usr/mysql/$mysql57/bin/mysqld" },
  $mysql80 => { mysqld => "/usr/mysql/$mysql80/bin/mysqld" },
};


return 1;
