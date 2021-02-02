package Ytkit::Test::SELECT_FROM_i_s_statistics;

$schema_table_name = {
          'admintool' => {
                           'ytkit_option' => {
                                               'PRIMARY' => {
                                                              'index_name' => 'PRIMARY',
                                                              'non_unique' => 0,
                                                              'table_schema' => 'admintool',
                                                              'table_name' => 'ytkit_option',
                                                              '_columns' => 'program_name,option_name'
                                                            }
                                             },
                           'status_info' => {
                                              'idx_lastupdate' => {
                                                                    'index_name' => 'idx_lastupdate',
                                                                    'non_unique' => 1,
                                                                    'table_schema' => 'admintool',
                                                                    'table_name' => 'status_info',
                                                                    '_columns' => 'last_update'
                                                                  },
                                              'PRIMARY' => {
                                                             'index_name' => 'PRIMARY',
                                                             'non_unique' => 0,
                                                             'table_schema' => 'admintool',
                                                             'table_name' => 'status_info',
                                                             '_columns' => 'seq'
                                                           }
                                            },
                           'slave_info' => {
                                             'PRIMARY' => {
                                                            'index_name' => 'PRIMARY',
                                                            'non_unique' => 0,
                                                            'table_schema' => 'admintool',
                                                            'table_name' => 'slave_info',
                                                            '_columns' => 'ipaddr,port'
                                                          }
                                           },
                           'ps_digest_info' => {
                                                 'idx_lastupdate' => {
                                                                       'index_name' => 'idx_lastupdate',
                                                                       'non_unique' => 1,
                                                                       'table_schema' => 'admintool',
                                                                       'table_name' => 'ps_digest_info',
                                                                       '_columns' => 'last_update'
                                                                     },
                                                 'PRIMARY' => {
                                                                'index_name' => 'PRIMARY',
                                                                'non_unique' => 0,
                                                                'table_schema' => 'admintool',
                                                                'table_name' => 'ps_digest_info',
                                                                '_columns' => 'seq'
                                                              }
                                               },
                           'is_innodb_metrics' => {
                                                    'idx_lastupdate' => {
                                                                          'index_name' => 'idx_lastupdate',
                                                                          'non_unique' => 1,
                                                                          'table_schema' => 'admintool',
                                                                          'table_name' => 'is_innodb_metrics',
                                                                          '_columns' => 'last_update'
                                                                        },
                                                    'PRIMARY' => {
                                                                   'index_name' => 'PRIMARY',
                                                                   'non_unique' => 0,
                                                                   'table_schema' => 'admintool',
                                                                   'table_name' => 'is_innodb_metrics',
                                                                   '_columns' => 'seq'
                                                                 }
                                                  },
                           'ps_table_info' => {
                                                'idx_lastupdate' => {
                                                                      'index_name' => 'idx_lastupdate',
                                                                      'non_unique' => 1,
                                                                      'table_schema' => 'admintool',
                                                                      'table_name' => 'ps_table_info',
                                                                      '_columns' => 'last_update'
                                                                    },
                                                'PRIMARY' => {
                                                               'index_name' => 'PRIMARY',
                                                               'non_unique' => 0,
                                                               'table_schema' => 'admintool',
                                                               'table_name' => 'ps_table_info',
                                                               '_columns' => 'seq'
                                                             }
                                              },
                           'grant_info' => {
                                             'PRIMARY' => {
                                                            'index_name' => 'PRIMARY',
                                                            'non_unique' => 0,
                                                            'table_schema' => 'admintool',
                                                            'table_name' => 'grant_info',
                                                            '_columns' => 'ipaddr,port,user_name,user_host'
                                                          }
                                           },
                           'variable_info' => {
                                                'PRIMARY' => {
                                                               'index_name' => 'PRIMARY',
                                                               'non_unique' => 0,
                                                               'table_schema' => 'admintool',
                                                               'table_name' => 'variable_info',
                                                               '_columns' => 'ipaddr,port,variable_name'
                                                             }
                                              },
                           'instance_info' => {
                                                'PRIMARY' => {
                                                               'index_name' => 'PRIMARY',
                                                               'non_unique' => 0,
                                                               'table_schema' => 'admintool',
                                                               'table_name' => 'instance_info',
                                                               '_columns' => 'ipaddr,port'
                                                             }
                                              },
                           'table_status_info' => {
                                                    'idx_lastupdate' => {
                                                                          'index_name' => 'idx_lastupdate',
                                                                          'non_unique' => 1,
                                                                          'table_schema' => 'admintool',
                                                                          'table_name' => 'table_status_info',
                                                                          '_columns' => 'last_update'
                                                                        },
                                                    'PRIMARY' => {
                                                                   'index_name' => 'PRIMARY',
                                                                   'non_unique' => 0,
                                                                   'table_schema' => 'admintool',
                                                                   'table_name' => 'table_status_info',
                                                                   '_columns' => 'seq'
                                                                 },
                                                    'idx_dummy' => {
                                                                          'index_name' => 'idx_dummy',
                                                                          'non_unique' => 0,
                                                                          'table_schema' => 'admintool',
                                                                          'table_name' => 'table_status_info',
                                                                          '_columns' => 'last_update,dummy_column'
                                                                        },
 
                                                  }
                         }
        };

return 1;
