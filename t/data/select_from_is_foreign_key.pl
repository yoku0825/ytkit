package Ytkit::Test::SELECT_FROM_is_foreign_key;

$admintool_fk = {
          'status_info' => {
                             'status_info_ibfk_1' => {
                                                       'ref_col_name' => 'ipaddr,port',
                                                       'update_rule' => 'CASCADE',
                                                       'constraint_name' => 'status_info_ibfk_1',
                                                       'for_col_name' => 'ipaddr,port',
                                                       'table_name' => 'status_info',
                                                       'constraint_schema' => 'admintool',
                                                       'referenced_table_name' => 'instance_info',
                                                       'delete_rule' => 'CASCADE'
                                                     }
                           },
          'slave_info' => {
                            'slave_info_ibfk_2' => {
                                                     'ref_col_name' => 'ipaddr,port',
                                                     'update_rule' => 'CASCADE',
                                                     'constraint_name' => 'slave_info_ibfk_2',
                                                     'for_col_name' => 'ipaddr,port',
                                                     'table_name' => 'slave_info',
                                                     'constraint_schema' => 'admintool',
                                                     'referenced_table_name' => 'instance_info',
                                                     'delete_rule' => 'CASCADE'
                                                   }
                          },
          'ps_digest_info' => {
                                'ps_digest_info_ibfk_1' => {
                                                             'ref_col_name' => 'ipaddr,port',
                                                             'update_rule' => 'CASCADE',
                                                             'constraint_name' => 'ps_digest_info_ibfk_1',
                                                             'for_col_name' => 'ipaddr,port',
                                                             'table_name' => 'ps_digest_info',
                                                             'constraint_schema' => 'admintool',
                                                             'referenced_table_name' => 'instance_info',
                                                             'delete_rule' => 'CASCADE'
                                                           }
                              },
          'is_innodb_metrics' => {
                                   'is_innodb_metrics_ibfk_1' => {
                                                                   'ref_col_name' => 'ipaddr,port',
                                                                   'update_rule' => 'CASCADE',
                                                                   'constraint_name' => 'is_innodb_metrics_ibfk_1',
                                                                   'for_col_name' => 'ipaddr,port',
                                                                   'table_name' => 'is_innodb_metrics',
                                                                   'constraint_schema' => 'admintool',
                                                                   'referenced_table_name' => 'instance_info',
                                                                   'delete_rule' => 'CASCADE'
                                                                 }
                                 },
          'ps_table_info' => {
                               'ps_table_info_ibfk_1' => {
                                                           'ref_col_name' => 'ipaddr,port',
                                                           'update_rule' => 'CASCADE',
                                                           'constraint_name' => 'ps_table_info_ibfk_1',
                                                           'for_col_name' => 'ipaddr,port',
                                                           'table_name' => 'ps_table_info',
                                                           'constraint_schema' => 'admintool',
                                                           'referenced_table_name' => 'instance_info',
                                                           'delete_rule' => 'CASCADE'
                                                         }
                             },
          'grant_info' => {
                            'grant_info_ibfk_1' => {
                                                     'ref_col_name' => 'ipaddr,port',
                                                     'update_rule' => 'CASCADE',
                                                     'constraint_name' => 'grant_info_ibfk_1',
                                                     'for_col_name' => 'ipaddr,port',
                                                     'table_name' => 'grant_info',
                                                     'constraint_schema' => 'admintool',
                                                     'referenced_table_name' => 'instance_info',
                                                     'delete_rule' => 'CASCADE'
                                                   }
                          },
          'variable_info' => {
                               'variable_info_ibfk_1' => {
                                                           'ref_col_name' => 'ipaddr,port',
                                                           'update_rule' => 'CASCADE',
                                                           'constraint_name' => 'variable_info_ibfk_1',
                                                           'for_col_name' => 'ipaddr,port',
                                                           'table_name' => 'variable_info',
                                                           'constraint_schema' => 'admintool',
                                                           'referenced_table_name' => 'instance_info',
                                                           'delete_rule' => 'CASCADE'
                                                         }
                             },
          'table_status_info' => {
                                   'table_status_info_ibfk_1' => {
                                                                   'ref_col_name' => 'ipaddr,port',
                                                                   'update_rule' => 'CASCADE',
                                                                   'constraint_name' => 'table_status_info_ibfk_1',
                                                                   'for_col_name' => 'ipaddr,port',
                                                                   'table_name' => 'table_status_info',
                                                                   'constraint_schema' => 'admintool',
                                                                   'referenced_table_name' => 'instance_info',
                                                                   'delete_rule' => 'CASCADE'
                                                                 }
                                 }
        };

return 1;
