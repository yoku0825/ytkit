package Ytkit::Test::AdminTool::Column;

$columns = [
          { ### 0
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'grant_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'grant_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'user_name',
            'column_default' => undef,
            'table_name' => 'grant_info',
            'is_nullable' => 'NO'
          },
          { ### 3
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'user_host',
            'column_default' => undef,
            'table_name' => 'grant_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'longtext',
            'table_schema' => 'admintool',
            'column_name' => 'grants',
            'column_default' => undef,
            'table_name' => 'grant_info',
            'is_nullable' => 'YES'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'grant_info',
            'is_nullable' => 'NO'
          },
          { ### 6
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'instance_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'instance_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'instance_info',
            'is_nullable' => 'NO'
          },
          { ### 9
            'column_extra' => '',
            'data_type' => 'tinyint',
            'table_schema' => 'admintool',
            'column_name' => 'monitoring_enable',
            'column_default' => '1',
            'table_name' => 'instance_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'tinyint',
            'table_schema' => 'admintool',
            'column_name' => 'last_status',
            'column_default' => '0',
            'table_name' => 'instance_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => 'auto_increment',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'seq',
            'column_default' => undef,
            'table_name' => 'is_innodb_metrics',
            'is_nullable' => 'NO'
          },
          { ### 12
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'is_innodb_metrics',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'is_innodb_metrics',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'name',
            'column_default' => undef,
            'table_name' => 'is_innodb_metrics',
            'is_nullable' => 'NO'
          },
          { ### 15
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'count',
            'column_default' => undef,
            'table_name' => 'is_innodb_metrics',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'is_innodb_metrics',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => 'auto_increment',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'seq',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          { ### 18
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'schema_name',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          { ### 21
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'digest',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'text',
            'table_schema' => 'admintool',
            'column_name' => 'digest_text',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'count_star',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          { ### 24
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_rows_examined',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_rows_sent',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          { ### 27
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_timer_wait',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_sort_rows',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_created_tmp_tables',
            'column_default' => undef,
            'table_name' => 'ps_digest_info',
            'is_nullable' => 'NO'
          },
          { ### 30
            'column_extra' => 'auto_increment',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'seq',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          { ### 33
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'table_schema',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'table_name',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'count_read',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          { ### 36
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'count_write',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_timer_read',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          { ### 39
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'sum_timer_write',
            'column_default' => undef,
            'table_name' => 'ps_table_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => '',
            'table_name' => 'slave_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => '0',
            'table_name' => 'slave_info',
            'is_nullable' => 'NO'
          },
          { ### 42
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'master_ipaddr',
            'column_default' => undef,
            'table_name' => 'slave_info',
            'is_nullable' => 'YES'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'master_port',
            'column_default' => undef,
            'table_name' => 'slave_info',
            'is_nullable' => 'YES'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'slave_info',
            'is_nullable' => 'NO'
          },
          { ### 45
            'column_extra' => 'auto_increment',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'seq',
            'column_default' => undef,
            'table_name' => 'status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'status_info',
            'is_nullable' => 'NO'
          },
          { ### 48
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'variable_name',
            'column_default' => undef,
            'table_name' => 'status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'text',
            'table_schema' => 'admintool',
            'column_name' => 'value',
            'column_default' => undef,
            'table_name' => 'status_info',
            'is_nullable' => 'YES'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'status_info',
            'is_nullable' => 'NO'
          },
          { ### 51
            'column_extra' => 'auto_increment',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'seq',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          { ### 54
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'table_schema',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'table_name',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'table_rows',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          { ### 57
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'data_length',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'index_length',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'bigint',
            'table_schema' => 'admintool',
            'column_name' => 'data_free',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          { ### 60
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'engine',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'table_status_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'ipaddr',
            'column_default' => undef,
            'table_name' => 'variable_info',
            'is_nullable' => 'NO'
          },
          { ### 63
            'column_extra' => '',
            'data_type' => 'smallint',
            'table_schema' => 'admintool',
            'column_name' => 'port',
            'column_default' => undef,
            'table_name' => 'variable_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'variable_name',
            'column_default' => undef,
            'table_name' => 'variable_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'text',
            'table_schema' => 'admintool',
            'column_name' => 'value',
            'column_default' => undef,
            'table_name' => 'variable_info',
            'is_nullable' => 'YES'
          },
          { ### 66
            'column_extra' => '',
            'data_type' => 'datetime',
            'table_schema' => 'admintool',
            'column_name' => 'last_update',
            'column_default' => undef,
            'table_name' => 'variable_info',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'program_name',
            'column_default' => undef,
            'table_name' => 'ytkit_option',
            'is_nullable' => 'NO'
          },
          {
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'option_name',
            'column_default' => undef,
            'table_name' => 'ytkit_option',
            'is_nullable' => 'NO'
          },
          { ### 69
            'column_extra' => '',
            'data_type' => 'varchar',
            'table_schema' => 'admintool',
            'column_name' => 'option_value',
            'column_default' => undef,
            'table_name' => 'ytkit_option',
            'is_nullable' => 'NO'
          }
        ];

return 1;
