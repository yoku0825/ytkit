package Ytkit::Test::DESCRIBE_TABLE;

$MYSQL_USER = [
          {
            'Field' => 'Host',
            'Type' => 'char(255)',
            'Extra' => '',
            'Default' => '',
            'Null' => 'NO',
            'Key' => 'PRI'
          },
          {
            'Field' => 'User',
            'Type' => 'char(32)',
            'Extra' => '',
            'Default' => '',
            'Null' => 'NO',
            'Key' => 'PRI'
          },
          {
            'Field' => 'Select_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Insert_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Update_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Delete_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Drop_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Reload_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Shutdown_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Process_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'File_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Grant_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'References_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Index_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Alter_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Show_db_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Super_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_tmp_table_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Lock_tables_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Execute_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Repl_slave_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Repl_client_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_view_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Show_view_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_routine_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Alter_routine_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_user_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Event_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Trigger_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_tablespace_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'ssl_type',
            'Type' => 'enum(\'\',\'ANY\',\'X509\',\'SPECIFIED\')',
            'Extra' => '',
            'Default' => '',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'ssl_cipher',
            'Type' => 'blob',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'x509_issuer',
            'Type' => 'blob',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'x509_subject',
            'Type' => 'blob',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'max_questions',
            'Type' => 'int unsigned',
            'Extra' => '',
            'Default' => '0',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'max_updates',
            'Type' => 'int unsigned',
            'Extra' => '',
            'Default' => '0',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'max_connections',
            'Type' => 'int unsigned',
            'Extra' => '',
            'Default' => '0',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'max_user_connections',
            'Type' => 'int unsigned',
            'Extra' => '',
            'Default' => '0',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'plugin',
            'Type' => 'char(64)',
            'Extra' => '',
            'Default' => 'caching_sha2_password',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'authentication_string',
            'Type' => 'text',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => 'password_expired',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'password_last_changed',
            'Type' => 'timestamp',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => 'password_lifetime',
            'Type' => 'smallint unsigned',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => 'account_locked',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Create_role_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Drop_role_priv',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => 'N',
            'Null' => 'NO',
            'Key' => ''
          },
          {
            'Field' => 'Password_reuse_history',
            'Type' => 'smallint unsigned',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => 'Password_reuse_time',
            'Type' => 'smallint unsigned',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => 'Password_require_current',
            'Type' => 'enum(\'N\',\'Y\')',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => 'User_attributes',
            'Type' => 'json',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          }
        ];

$NO_PK = [
          {
            'Field' => '_datetime',
            'Type' => 'datetime',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          },
          {
            'Field' => '_timestamp',
            'Type' => 'timestamp',
            'Extra' => '',
            'Default' => undef,
            'Null' => 'YES',
            'Key' => ''
          }
        ];

return 1;
