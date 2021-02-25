package Ytkit::Test::SELECT_FROM_i_s_statistics;

$indexes = [
          { ### 0
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'grant_info',
            '_columns' => 'ipaddr,port,user_name,user_host'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'instance_info',
            '_columns' => 'ipaddr,port'
          },
          {
            'index_name' => 'idx_lastupdate',
            'non_unique' => 1,
            'table_schema' => 'admintool',
            'table_name' => 'is_innodb_metrics',
            '_columns' => 'last_update'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'is_innodb_metrics',
            '_columns' => 'seq'
          },
          {
            'index_name' => 'idx_lastupdate',
            'non_unique' => 1,
            'table_schema' => 'admintool',
            'table_name' => 'ps_digest_info',
            '_columns' => 'last_update'
          },
          { ### 5
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'ps_digest_info',
            '_columns' => 'seq'
          },
          {
            'index_name' => 'idx_lastupdate',
            'non_unique' => 1,
            'table_schema' => 'admintool',
            'table_name' => 'ps_table_info',
            '_columns' => 'last_update'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'ps_table_info',
            '_columns' => 'seq'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'slave_info',
            '_columns' => 'ipaddr,port'
          },
          {
            'index_name' => 'idx_lastupdate',
            'non_unique' => 1,
            'table_schema' => 'admintool',
            'table_name' => 'status_info',
            '_columns' => 'last_update'
          },
          { ### 10
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'status_info',
            '_columns' => 'seq'
          },
          {
            'index_name' => 'idx_lastupdate',
            'non_unique' => 1,
            'table_schema' => 'admintool',
            'table_name' => 'table_status_info',
            '_columns' => 'last_update'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'table_status_info',
            '_columns' => 'seq'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'variable_info',
            '_columns' => 'ipaddr,port,variable_name'
          },
          {
            'index_name' => 'PRIMARY',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'ytkit_option',
            '_columns' => 'program_name,option_name'
          },
          { ### 15
            'index_name' => 'idx_dummy',
            'non_unique' => 0,
            'table_schema' => 'admintool',
            'table_name' => 'table_status_info',
            '_columns' => 'last_update,dummy_column'
          }
        ];
return 1;
