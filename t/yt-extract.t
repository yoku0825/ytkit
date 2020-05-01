#!/usr/bin/perl

#########################################################################
# Copyright (C) 2020  yoku0825
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
Ytkit::Test->import(qw{ read_file });

no warnings "once";

use_ok("Ytkit::Extract");

### Dummy 
my $prog= Ytkit::Extract->new("--table=mysql.user");

subtest "DESC mysql.user" => sub
{
  $prog->instance->{_describe_table}= $Ytkit::Test::DESCRIBE_TABLE::MYSQL_USER;
  
  $prog->{exclude_column}= [];
  @{$prog}{"only_no_default", "only_not_null"}= (0, 0);
  is($prog->column_list_string, "Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, Event_priv, Trigger_priv, Create_tablespace_priv, ssl_type, ssl_cipher, x509_issuer, x509_subject, max_questions, max_updates, max_connections, max_user_connections, plugin, authentication_string, password_expired, password_last_changed, password_lifetime, account_locked, Create_role_priv, Drop_role_priv, Password_reuse_history, Password_reuse_time, Password_require_current, User_attributes", "Print all columns");
  delete($prog->{_filtered_column_list});
  
  @{$prog}{"only_no_default", "only_not_null"}= (1, 0);
  is($prog->column_list_string, "ssl_cipher, x509_issuer, x509_subject, authentication_string, password_last_changed, password_lifetime, Password_reuse_history, Password_reuse_time, Password_require_current, User_attributes", "Columns which don't have DEFAULT");
  delete($prog->{_filtered_column_list});
  
  @{$prog}{"only_no_default", "only_not_null"}= (0, 1);
  is($prog->column_list_string, "Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, Event_priv, Trigger_priv, Create_tablespace_priv, ssl_type, ssl_cipher, x509_issuer, x509_subject, max_questions, max_updates, max_connections, max_user_connections, plugin, password_expired, account_locked, Create_role_priv, Drop_role_priv", "NOT NULL columns");
  delete($prog->{_filtered_column_list});
  
  @{$prog}{"only_no_default", "only_not_null"}= (1, 1);
  is($prog->column_list_string, "ssl_cipher, x509_issuer, x509_subject", "NOT NULL and DEFAULT NULL columns");
  delete($prog->{_filtered_column_list});
  
  
  $prog->{exclude_column}= ["ssl_cipher", "x509_issuer"];
  @{$prog}{"only_no_default", "only_not_null"}= (1, 0);
  delete($prog->{_filtered_column_list});
  is($prog->column_list_string, "x509_subject, authentication_string, password_last_changed, password_lifetime, Password_reuse_history, Password_reuse_time, Password_require_current, User_attributes", "Filter by --exclude_column");
  delete($prog->{_filtered_column_list});
  
  ### Shorter list is better for testing..
  $prog->{exclude_column}= [];
  @{$prog}{"only_no_default", "only_not_null"}= (1, 1);
  is($prog->extract_as_select,
     "SELECT ssl_cipher, x509_issuer, x509_subject FROM mysql.user;\n",
     "--output=select");
  is($prog->extract_as_insert,
     "INSERT INTO mysql.user (ssl_cipher, x509_issuer, x509_subject) VALUES (?, ?, ?);\n",
     "--output=insert");
   is($prog->extract_as_insert_set,
     "INSERT INTO mysql.user SET ssl_cipher = ?, x509_issuer = ?, x509_subject = ?;\n",
     "--output=insert-set");
  is($prog->extract_as_replace,
     "REPLACE INTO mysql.user (ssl_cipher, x509_issuer, x509_subject) VALUES (?, ?, ?);\n",
     "--output=replace");
  is($prog->extract_as_update,
     "UPDATE mysql.user SET ssl_cipher = ?, x509_issuer = ?, x509_subject = ? WHERE Host = ? AND User = ?;\n",
     "--output=update");
  delete($prog->{_filtered_column_list});
  delete($prog->{_orig_column_list});
  done_testing;
};
  
subtest "DESC Non-PK Table" => sub
{
  $prog->{table}= "d1.t1";
  $prog->instance->{_describe_table}= $Ytkit::Test::DESCRIBE_TABLE::NO_PK;

  $prog->{exclude_column}= [];
  @{$prog}{"only_no_default", "only_not_null"}= (0, 0);
  is($prog->extract_as_select,
     "SELECT _datetime, _timestamp FROM d1.t1;\n",
     "This is not problem");
  delete($prog->{_filtered_column_list});

  eval
  {
    $prog->extract_as_update;
  };
  ok($@, "Non-PK --output=update should be error");
  delete($prog->{_filtered_column_list});


  @{$prog}{"only_no_default", "only_not_null"}= (0, 1);
  eval
  {
    $prog->extract_as_select;
  };
  ok($@, "No select_list is left, should be error.");
  delete($prog->{_filtered_column_list});

  done_testing;
};
done_testing;


exit 0;
