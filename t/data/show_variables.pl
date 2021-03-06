package Ytkit::Test::SHOW_VARIABLES;

use Clone qw{ clone };

$mysql57_ps_on = {
          'max_allowed_packet' => {
                                    'Value' => '4194304',
                                    'Variable_name' => 'max_allowed_packet'
                                  },
          'innodb_api_trx_level' => {
                                      'Value' => '0',
                                      'Variable_name' => 'innodb_api_trx_level'
                                    },
          'performance_schema_max_memory_classes' => {
                                                       'Value' => '320',
                                                       'Variable_name' => 'performance_schema_max_memory_classes'
                                                     },
          'thread_stack' => {
                              'Value' => '262144',
                              'Variable_name' => 'thread_stack'
                            },
          'sql_buffer_result' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'sql_buffer_result'
                                 },
          'example_enum_var' => {
                                  'Value' => 'e1',
                                  'Variable_name' => 'example_enum_var'
                                },
          'character_sets_dir' => {
                                    'Value' => '/usr/mysql/5.7.19/share/charsets/',
                                    'Variable_name' => 'character_sets_dir'
                                  },
          'innodb_log_checksums' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'innodb_log_checksums'
                                    },
          'max_insert_delayed_threads' => {
                                            'Value' => '20',
                                            'Variable_name' => 'max_insert_delayed_threads'
                                          },
          'low_priority_updates' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'low_priority_updates'
                                    },
          'pid_file' => {
                          'Value' => '/usr/mysql/5.7.19/data/mysql.pid',
                          'Variable_name' => 'pid_file'
                        },
          'innodb_page_cleaners' => {
                                      'Value' => '4',
                                      'Variable_name' => 'innodb_page_cleaners'
                                    },
          'innodb_flushing_avg_loops' => {
                                           'Value' => '30',
                                           'Variable_name' => 'innodb_flushing_avg_loops'
                                         },
          'innodb_buffer_pool_load_now' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_buffer_pool_load_now'
                                           },
          'ngram_token_size' => {
                                  'Value' => '2',
                                  'Variable_name' => 'ngram_token_size'
                                },
          'ssl_key' => {
                         'Value' => '',
                         'Variable_name' => 'ssl_key'
                       },
          'sql_big_selects' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'sql_big_selects'
                               },
          'performance_schema_events_waits_history_long_size' => {
                                                                   'Value' => '1000',
                                                                   'Variable_name' => 'performance_schema_events_waits_history_long_size'
                                                                 },
          'binlog_max_flush_queue_time' => {
                                             'Value' => '0',
                                             'Variable_name' => 'binlog_max_flush_queue_time'
                                           },
          'multi_range_count' => {
                                   'Value' => '256',
                                   'Variable_name' => 'multi_range_count'
                                 },
          'gtid_owned' => {
                            'Value' => '',
                            'Variable_name' => 'gtid_owned'
                          },
          'innodb_compression_level' => {
                                          'Value' => '6',
                                          'Variable_name' => 'innodb_compression_level'
                                        },
          'net_retry_count' => {
                                 'Value' => '10',
                                 'Variable_name' => 'net_retry_count'
                               },
          'offline_mode' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'offline_mode'
                            },
          'innodb_deadlock_detect' => {
                                        'Value' => 'ON',
                                        'Variable_name' => 'innodb_deadlock_detect'
                                      },
          'old' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'old'
                   },
          'slave_load_tmpdir' => {
                                   'Value' => '/tmp',
                                   'Variable_name' => 'slave_load_tmpdir'
                                 },
          'innodb_monitor_reset_all' => {
                                          'Value' => '',
                                          'Variable_name' => 'innodb_monitor_reset_all'
                                        },
          'auto_increment_increment' => {
                                          'Value' => '1',
                                          'Variable_name' => 'auto_increment_increment'
                                        },
          'innodb_max_dirty_pages_pct' => {
                                            'Value' => '75.000000',
                                            'Variable_name' => 'innodb_max_dirty_pages_pct'
                                          },
          'innodb_buffer_pool_filename' => {
                                             'Value' => 'ib_buffer_pool',
                                             'Variable_name' => 'innodb_buffer_pool_filename'
                                           },
          'have_ssl' => {
                          'Value' => 'DISABLED',
                          'Variable_name' => 'have_ssl'
                        },
          'version_compile_machine' => {
                                         'Value' => 'x86_64',
                                         'Variable_name' => 'version_compile_machine'
                                       },
          'parser_max_mem_size' => {
                                     'Value' => '18446744073709551615',
                                     'Variable_name' => 'parser_max_mem_size'
                                   },
          'innodb_fill_factor' => {
                                    'Value' => '100',
                                    'Variable_name' => 'innodb_fill_factor'
                                  },
          'auto_increment_offset' => {
                                       'Value' => '1',
                                       'Variable_name' => 'auto_increment_offset'
                                     },
          'innodb_stats_include_delete_marked' => {
                                                    'Value' => 'OFF',
                                                    'Variable_name' => 'innodb_stats_include_delete_marked'
                                                  },
          'performance_schema_max_table_instances' => {
                                                        'Value' => '-1',
                                                        'Variable_name' => 'performance_schema_max_table_instances'
                                                      },
          'performance_schema_max_socket_instances' => {
                                                         'Value' => '-1',
                                                         'Variable_name' => 'performance_schema_max_socket_instances'
                                                       },
          'large_files_support' => {
                                     'Value' => 'ON',
                                     'Variable_name' => 'large_files_support'
                                   },
          'lock_wait_timeout' => {
                                   'Value' => '31536000',
                                   'Variable_name' => 'lock_wait_timeout'
                                 },
          'lower_case_table_names' => {
                                        'Value' => '1',
                                        'Variable_name' => 'lower_case_table_names'
                                      },
          'secure_auth' => {
                             'Value' => 'ON',
                             'Variable_name' => 'secure_auth'
                           },
          'innodb_stats_persistent' => {
                                         'Value' => 'ON',
                                         'Variable_name' => 'innodb_stats_persistent'
                                       },
          'log_bin' => {
                         'Value' => 'ON',
                         'Variable_name' => 'log_bin'
                       },
          'slave_checkpoint_period' => {
                                         'Value' => '300',
                                         'Variable_name' => 'slave_checkpoint_period'
                                       },
          'innodb_purge_rseg_truncate_frequency' => {
                                                      'Value' => '128',
                                                      'Variable_name' => 'innodb_purge_rseg_truncate_frequency'
                                                    },
          'sql_notes' => {
                           'Value' => 'ON',
                           'Variable_name' => 'sql_notes'
                         },
          'default_authentication_plugin' => {
                                               'Value' => 'mysql_native_password',
                                               'Variable_name' => 'default_authentication_plugin'
                                             },
          'version' => {
                         'Value' => '5.7.19-log',
                         'Variable_name' => 'version'
                       },
          'innodb_file_per_table' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_file_per_table'
                                     },
          'innodb_adaptive_hash_index_parts' => {
                                                  'Value' => '8',
                                                  'Variable_name' => 'innodb_adaptive_hash_index_parts'
                                                },
          'init_connect' => {
                              'Value' => '',
                              'Variable_name' => 'init_connect'
                            },
          'slave_net_timeout' => {
                                   'Value' => '60',
                                   'Variable_name' => 'slave_net_timeout'
                                 },
          'datadir' => {
                         'Value' => '/usr/mysql/5.7.19/data/',
                         'Variable_name' => 'datadir'
                       },
          'read_rnd_buffer_size' => {
                                      'Value' => '262144',
                                      'Variable_name' => 'read_rnd_buffer_size'
                                    },
          'innodb_api_enable_mdl' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'innodb_api_enable_mdl'
                                     },
          'sql_auto_is_null' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'sql_auto_is_null'
                                },
          'general_log' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'general_log'
                           },
          'innodb_buffer_pool_chunk_size' => {
                                               'Value' => '134217728',
                                               'Variable_name' => 'innodb_buffer_pool_chunk_size'
                                             },
          'transaction_write_set_extraction' => {
                                                  'Value' => 'OFF',
                                                  'Variable_name' => 'transaction_write_set_extraction'
                                                },
          'report_password' => {
                                 'Value' => '',
                                 'Variable_name' => 'report_password'
                               },
          'binlog_row_image' => {
                                  'Value' => 'FULL',
                                  'Variable_name' => 'binlog_row_image'
                                },
          'have_statement_timeout' => {
                                        'Value' => 'YES',
                                        'Variable_name' => 'have_statement_timeout'
                                      },
          'min_examined_row_limit' => {
                                        'Value' => '0',
                                        'Variable_name' => 'min_examined_row_limit'
                                      },
          'max_user_connections' => {
                                      'Value' => '0',
                                      'Variable_name' => 'max_user_connections'
                                    },
          'innodb_max_dirty_pages_pct_lwm' => {
                                                'Value' => '0.000000',
                                                'Variable_name' => 'innodb_max_dirty_pages_pct_lwm'
                                              },
          'gtid_executed' => {
                               'Value' => '1d87f577-6b80-11e7-8865-0201a32caf75:1-50243',
                               'Variable_name' => 'gtid_executed'
                             },
          'innodb_ft_enable_diag_print' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_ft_enable_diag_print'
                                           },
          'max_sp_recursion_depth' => {
                                        'Value' => '0',
                                        'Variable_name' => 'max_sp_recursion_depth'
                                      },
          'show_old_temporals' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'show_old_temporals'
                                  },
          'innodb_log_group_home_dir' => {
                                           'Value' => './',
                                           'Variable_name' => 'innodb_log_group_home_dir'
                                         },
          'innodb_compression_failure_threshold_pct' => {
                                                          'Value' => '5',
                                                          'Variable_name' => 'innodb_compression_failure_threshold_pct'
                                                        },
          'delay_key_write' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'delay_key_write'
                               },
          'innodb_buffer_pool_dump_pct' => {
                                             'Value' => '25',
                                             'Variable_name' => 'innodb_buffer_pool_dump_pct'
                                           },
          'optimizer_trace_offset' => {
                                        'Value' => '-1',
                                        'Variable_name' => 'optimizer_trace_offset'
                                      },
          'performance_schema_max_stage_classes' => {
                                                      'Value' => '150',
                                                      'Variable_name' => 'performance_schema_max_stage_classes'
                                                    },
          'myisam_max_sort_file_size' => {
                                           'Value' => '9223372036853727232',
                                           'Variable_name' => 'myisam_max_sort_file_size'
                                         },
          'innodb_undo_tablespaces' => {
                                         'Value' => '0',
                                         'Variable_name' => 'innodb_undo_tablespaces'
                                       },
          'innodb_flush_log_at_trx_commit' => {
                                                'Value' => '1',
                                                'Variable_name' => 'innodb_flush_log_at_trx_commit'
                                              },
          'innodb_doublewrite' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'innodb_doublewrite'
                                  },
          'performance_schema_setup_objects_size' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_setup_objects_size'
                                                     },
          'innodb_thread_concurrency' => {
                                           'Value' => '0',
                                           'Variable_name' => 'innodb_thread_concurrency'
                                         },
          'innodb_sort_buffer_size' => {
                                         'Value' => '1048576',
                                         'Variable_name' => 'innodb_sort_buffer_size'
                                       },
          'innodb_stats_sample_pages' => {
                                           'Value' => '8',
                                           'Variable_name' => 'innodb_stats_sample_pages'
                                         },
          'metadata_locks_hash_instances' => {
                                               'Value' => '8',
                                               'Variable_name' => 'metadata_locks_hash_instances'
                                             },
          'log_syslog_include_pid' => {
                                        'Value' => 'ON',
                                        'Variable_name' => 'log_syslog_include_pid'
                                      },
          'relay_log_purge' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'relay_log_purge'
                               },
          'bulk_insert_buffer_size' => {
                                         'Value' => '8388608',
                                         'Variable_name' => 'bulk_insert_buffer_size'
                                       },
          'binlog_error_action' => {
                                     'Value' => 'ABORT_SERVER',
                                     'Variable_name' => 'binlog_error_action'
                                   },
          'session_track_state_change' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'session_track_state_change'
                                          },
          'back_log' => {
                          'Value' => '80',
                          'Variable_name' => 'back_log'
                        },
          'sql_log_off' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'sql_log_off'
                           },
          'server_id' => {
                           'Value' => '1057',
                           'Variable_name' => 'server_id'
                         },
          'performance_schema_events_transactions_history_size' => {
                                                                     'Value' => '10',
                                                                     'Variable_name' => 'performance_schema_events_transactions_history_size'
                                                                   },
          'open_files_limit' => {
                                  'Value' => '1024',
                                  'Variable_name' => 'open_files_limit'
                                },
          'innodb_ft_cache_size' => {
                                      'Value' => '8000000',
                                      'Variable_name' => 'innodb_ft_cache_size'
                                    },
          'relay_log_info_repository' => {
                                           'Value' => 'FILE',
                                           'Variable_name' => 'relay_log_info_repository'
                                         },
          'binlog_gtid_simple_recovery' => {
                                             'Value' => 'ON',
                                             'Variable_name' => 'binlog_gtid_simple_recovery'
                                           },
          'innodb_buffer_pool_dump_at_shutdown' => {
                                                     'Value' => 'ON',
                                                     'Variable_name' => 'innodb_buffer_pool_dump_at_shutdown'
                                                   },
          'enforce_gtid_consistency' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'enforce_gtid_consistency'
                                        },
          'innodb_table_locks' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_table_locks'
                                  },
          'ssl_cert' => {
                          'Value' => '',
                          'Variable_name' => 'ssl_cert'
                        },
          'key_cache_block_size' => {
                                      'Value' => '1024',
                                      'Variable_name' => 'key_cache_block_size'
                                    },
          'performance_schema_max_table_handles' => {
                                                      'Value' => '-1',
                                                      'Variable_name' => 'performance_schema_max_table_handles'
                                                    },
          'sync_frm' => {
                          'Value' => 'ON',
                          'Variable_name' => 'sync_frm'
                        },
          'sort_buffer_size' => {
                                  'Value' => '262144',
                                  'Variable_name' => 'sort_buffer_size'
                                },
          'have_crypt' => {
                            'Value' => 'YES',
                            'Variable_name' => 'have_crypt'
                          },
          'session_track_transaction_info' => {
                                                'Value' => 'OFF',
                                                'Variable_name' => 'session_track_transaction_info'
                                              },
          'have_rtree_keys' => {
                                 'Value' => 'YES',
                                 'Variable_name' => 'have_rtree_keys'
                               },
          'optimizer_search_depth' => {
                                        'Value' => '62',
                                        'Variable_name' => 'optimizer_search_depth'
                                      },
          'concurrent_insert' => {
                                   'Value' => 'AUTO',
                                   'Variable_name' => 'concurrent_insert'
                                 },
          'innodb_flush_log_at_timeout' => {
                                             'Value' => '1',
                                             'Variable_name' => 'innodb_flush_log_at_timeout'
                                           },
          'sql_slave_skip_counter' => {
                                        'Value' => '0',
                                        'Variable_name' => 'sql_slave_skip_counter'
                                      },
          'performance_schema_hosts_size' => {
                                               'Value' => '-1',
                                               'Variable_name' => 'performance_schema_hosts_size'
                                             },
          'end_markers_in_json' => {
                                     'Value' => 'OFF',
                                     'Variable_name' => 'end_markers_in_json'
                                   },
          'thread_handling' => {
                                 'Value' => 'one-thread-per-connection',
                                 'Variable_name' => 'thread_handling'
                               },
          'net_read_timeout' => {
                                  'Value' => '30',
                                  'Variable_name' => 'net_read_timeout'
                                },
          'log_slow_slave_statements' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'log_slow_slave_statements'
                                         },
          'have_symlink' => {
                              'Value' => 'YES',
                              'Variable_name' => 'have_symlink'
                            },
          'sql_quote_show_create' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'sql_quote_show_create'
                                     },
          'innodb_undo_logs' => {
                                  'Value' => '128',
                                  'Variable_name' => 'innodb_undo_logs'
                                },
          'slow_query_log_file' => {
                                     'Value' => 'slow.log',
                                     'Variable_name' => 'slow_query_log_file'
                                   },
          'performance_schema_max_file_handles' => {
                                                     'Value' => '32768',
                                                     'Variable_name' => 'performance_schema_max_file_handles'
                                                   },
          'max_error_count' => {
                                 'Value' => '64',
                                 'Variable_name' => 'max_error_count'
                               },
          'net_buffer_length' => {
                                   'Value' => '16384',
                                   'Variable_name' => 'net_buffer_length'
                                 },
          'have_dynamic_loading' => {
                                      'Value' => 'YES',
                                      'Variable_name' => 'have_dynamic_loading'
                                    },
          'example_ulong_var' => {
                                   'Value' => '8',
                                   'Variable_name' => 'example_ulong_var'
                                 },
          'innodb_print_all_deadlocks' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_print_all_deadlocks'
                                          },
          'automatic_sp_privileges' => {
                                         'Value' => 'ON',
                                         'Variable_name' => 'automatic_sp_privileges'
                                       },
          'innodb_ft_server_stopword_table' => {
                                                 'Value' => '',
                                                 'Variable_name' => 'innodb_ft_server_stopword_table'
                                               },
          'block_encryption_mode' => {
                                       'Value' => 'aes-128-ecb',
                                       'Variable_name' => 'block_encryption_mode'
                                     },
          'hostname' => {
                          'Value' => '163-44-175-117',
                          'Variable_name' => 'hostname'
                        },
          'innodb_file_format' => {
                                    'Value' => 'Barracuda',
                                    'Variable_name' => 'innodb_file_format'
                                  },
          'innodb_checksum_algorithm' => {
                                           'Value' => 'crc32',
                                           'Variable_name' => 'innodb_checksum_algorithm'
                                         },
          'ssl_crlpath' => {
                             'Value' => '',
                             'Variable_name' => 'ssl_crlpath'
                           },
          'autocommit' => {
                            'Value' => 'ON',
                            'Variable_name' => 'autocommit'
                          },
          'max_connections' => {
                                 'Value' => '151',
                                 'Variable_name' => 'max_connections'
                               },
          'log_bin_use_v1_row_events' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'log_bin_use_v1_row_events'
                                         },
          'lc_messages_dir' => {
                                 'Value' => '/usr/mysql/5.7.19/share/',
                                 'Variable_name' => 'lc_messages_dir'
                               },
          'innodb_stats_auto_recalc' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_stats_auto_recalc'
                                        },
          'innodb_flush_method' => {
                                     'Value' => 'O_DIRECT',
                                     'Variable_name' => 'innodb_flush_method'
                                   },
          'binlog_order_commits' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'binlog_order_commits'
                                    },
          'group_concat_max_len' => {
                                      'Value' => '1024',
                                      'Variable_name' => 'group_concat_max_len'
                                    },
          'relay_log_info_file' => {
                                     'Value' => 'relay-log.info',
                                     'Variable_name' => 'relay_log_info_file'
                                   },
          'example_double_thdvar' => {
                                       'Value' => '8.500000',
                                       'Variable_name' => 'example_double_thdvar'
                                     },
          'connect_timeout' => {
                                 'Value' => '10',
                                 'Variable_name' => 'connect_timeout'
                               },
          'sha256_password_proxy_users' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'sha256_password_proxy_users'
                                           },
          'performance_schema_events_stages_history_size' => {
                                                               'Value' => '10',
                                                               'Variable_name' => 'performance_schema_events_stages_history_size'
                                                             },
          'innodb_page_size' => {
                                  'Value' => '16384',
                                  'Variable_name' => 'innodb_page_size'
                                },
          'optimizer_trace' => {
                                 'Value' => 'enabled=off,one_line=off',
                                 'Variable_name' => 'optimizer_trace'
                               },
          'local_infile' => {
                              'Value' => 'ON',
                              'Variable_name' => 'local_infile'
                            },
          'innodb_read_io_threads' => {
                                        'Value' => '4',
                                        'Variable_name' => 'innodb_read_io_threads'
                                      },
          'innodb_ft_user_stopword_table' => {
                                               'Value' => '',
                                               'Variable_name' => 'innodb_ft_user_stopword_table'
                                             },
          'query_cache_min_res_unit' => {
                                          'Value' => '4096',
                                          'Variable_name' => 'query_cache_min_res_unit'
                                        },
          'key_cache_age_threshold' => {
                                         'Value' => '300',
                                         'Variable_name' => 'key_cache_age_threshold'
                                       },
          'innodb_online_alter_log_max_size' => {
                                                  'Value' => '134217728',
                                                  'Variable_name' => 'innodb_online_alter_log_max_size'
                                                },
          'innodb_old_blocks_time' => {
                                        'Value' => '1000',
                                        'Variable_name' => 'innodb_old_blocks_time'
                                      },
          'log_syslog_tag' => {
                                'Value' => '',
                                'Variable_name' => 'log_syslog_tag'
                              },
          'innodb_data_file_path' => {
                                       'Value' => 'ibdata1:12M:autoextend',
                                       'Variable_name' => 'innodb_data_file_path'
                                     },
          'innodb_force_recovery' => {
                                       'Value' => '0',
                                       'Variable_name' => 'innodb_force_recovery'
                                     },
          'expire_logs_days' => {
                                  'Value' => '0',
                                  'Variable_name' => 'expire_logs_days'
                                },
          'innodb_stats_method' => {
                                     'Value' => 'nulls_equal',
                                     'Variable_name' => 'innodb_stats_method'
                                   },
          'performance_schema_max_mutex_classes' => {
                                                      'Value' => '210',
                                                      'Variable_name' => 'performance_schema_max_mutex_classes'
                                                    },
          'optimizer_prune_level' => {
                                       'Value' => '1',
                                       'Variable_name' => 'optimizer_prune_level'
                                     },
          'innodb_buffer_pool_load_abort' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'innodb_buffer_pool_load_abort'
                                             },
          'relay_log_recovery' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'relay_log_recovery'
                                  },
          'innodb_version' => {
                                'Value' => '5.7.19',
                                'Variable_name' => 'innodb_version'
                              },
          'innodb_max_purge_lag' => {
                                      'Value' => '0',
                                      'Variable_name' => 'innodb_max_purge_lag'
                                    },
          'wait_timeout' => {
                              'Value' => '28800',
                              'Variable_name' => 'wait_timeout'
                            },
          'skip_name_resolve' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'skip_name_resolve'
                                 },
          'slave_compressed_protocol' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'slave_compressed_protocol'
                                         },
          'ssl_crl' => {
                         'Value' => '',
                         'Variable_name' => 'ssl_crl'
                       },
          'performance_schema_max_table_lock_stat' => {
                                                        'Value' => '-1',
                                                        'Variable_name' => 'performance_schema_max_table_lock_stat'
                                                      },
          'innodb_log_files_in_group' => {
                                           'Value' => '2',
                                           'Variable_name' => 'innodb_log_files_in_group'
                                         },
          'lower_case_file_system' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'lower_case_file_system'
                                      },
          'transaction_alloc_block_size' => {
                                              'Value' => '8192',
                                              'Variable_name' => 'transaction_alloc_block_size'
                                            },
          'performance_schema_max_metadata_locks' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_max_metadata_locks'
                                                     },
          'ft_boolean_syntax' => {
                                   'Value' => '+ -><()~*:""&|',
                                   'Variable_name' => 'ft_boolean_syntax'
                                 },
          'keep_files_on_create' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'keep_files_on_create'
                                    },
          'performance_schema_max_cond_instances' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_max_cond_instances'
                                                     },
          'avoid_temporal_upgrade' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'avoid_temporal_upgrade'
                                      },
          'host_cache_size' => {
                                 'Value' => '279',
                                 'Variable_name' => 'host_cache_size'
                               },
          'collation_database' => {
                                    'Value' => 'utf8mb4_general_ci',
                                    'Variable_name' => 'collation_database'
                                  },
          'innodb_buffer_pool_dump_now' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_buffer_pool_dump_now'
                                           },
          'performance_schema_events_statements_history_size' => {
                                                                   'Value' => '10',
                                                                   'Variable_name' => 'performance_schema_events_statements_history_size'
                                                                 },
          'innodb_io_capacity_max' => {
                                        'Value' => '2000',
                                        'Variable_name' => 'innodb_io_capacity_max'
                                      },
          'innodb_lock_wait_timeout' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_lock_wait_timeout'
                                        },
          'query_cache_limit' => {
                                   'Value' => '1048576',
                                   'Variable_name' => 'query_cache_limit'
                                 },
          'collation_connection' => {
                                      'Value' => 'utf8mb4_general_ci',
                                      'Variable_name' => 'collation_connection'
                                    },
          'time_format' => {
                             'Value' => '%H:%i:%s',
                             'Variable_name' => 'time_format'
                           },
          'performance_schema_max_thread_instances' => {
                                                         'Value' => '-1',
                                                         'Variable_name' => 'performance_schema_max_thread_instances'
                                                       },
          'log_warnings' => {
                              'Value' => '2',
                              'Variable_name' => 'log_warnings'
                            },
          'read_only' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'read_only'
                         },
          'innodb_replication_delay' => {
                                          'Value' => '0',
                                          'Variable_name' => 'innodb_replication_delay'
                                        },
          'server_id_bits' => {
                                'Value' => '32',
                                'Variable_name' => 'server_id_bits'
                              },
          'new' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'new'
                   },
          'innodb_adaptive_hash_index' => {
                                            'Value' => 'ON',
                                            'Variable_name' => 'innodb_adaptive_hash_index'
                                          },
          'performance_schema_max_rwlock_instances' => {
                                                         'Value' => '-1',
                                                         'Variable_name' => 'performance_schema_max_rwlock_instances'
                                                       },
          'performance_schema_max_index_stat' => {
                                                   'Value' => '-1',
                                                   'Variable_name' => 'performance_schema_max_index_stat'
                                                 },
          'character_set_results' => {
                                       'Value' => 'utf8mb4',
                                       'Variable_name' => 'character_set_results'
                                     },
          'table_open_cache_instances' => {
                                            'Value' => '16',
                                            'Variable_name' => 'table_open_cache_instances'
                                          },
          'slave_skip_errors' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'slave_skip_errors'
                                 },
          'max_join_size' => {
                               'Value' => '18446744073709551615',
                               'Variable_name' => 'max_join_size'
                             },
          'innodb_large_prefix' => {
                                     'Value' => 'ON',
                                     'Variable_name' => 'innodb_large_prefix'
                                   },
          'innodb_file_format_check' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_file_format_check'
                                        },
          'bind_address' => {
                              'Value' => '*',
                              'Variable_name' => 'bind_address'
                            },
          'slow_launch_time' => {
                                  'Value' => '2',
                                  'Variable_name' => 'slow_launch_time'
                                },
          'performance_schema_session_connect_attrs_size' => {
                                                               'Value' => '512',
                                                               'Variable_name' => 'performance_schema_session_connect_attrs_size'
                                                             },
          'binlog_group_commit_sync_no_delay_count' => {
                                                         'Value' => '0',
                                                         'Variable_name' => 'binlog_group_commit_sync_no_delay_count'
                                                       },
          'foreign_key_checks' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'foreign_key_checks'
                                  },
          'ignore_builtin_innodb' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'ignore_builtin_innodb'
                                     },
          'innodb_support_xa' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'innodb_support_xa'
                                 },
          'max_points_in_geometry' => {
                                        'Value' => '65536',
                                        'Variable_name' => 'max_points_in_geometry'
                                      },
          'innodb_spin_wait_delay' => {
                                        'Value' => '6',
                                        'Variable_name' => 'innodb_spin_wait_delay'
                                      },
          'version_comment' => {
                                 'Value' => 'Source distribution',
                                 'Variable_name' => 'version_comment'
                               },
          'max_prepared_stmt_count' => {
                                         'Value' => '16382',
                                         'Variable_name' => 'max_prepared_stmt_count'
                                       },
          'max_delayed_threads' => {
                                     'Value' => '20',
                                     'Variable_name' => 'max_delayed_threads'
                                   },
          'sql_warnings' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'sql_warnings'
                            },
          'max_tmp_tables' => {
                                'Value' => '32',
                                'Variable_name' => 'max_tmp_tables'
                              },
          'innodb_buffer_pool_load_at_startup' => {
                                                    'Value' => 'ON',
                                                    'Variable_name' => 'innodb_buffer_pool_load_at_startup'
                                                  },
          'init_slave' => {
                            'Value' => '',
                            'Variable_name' => 'init_slave'
                          },
          'log_output' => {
                            'Value' => 'FILE',
                            'Variable_name' => 'log_output'
                          },
          'innodb_buffer_pool_instances' => {
                                              'Value' => '8',
                                              'Variable_name' => 'innodb_buffer_pool_instances'
                                            },
          'innodb_fast_shutdown' => {
                                      'Value' => '1',
                                      'Variable_name' => 'innodb_fast_shutdown'
                                    },
          'innodb_log_file_size' => {
                                      'Value' => '33554432',
                                      'Variable_name' => 'innodb_log_file_size'
                                    },
          'ft_stopword_file' => {
                                  'Value' => '(built-in)',
                                  'Variable_name' => 'ft_stopword_file'
                                },
          'max_binlog_size' => {
                                 'Value' => '1073741824',
                                 'Variable_name' => 'max_binlog_size'
                               },
          'time_zone' => {
                           'Value' => 'SYSTEM',
                           'Variable_name' => 'time_zone'
                         },
          'delayed_queue_size' => {
                                    'Value' => '1000',
                                    'Variable_name' => 'delayed_queue_size'
                                  },
          'innodb_api_enable_binlog' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_api_enable_binlog'
                                        },
          'myisam_mmap_size' => {
                                  'Value' => '18446744073709551615',
                                  'Variable_name' => 'myisam_mmap_size'
                                },
          'log_error' => {
                           'Value' => './error.log',
                           'Variable_name' => 'log_error'
                         },
          'slave_rows_search_algorithms' => {
                                              'Value' => 'TABLE_SCAN,INDEX_SCAN',
                                              'Variable_name' => 'slave_rows_search_algorithms'
                                            },
          'range_alloc_block_size' => {
                                        'Value' => '4096',
                                        'Variable_name' => 'range_alloc_block_size'
                                      },
          'log_slow_admin_statements' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'log_slow_admin_statements'
                                         },
          'completion_type' => {
                                 'Value' => 'NO_CHAIN',
                                 'Variable_name' => 'completion_type'
                               },
          'character_set_server' => {
                                      'Value' => 'utf8mb4',
                                      'Variable_name' => 'character_set_server'
                                    },
          'innodb_monitor_enable' => {
                                       'Value' => '',
                                       'Variable_name' => 'innodb_monitor_enable'
                                     },
          'transaction_prealloc_size' => {
                                           'Value' => '4096',
                                           'Variable_name' => 'transaction_prealloc_size'
                                         },
          'character_set_filesystem' => {
                                          'Value' => 'binary',
                                          'Variable_name' => 'character_set_filesystem'
                                        },
          'large_page_size' => {
                                 'Value' => '0',
                                 'Variable_name' => 'large_page_size'
                               },
          'master_info_repository' => {
                                        'Value' => 'FILE',
                                        'Variable_name' => 'master_info_repository'
                                      },
          'innodb_status_output' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'innodb_status_output'
                                    },
          'gtid_purged' => {
                             'Value' => '',
                             'Variable_name' => 'gtid_purged'
                           },
          'internal_tmp_disk_storage_engine' => {
                                                  'Value' => 'InnoDB',
                                                  'Variable_name' => 'internal_tmp_disk_storage_engine'
                                                },
          'performance_schema' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'performance_schema'
                                  },
          'innodb_default_row_format' => {
                                           'Value' => 'dynamic',
                                           'Variable_name' => 'innodb_default_row_format'
                                         },
          'sync_relay_log' => {
                                'Value' => '10000',
                                'Variable_name' => 'sync_relay_log'
                              },
          'sync_master_info' => {
                                  'Value' => '10000',
                                  'Variable_name' => 'sync_master_info'
                                },
          'innodb_log_buffer_size' => {
                                        'Value' => '16777216',
                                        'Variable_name' => 'innodb_log_buffer_size'
                                      },
          'innodb_old_blocks_pct' => {
                                       'Value' => '37',
                                       'Variable_name' => 'innodb_old_blocks_pct'
                                     },
          'master_verify_checksum' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'master_verify_checksum'
                                      },
          'character_set_database' => {
                                        'Value' => 'utf8mb4',
                                        'Variable_name' => 'character_set_database'
                                      },
          'innodb_ft_enable_stopword' => {
                                           'Value' => 'ON',
                                           'Variable_name' => 'innodb_ft_enable_stopword'
                                         },
          'sql_safe_updates' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'sql_safe_updates'
                                },
          'innodb_ft_total_cache_size' => {
                                            'Value' => '640000000',
                                            'Variable_name' => 'innodb_ft_total_cache_size'
                                          },
          'sql_mode' => {
                          'Value' => 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION',
                          'Variable_name' => 'sql_mode'
                        },
          'innodb_api_bk_commit_interval' => {
                                               'Value' => '5',
                                               'Variable_name' => 'innodb_api_bk_commit_interval'
                                             },
          'innodb_cmp_per_index_enabled' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'innodb_cmp_per_index_enabled'
                                            },
          'key_cache_division_limit' => {
                                          'Value' => '100',
                                          'Variable_name' => 'key_cache_division_limit'
                                        },
          'sync_relay_log_info' => {
                                     'Value' => '10000',
                                     'Variable_name' => 'sync_relay_log_info'
                                   },
          'core_file' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'core_file'
                         },
          'innodb_adaptive_max_sleep_delay' => {
                                                 'Value' => '150000',
                                                 'Variable_name' => 'innodb_adaptive_max_sleep_delay'
                                               },
          'have_compress' => {
                               'Value' => 'YES',
                               'Variable_name' => 'have_compress'
                             },
          'log_throttle_queries_not_using_indexes' => {
                                                        'Value' => '1',
                                                        'Variable_name' => 'log_throttle_queries_not_using_indexes'
                                                      },
          'example_double_var' => {
                                    'Value' => '8.500000',
                                    'Variable_name' => 'example_double_var'
                                  },
          'sync_binlog' => {
                             'Value' => '1',
                             'Variable_name' => 'sync_binlog'
                           },
          'innodb_file_format_max' => {
                                        'Value' => 'Barracuda',
                                        'Variable_name' => 'innodb_file_format_max'
                                      },
          'innodb_stats_persistent_sample_pages' => {
                                                      'Value' => '20',
                                                      'Variable_name' => 'innodb_stats_persistent_sample_pages'
                                                    },
          'require_secure_transport' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'require_secure_transport'
                                        },
          'myisam_stats_method' => {
                                     'Value' => 'nulls_unequal',
                                     'Variable_name' => 'myisam_stats_method'
                                   },
          'plugin_dir' => {
                            'Value' => '/usr/mysql/5.7.19/lib/plugin/',
                            'Variable_name' => 'plugin_dir'
                          },
          'performance_schema_max_thread_classes' => {
                                                       'Value' => '50',
                                                       'Variable_name' => 'performance_schema_max_thread_classes'
                                                     },
          'innodb_rollback_on_timeout' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_rollback_on_timeout'
                                          },
          'query_cache_wlock_invalidate' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'query_cache_wlock_invalidate'
                                            },
          'gtid_mode' => {
                           'Value' => 'ON',
                           'Variable_name' => 'gtid_mode'
                         },
          'tmpdir' => {
                        'Value' => '/tmp',
                        'Variable_name' => 'tmpdir'
                      },
          'innodb_status_output_locks' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_status_output_locks'
                                          },
          'performance_schema_max_rwlock_classes' => {
                                                       'Value' => '40',
                                                       'Variable_name' => 'performance_schema_max_rwlock_classes'
                                                     },
          'innodb_ft_min_token_size' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_ft_min_token_size'
                                        },
          'myisam_recover_options' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'myisam_recover_options'
                                      },
          'rpl_stop_slave_timeout' => {
                                        'Value' => '31536000',
                                        'Variable_name' => 'rpl_stop_slave_timeout'
                                      },
          'have_query_cache' => {
                                  'Value' => 'YES',
                                  'Variable_name' => 'have_query_cache'
                                },
          'performance_schema_accounts_size' => {
                                                  'Value' => '-1',
                                                  'Variable_name' => 'performance_schema_accounts_size'
                                                },
          'innodb_numa_interleave' => {
                                        'Value' => 'ON',
                                        'Variable_name' => 'innodb_numa_interleave'
                                      },
          'innodb_read_ahead_threshold' => {
                                             'Value' => '56',
                                             'Variable_name' => 'innodb_read_ahead_threshold'
                                           },
          'max_relay_log_size' => {
                                    'Value' => '0',
                                    'Variable_name' => 'max_relay_log_size'
                                  },
          'slave_allow_batching' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'slave_allow_batching'
                                    },
          'report_host' => {
                             'Value' => '',
                             'Variable_name' => 'report_host'
                           },
          'log_statements_unsafe_for_binlog' => {
                                                  'Value' => 'ON',
                                                  'Variable_name' => 'log_statements_unsafe_for_binlog'
                                                },
          'character_set_system' => {
                                      'Value' => 'utf8',
                                      'Variable_name' => 'character_set_system'
                                    },
          'performance_schema_digests_size' => {
                                                 'Value' => '5000',
                                                 'Variable_name' => 'performance_schema_digests_size'
                                               },
          'innodb_locks_unsafe_for_binlog' => {
                                                'Value' => 'OFF',
                                                'Variable_name' => 'innodb_locks_unsafe_for_binlog'
                                              },
          'performance_schema_max_prepared_statements_instances' => {
                                                                      'Value' => '-1',
                                                                      'Variable_name' => 'performance_schema_max_prepared_statements_instances'
                                                                    },
          'gtid_executed_compression_period' => {
                                                  'Value' => '1000',
                                                  'Variable_name' => 'gtid_executed_compression_period'
                                                },
          'performance_schema_max_statement_stack' => {
                                                        'Value' => '10',
                                                        'Variable_name' => 'performance_schema_max_statement_stack'
                                                      },
          'optimizer_trace_features' => {
                                          'Value' => 'greedy_search=on,range_optimizer=on,dynamic_range=on,repeated_subselect=on',
                                          'Variable_name' => 'optimizer_trace_features'
                                        },
          'log_error_verbosity' => {
                                     'Value' => '3',
                                     'Variable_name' => 'log_error_verbosity'
                                   },
          'binlog_stmt_cache_size' => {
                                        'Value' => '32768',
                                        'Variable_name' => 'binlog_stmt_cache_size'
                                      },
          'delayed_insert_timeout' => {
                                        'Value' => '300',
                                        'Variable_name' => 'delayed_insert_timeout'
                                      },
          'basedir' => {
                         'Value' => '/usr/mysql/5.7.19/',
                         'Variable_name' => 'basedir'
                       },
          'default_storage_engine' => {
                                        'Value' => 'InnoDB',
                                        'Variable_name' => 'default_storage_engine'
                                      },
          'innodb_stats_on_metadata' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_stats_on_metadata'
                                        },
          'log_builtin_as_identified_by_password' => {
                                                       'Value' => 'OFF',
                                                       'Variable_name' => 'log_builtin_as_identified_by_password'
                                                     },
          'range_optimizer_max_mem_size' => {
                                              'Value' => '8388608',
                                              'Variable_name' => 'range_optimizer_max_mem_size'
                                            },
          'myisam_data_pointer_size' => {
                                          'Value' => '6',
                                          'Variable_name' => 'myisam_data_pointer_size'
                                        },
          'myisam_repair_threads' => {
                                       'Value' => '1',
                                       'Variable_name' => 'myisam_repair_threads'
                                     },
          'innodb_compression_pad_pct_max' => {
                                                'Value' => '50',
                                                'Variable_name' => 'innodb_compression_pad_pct_max'
                                              },
          'old_alter_table' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'old_alter_table'
                               },
          'long_query_time' => {
                                 'Value' => '1.000000',
                                 'Variable_name' => 'long_query_time'
                               },
          'innodb_max_purge_lag_delay' => {
                                            'Value' => '0',
                                            'Variable_name' => 'innodb_max_purge_lag_delay'
                                          },
          'ignore_db_dirs' => {
                                'Value' => '',
                                'Variable_name' => 'ignore_db_dirs'
                              },
          'query_prealloc_size' => {
                                     'Value' => '8192',
                                     'Variable_name' => 'query_prealloc_size'
                                   },
          'ssl_capath' => {
                            'Value' => '',
                            'Variable_name' => 'ssl_capath'
                          },
          'performance_schema_max_socket_classes' => {
                                                       'Value' => '10',
                                                       'Variable_name' => 'performance_schema_max_socket_classes'
                                                     },
          'stored_program_cache' => {
                                      'Value' => '256',
                                      'Variable_name' => 'stored_program_cache'
                                    },
          'event_scheduler' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'event_scheduler'
                               },
          'ft_max_word_len' => {
                                 'Value' => '84',
                                 'Variable_name' => 'ft_max_word_len'
                               },
          'innodb_flush_neighbors' => {
                                        'Value' => '1',
                                        'Variable_name' => 'innodb_flush_neighbors'
                                      },
          'server_uuid' => {
                             'Value' => '1d87f577-6b80-11e7-8865-0201a32caf75',
                             'Variable_name' => 'server_uuid'
                           },
          'big_tables' => {
                            'Value' => 'OFF',
                            'Variable_name' => 'big_tables'
                          },
          'slave_transaction_retries' => {
                                           'Value' => '10',
                                           'Variable_name' => 'slave_transaction_retries'
                                         },
          'protocol_version' => {
                                  'Value' => '10',
                                  'Variable_name' => 'protocol_version'
                                },
          'binlog_format' => {
                               'Value' => 'ROW',
                               'Variable_name' => 'binlog_format'
                             },
          'skip_external_locking' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'skip_external_locking'
                                     },
          'session_track_gtids' => {
                                     'Value' => 'OFF',
                                     'Variable_name' => 'session_track_gtids'
                                   },
          'innodb_io_capacity' => {
                                    'Value' => '200',
                                    'Variable_name' => 'innodb_io_capacity'
                                  },
          'binlog_direct_non_transactional_updates' => {
                                                         'Value' => 'OFF',
                                                         'Variable_name' => 'binlog_direct_non_transactional_updates'
                                                       },
          'version_compile_os' => {
                                    'Value' => 'Linux',
                                    'Variable_name' => 'version_compile_os'
                                  },
          'lc_messages' => {
                             'Value' => 'en_US',
                             'Variable_name' => 'lc_messages'
                           },
          'delayed_insert_limit' => {
                                      'Value' => '100',
                                      'Variable_name' => 'delayed_insert_limit'
                                    },
          'innodb_ft_max_token_size' => {
                                          'Value' => '84',
                                          'Variable_name' => 'innodb_ft_max_token_size'
                                        },
          'max_seeks_for_key' => {
                                   'Value' => '18446744073709551615',
                                   'Variable_name' => 'max_seeks_for_key'
                                 },
          'innodb_purge_threads' => {
                                      'Value' => '4',
                                      'Variable_name' => 'innodb_purge_threads'
                                    },
          'performance_schema_events_statements_history_long_size' => {
                                                                        'Value' => '1000',
                                                                        'Variable_name' => 'performance_schema_events_statements_history_long_size'
                                                                      },
          'slave_max_allowed_packet' => {
                                          'Value' => '1073741824',
                                          'Variable_name' => 'slave_max_allowed_packet'
                                        },
          'session_track_system_variables' => {
                                                'Value' => 'time_zone,autocommit,character_set_client,character_set_results,character_set_connection',
                                                'Variable_name' => 'session_track_system_variables'
                                              },
          'log_syslog' => {
                            'Value' => 'ON',
                            'Variable_name' => 'log_syslog'
                          },
          'log_queries_not_using_indexes' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'log_queries_not_using_indexes'
                                             },
          'innodb_thread_sleep_delay' => {
                                           'Value' => '10000',
                                           'Variable_name' => 'innodb_thread_sleep_delay'
                                         },
          'lc_time_names' => {
                               'Value' => 'en_US',
                               'Variable_name' => 'lc_time_names'
                             },
          'report_user' => {
                             'Value' => '',
                             'Variable_name' => 'report_user'
                           },
          'innodb_tmpdir' => {
                               'Value' => '',
                               'Variable_name' => 'innodb_tmpdir'
                             },
          'binlog_rows_query_log_events' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'binlog_rows_query_log_events'
                                            },
          'slow_query_log' => {
                                'Value' => 'ON',
                                'Variable_name' => 'slow_query_log'
                              },
          'innodb_autoinc_lock_mode' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_autoinc_lock_mode'
                                        },
          'innodb_open_files' => {
                                   'Value' => '431',
                                   'Variable_name' => 'innodb_open_files'
                                 },
          'slave_exec_mode' => {
                                 'Value' => 'STRICT',
                                 'Variable_name' => 'slave_exec_mode'
                               },
          'max_binlog_cache_size' => {
                                       'Value' => '18446744073709547520',
                                       'Variable_name' => 'max_binlog_cache_size'
                                     },
          'slave_pending_jobs_size_max' => {
                                             'Value' => '16777216',
                                             'Variable_name' => 'slave_pending_jobs_size_max'
                                           },
          'innodb_monitor_reset' => {
                                      'Value' => '',
                                      'Variable_name' => 'innodb_monitor_reset'
                                    },
          'join_buffer_size' => {
                                  'Value' => '262144',
                                  'Variable_name' => 'join_buffer_size'
                                },
          'table_open_cache' => {
                                  'Value' => '431',
                                  'Variable_name' => 'table_open_cache'
                                },
          'performance_schema_setup_actors_size' => {
                                                      'Value' => '-1',
                                                      'Variable_name' => 'performance_schema_setup_actors_size'
                                                    },
          'large_pages' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'large_pages'
                           },
          'default_tmp_storage_engine' => {
                                            'Value' => 'InnoDB',
                                            'Variable_name' => 'default_tmp_storage_engine'
                                          },
          'explicit_defaults_for_timestamp' => {
                                                 'Value' => 'OFF',
                                                 'Variable_name' => 'explicit_defaults_for_timestamp'
                                               },
          'innodb_ft_num_word_optimize' => {
                                             'Value' => '2000',
                                             'Variable_name' => 'innodb_ft_num_word_optimize'
                                           },
          'innodb_ft_sort_pll_degree' => {
                                           'Value' => '2',
                                           'Variable_name' => 'innodb_ft_sort_pll_degree'
                                         },
          'innodb_undo_directory' => {
                                       'Value' => './',
                                       'Variable_name' => 'innodb_undo_directory'
                                     },
          'key_buffer_size' => {
                                 'Value' => '8388608',
                                 'Variable_name' => 'key_buffer_size'
                               },
          'skip_networking' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'skip_networking'
                               },
          'innodb_force_load_corrupted' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_force_load_corrupted'
                                           },
          'max_digest_length' => {
                                   'Value' => '1024',
                                   'Variable_name' => 'max_digest_length'
                                 },
          'innodb_log_compressed_pages' => {
                                             'Value' => 'ON',
                                             'Variable_name' => 'innodb_log_compressed_pages'
                                           },
          'license' => {
                         'Value' => 'GPL',
                         'Variable_name' => 'license'
                       },
          'innodb_concurrency_tickets' => {
                                            'Value' => '5000',
                                            'Variable_name' => 'innodb_concurrency_tickets'
                                          },
          'skip_show_database' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'skip_show_database'
                                  },
          'rbr_exec_mode' => {
                               'Value' => 'STRICT',
                               'Variable_name' => 'rbr_exec_mode'
                             },
          'performance_schema_users_size' => {
                                               'Value' => '-1',
                                               'Variable_name' => 'performance_schema_users_size'
                                             },
          'flush_time' => {
                            'Value' => '0',
                            'Variable_name' => 'flush_time'
                          },
          'net_write_timeout' => {
                                   'Value' => '60',
                                   'Variable_name' => 'net_write_timeout'
                                 },
          'innodb_monitor_disable' => {
                                        'Value' => '',
                                        'Variable_name' => 'innodb_monitor_disable'
                                      },
          'max_heap_table_size' => {
                                     'Value' => '16777216',
                                     'Variable_name' => 'max_heap_table_size'
                                   },
          'sql_select_limit' => {
                                  'Value' => '18446744073709551615',
                                  'Variable_name' => 'sql_select_limit'
                                },
          'ft_query_expansion_limit' => {
                                          'Value' => '20',
                                          'Variable_name' => 'ft_query_expansion_limit'
                                        },
          'max_connect_errors' => {
                                    'Value' => '100',
                                    'Variable_name' => 'max_connect_errors'
                                  },
          'performance_schema_max_file_classes' => {
                                                     'Value' => '80',
                                                     'Variable_name' => 'performance_schema_max_file_classes'
                                                   },
          'performance_schema_max_file_instances' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_max_file_instances'
                                                     },
          'myisam_use_mmap' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'myisam_use_mmap'
                               },
          'max_write_lock_count' => {
                                      'Value' => '18446744073709551615',
                                      'Variable_name' => 'max_write_lock_count'
                                    },
          'have_profiling' => {
                                'Value' => 'YES',
                                'Variable_name' => 'have_profiling'
                              },
          'interactive_timeout' => {
                                     'Value' => '28800',
                                     'Variable_name' => 'interactive_timeout'
                                   },
          'report_port' => {
                             'Value' => '64057',
                             'Variable_name' => 'report_port'
                           },
          'innodb_adaptive_flushing_lwm' => {
                                              'Value' => '10',
                                              'Variable_name' => 'innodb_adaptive_flushing_lwm'
                                            },
          'performance_schema_max_sql_text_length' => {
                                                        'Value' => '1024',
                                                        'Variable_name' => 'performance_schema_max_sql_text_length'
                                                      },
          'innodb_api_disable_rowlock' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_api_disable_rowlock'
                                          },
          'check_proxy_users' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'check_proxy_users'
                                 },
          'default_password_lifetime' => {
                                           'Value' => '0',
                                           'Variable_name' => 'default_password_lifetime'
                                         },
          'have_geometry' => {
                               'Value' => 'YES',
                               'Variable_name' => 'have_geometry'
                             },
          'relay_log' => {
                           'Value' => 'relay',
                           'Variable_name' => 'relay_log'
                         },
          'performance_schema_events_waits_history_size' => {
                                                              'Value' => '10',
                                                              'Variable_name' => 'performance_schema_events_waits_history_size'
                                                            },
          'innodb_optimize_fulltext_only' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'innodb_optimize_fulltext_only'
                                             },
          'ssl_ca' => {
                        'Value' => '',
                        'Variable_name' => 'ssl_ca'
                      },
          'relay_log_index' => {
                                 'Value' => '/usr/mysql/5.7.19/data/relay.index',
                                 'Variable_name' => 'relay_log_index'
                               },
          'binlog_group_commit_sync_delay' => {
                                                'Value' => '0',
                                                'Variable_name' => 'binlog_group_commit_sync_delay'
                                              },
          'innodb_undo_log_truncate' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_undo_log_truncate'
                                        },
          'flush' => {
                       'Value' => 'OFF',
                       'Variable_name' => 'flush'
                     },
          'character_set_client' => {
                                      'Value' => 'utf8mb4',
                                      'Variable_name' => 'character_set_client'
                                    },
          'binlog_checksum' => {
                                 'Value' => 'NONE',
                                 'Variable_name' => 'binlog_checksum'
                               },
          'locked_in_memory' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'locked_in_memory'
                                },
          'binlog_cache_size' => {
                                   'Value' => '32768',
                                   'Variable_name' => 'binlog_cache_size'
                                 },
          'innodb_use_native_aio' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_use_native_aio'
                                     },
          'performance_schema_max_program_instances' => {
                                                          'Value' => '-1',
                                                          'Variable_name' => 'performance_schema_max_program_instances'
                                                        },
          'innodb_ft_aux_table' => {
                                     'Value' => '',
                                     'Variable_name' => 'innodb_ft_aux_table'
                                   },
          'performance_schema_events_transactions_history_long_size' => {
                                                                          'Value' => '1000',
                                                                          'Variable_name' => 'performance_schema_events_transactions_history_long_size'
                                                                        },
          'innodb_sync_spin_loops' => {
                                        'Value' => '30',
                                        'Variable_name' => 'innodb_sync_spin_loops'
                                      },
          'innodb_flush_sync' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'innodb_flush_sync'
                                 },
          'system_time_zone' => {
                                  'Value' => 'JST',
                                  'Variable_name' => 'system_time_zone'
                                },
          'super_read_only' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'super_read_only'
                               },
          'innodb_checksums' => {
                                  'Value' => 'ON',
                                  'Variable_name' => 'innodb_checksums'
                                },
          'performance_schema_max_statement_classes' => {
                                                          'Value' => '193',
                                                          'Variable_name' => 'performance_schema_max_statement_classes'
                                                        },
          'datetime_format' => {
                                 'Value' => '%Y-%m-%d %H:%i:%s',
                                 'Variable_name' => 'datetime_format'
                               },
          'innodb_change_buffering' => {
                                         'Value' => 'all',
                                         'Variable_name' => 'innodb_change_buffering'
                                       },
          'innodb_stats_transient_sample_pages' => {
                                                     'Value' => '8',
                                                     'Variable_name' => 'innodb_stats_transient_sample_pages'
                                                   },
          'performance_schema_events_stages_history_long_size' => {
                                                                    'Value' => '1000',
                                                                    'Variable_name' => 'performance_schema_events_stages_history_long_size'
                                                                  },
          'innodb_max_undo_log_size' => {
                                          'Value' => '1073741824',
                                          'Variable_name' => 'innodb_max_undo_log_size'
                                        },
          'innodb_change_buffer_max_size' => {
                                               'Value' => '25',
                                               'Variable_name' => 'innodb_change_buffer_max_size'
                                             },
          'eq_range_index_dive_limit' => {
                                           'Value' => '200',
                                           'Variable_name' => 'eq_range_index_dive_limit'
                                         },
          'performance_schema_max_digest_length' => {
                                                      'Value' => '1024',
                                                      'Variable_name' => 'performance_schema_max_digest_length'
                                                    },
          'innodb_sync_array_size' => {
                                        'Value' => '1',
                                        'Variable_name' => 'innodb_sync_array_size'
                                      },
          'tx_isolation' => {
                              'Value' => 'REPEATABLE-READ',
                              'Variable_name' => 'tx_isolation'
                            },
          'relay_log_basename' => {
                                    'Value' => '/usr/mysql/5.7.19/data/relay',
                                    'Variable_name' => 'relay_log_basename'
                                  },
          'innodb_ft_result_cache_limit' => {
                                              'Value' => '2000000000',
                                              'Variable_name' => 'innodb_ft_result_cache_limit'
                                            },
          'log_bin_trust_function_creators' => {
                                                 'Value' => 'OFF',
                                                 'Variable_name' => 'log_bin_trust_function_creators'
                                               },
          'disabled_storage_engines' => {
                                          'Value' => '',
                                          'Variable_name' => 'disabled_storage_engines'
                                        },
          'disconnect_on_expired_password' => {
                                                'Value' => 'ON',
                                                'Variable_name' => 'disconnect_on_expired_password'
                                              },
          'max_execution_time' => {
                                    'Value' => '0',
                                    'Variable_name' => 'max_execution_time'
                                  },
          'performance_schema_max_mutex_instances' => {
                                                        'Value' => '-1',
                                                        'Variable_name' => 'performance_schema_max_mutex_instances'
                                                      },
          'session_track_schema' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'session_track_schema'
                                    },
          'innodb_buffer_pool_size' => {
                                         'Value' => '1073741824',
                                         'Variable_name' => 'innodb_buffer_pool_size'
                                       },
          'slave_checkpoint_group' => {
                                        'Value' => '512',
                                        'Variable_name' => 'slave_checkpoint_group'
                                      },
          'innodb_disable_sort_file_cache' => {
                                                'Value' => 'OFF',
                                                'Variable_name' => 'innodb_disable_sort_file_cache'
                                              },
          'slave_type_conversions' => {
                                        'Value' => '',
                                        'Variable_name' => 'slave_type_conversions'
                                      },
          'myisam_sort_buffer_size' => {
                                         'Value' => '8388608',
                                         'Variable_name' => 'myisam_sort_buffer_size'
                                       },
          'innodb_temp_data_file_path' => {
                                            'Value' => 'ibtmp1:12M:autoextend',
                                            'Variable_name' => 'innodb_temp_data_file_path'
                                          },
          'log_timestamps' => {
                                'Value' => 'SYSTEM',
                                'Variable_name' => 'log_timestamps'
                              },
          'init_file' => {
                           'Value' => '',
                           'Variable_name' => 'init_file'
                         },
          'innodb_read_only' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'innodb_read_only'
                                },
          'default_week_format' => {
                                     'Value' => '0',
                                     'Variable_name' => 'default_week_format'
                                   },
          'innodb_rollback_segments' => {
                                          'Value' => '128',
                                          'Variable_name' => 'innodb_rollback_segments'
                                        },
          'optimizer_switch' => {
                                  'Value' => 'index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on',
                                  'Variable_name' => 'optimizer_switch'
                                },
          'innodb_commit_concurrency' => {
                                           'Value' => '0',
                                           'Variable_name' => 'innodb_commit_concurrency'
                                         },
          'innodb_purge_batch_size' => {
                                         'Value' => '300',
                                         'Variable_name' => 'innodb_purge_batch_size'
                                       },
          'unique_checks' => {
                               'Value' => 'ON',
                               'Variable_name' => 'unique_checks'
                             },
          'preload_buffer_size' => {
                                     'Value' => '32768',
                                     'Variable_name' => 'preload_buffer_size'
                                   },
          'read_buffer_size' => {
                                  'Value' => '131072',
                                  'Variable_name' => 'read_buffer_size'
                                },
          'slave_preserve_commit_order' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'slave_preserve_commit_order'
                                           },
          'innodb_data_home_dir' => {
                                      'Value' => '',
                                      'Variable_name' => 'innodb_data_home_dir'
                                    },
          'innodb_lru_scan_depth' => {
                                       'Value' => '1024',
                                       'Variable_name' => 'innodb_lru_scan_depth'
                                     },
          'tx_read_only' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'tx_read_only'
                            },
          'character_set_connection' => {
                                          'Value' => 'utf8mb4',
                                          'Variable_name' => 'character_set_connection'
                                        },
          'tls_version' => {
                             'Value' => 'TLSv1,TLSv1.1',
                             'Variable_name' => 'tls_version'
                           },
          'secure_file_priv' => {
                                  'Value' => '',
                                  'Variable_name' => 'secure_file_priv'
                                },
          'query_cache_type' => {
                                  'Value' => 'DEMAND',
                                  'Variable_name' => 'query_cache_type'
                                },
          'mysql_native_password_proxy_users' => {
                                                   'Value' => 'OFF',
                                                   'Variable_name' => 'mysql_native_password_proxy_users'
                                                 },
          'show_compatibility_56' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'show_compatibility_56'
                                     },
          'query_alloc_block_size' => {
                                        'Value' => '8192',
                                        'Variable_name' => 'query_alloc_block_size'
                                      },
          'port' => {
                      'Value' => '64057',
                      'Variable_name' => 'port'
                    },
          'log_slave_updates' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'log_slave_updates'
                                 },
          'socket' => {
                        'Value' => '/usr/mysql/5.7.19/data/mysql.sock',
                        'Variable_name' => 'socket'
                      },
          'tmp_table_size' => {
                                'Value' => '16777216',
                                'Variable_name' => 'tmp_table_size'
                              },
          'div_precision_increment' => {
                                         'Value' => '4',
                                         'Variable_name' => 'div_precision_increment'
                                       },
          'query_cache_size' => {
                                  'Value' => '33554432',
                                  'Variable_name' => 'query_cache_size'
                                },
          'innodb_log_write_ahead_size' => {
                                             'Value' => '8192',
                                             'Variable_name' => 'innodb_log_write_ahead_size'
                                           },
          'innodb_strict_mode' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_strict_mode'
                                  },
          'optimizer_trace_max_mem_size' => {
                                              'Value' => '16384',
                                              'Variable_name' => 'optimizer_trace_max_mem_size'
                                            },
          'old_passwords' => {
                               'Value' => '0',
                               'Variable_name' => 'old_passwords'
                             },
          'collation_server' => {
                                  'Value' => 'utf8mb4_general_ci',
                                  'Variable_name' => 'collation_server'
                                },
          'relay_log_space_limit' => {
                                       'Value' => '0',
                                       'Variable_name' => 'relay_log_space_limit'
                                     },
          'ft_min_word_len' => {
                                 'Value' => '4',
                                 'Variable_name' => 'ft_min_word_len'
                               },
          'ssl_cipher' => {
                            'Value' => '',
                            'Variable_name' => 'ssl_cipher'
                          },
          'innodb_adaptive_flushing' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_adaptive_flushing'
                                        },
          'date_format' => {
                             'Value' => '%Y-%m-%d',
                             'Variable_name' => 'date_format'
                           },
          'max_binlog_stmt_cache_size' => {
                                            'Value' => '18446744073709547520',
                                            'Variable_name' => 'max_binlog_stmt_cache_size'
                                          },
          'slave_parallel_workers' => {
                                        'Value' => '0',
                                        'Variable_name' => 'slave_parallel_workers'
                                      },
          'innodb_write_io_threads' => {
                                         'Value' => '4',
                                         'Variable_name' => 'innodb_write_io_threads'
                                       },
          'metadata_locks_cache_size' => {
                                           'Value' => '1024',
                                           'Variable_name' => 'metadata_locks_cache_size'
                                         },
          'thread_cache_size' => {
                                   'Value' => '9',
                                   'Variable_name' => 'thread_cache_size'
                                 },
          'profiling' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'profiling'
                         },
          'log_bin_basename' => {
                                  'Value' => '/usr/mysql/5.7.19/data/bin',
                                  'Variable_name' => 'log_bin_basename'
                                },
          'updatable_views_with_limit' => {
                                            'Value' => 'YES',
                                            'Variable_name' => 'updatable_views_with_limit'
                                          },
          'table_definition_cache' => {
                                        'Value' => '615',
                                        'Variable_name' => 'table_definition_cache'
                                      },
          'performance_schema_max_cond_classes' => {
                                                     'Value' => '80',
                                                     'Variable_name' => 'performance_schema_max_cond_classes'
                                                   },
          'log_syslog_facility' => {
                                     'Value' => 'daemon',
                                     'Variable_name' => 'log_syslog_facility'
                                   },
          'profiling_history_size' => {
                                        'Value' => '15',
                                        'Variable_name' => 'profiling_history_size'
                                      },
          'innodb_autoextend_increment' => {
                                             'Value' => '64',
                                             'Variable_name' => 'innodb_autoextend_increment'
                                           },
          'innodb_random_read_ahead' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_random_read_ahead'
                                        },
          'general_log_file' => {
                                  'Value' => 'general.log',
                                  'Variable_name' => 'general_log_file'
                                },
          'log_bin_index' => {
                               'Value' => '/usr/mysql/5.7.19/data/bin.index',
                               'Variable_name' => 'log_bin_index'
                             },
          'slave_sql_verify_checksum' => {
                                           'Value' => 'ON',
                                           'Variable_name' => 'slave_sql_verify_checksum'
                                         },
          'have_openssl' => {
                              'Value' => 'DISABLED',
                              'Variable_name' => 'have_openssl'
                            },
          'max_sort_length' => {
                                 'Value' => '1024',
                                 'Variable_name' => 'max_sort_length'
                               },
          'slave_parallel_type' => {
                                     'Value' => 'DATABASE',
                                     'Variable_name' => 'slave_parallel_type'
                                   },
          'optimizer_trace_limit' => {
                                       'Value' => '1',
                                       'Variable_name' => 'optimizer_trace_limit'
                                     },
          'max_length_for_sort_data' => {
                                          'Value' => '1024',
                                          'Variable_name' => 'max_length_for_sort_data'
                                        }
        };

$STATS_ON_METADATA_IS_ON= clone($mysql57_ps_on);
$STATS_ON_METADATA_IS_ON->{innodb_stats_on_metadata}->{Value} = "ON";

$OFFLINE_MODE= clone($mysql57_ps_on);
$OFFLINE_MODE->{offline_mode}->{Value}= "ON";

$show_session_variables_like_pseudo_thread_id = [
          {
            'Value' => '72',
            'Variable_name' => 'pseudo_thread_id'
          }
        ];
$stats_expiry_empty = [];

$stats_expiry_nonzero = [
          {
            'Value' => '86400',
            'Variable_name' => 'information_schema_stats_expiry'
          }
        ];

$stats_expiry_zero = [
          {
            'Value' => '0',
            'Variable_name' => 'information_schema_stats_expiry'
          }
        ];



$read_only= clone($mysql57_ps_on);
$read_only->{read_only}->{Value}= "ON";

$mysql57_ps_off= clone($mysql57_ps_on);
$mysql57_ps_off->{performance_schema}->{Value}= "OFF";

$VAR1= $mysql57_ps_on;

$mysql55_ps_on = {
          'max_allowed_packet' => {
                                    'Value' => '1048576',
                                    'Variable_name' => 'max_allowed_packet'
                                  },
          'thread_stack' => {
                              'Value' => '262144',
                              'Variable_name' => 'thread_stack'
                            },
          'sql_buffer_result' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'sql_buffer_result'
                                 },
          'character_sets_dir' => {
                                    'Value' => '/usr/mysql/5.5.60/share/charsets/',
                                    'Variable_name' => 'character_sets_dir'
                                  },
          'max_insert_delayed_threads' => {
                                            'Value' => '20',
                                            'Variable_name' => 'max_insert_delayed_threads'
                                          },
          'low_priority_updates' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'low_priority_updates'
                                    },
          'pid_file' => {
                          'Value' => '/usr/mysql/5.5.60/data/mysql.pid',
                          'Variable_name' => 'pid_file'
                        },
          'ssl_key' => {
                         'Value' => '',
                         'Variable_name' => 'ssl_key'
                       },
          'sql_big_selects' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'sql_big_selects'
                               },
          'performance_schema_events_waits_history_long_size' => {
                                                                   'Value' => '10000',
                                                                   'Variable_name' => 'performance_schema_events_waits_history_long_size'
                                                                 },
          'multi_range_count' => {
                                   'Value' => '256',
                                   'Variable_name' => 'multi_range_count'
                                 },
          'innodb_mirrored_log_groups' => {
                                            'Value' => '1',
                                            'Variable_name' => 'innodb_mirrored_log_groups'
                                          },
          'net_retry_count' => {
                                 'Value' => '10',
                                 'Variable_name' => 'net_retry_count'
                               },
          'old' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'old'
                   },
          'slave_load_tmpdir' => {
                                   'Value' => '/tmp',
                                   'Variable_name' => 'slave_load_tmpdir'
                                 },
          'have_partitioning' => {
                                   'Value' => 'YES',
                                   'Variable_name' => 'have_partitioning'
                                 },
          'auto_increment_increment' => {
                                          'Value' => '1',
                                          'Variable_name' => 'auto_increment_increment'
                                        },
          'innodb_max_dirty_pages_pct' => {
                                            'Value' => '75',
                                            'Variable_name' => 'innodb_max_dirty_pages_pct'
                                          },
          'have_ssl' => {
                          'Value' => 'DISABLED',
                          'Variable_name' => 'have_ssl'
                        },
          'version_compile_machine' => {
                                         'Value' => 'x86_64',
                                         'Variable_name' => 'version_compile_machine'
                                       },
          'auto_increment_offset' => {
                                       'Value' => '1',
                                       'Variable_name' => 'auto_increment_offset'
                                     },
          'performance_schema_max_table_instances' => {
                                                        'Value' => '50000',
                                                        'Variable_name' => 'performance_schema_max_table_instances'
                                                      },
          'large_files_support' => {
                                     'Value' => 'ON',
                                     'Variable_name' => 'large_files_support'
                                   },
          'lock_wait_timeout' => {
                                   'Value' => '31536000',
                                   'Variable_name' => 'lock_wait_timeout'
                                 },
          'lower_case_table_names' => {
                                        'Value' => '1',
                                        'Variable_name' => 'lower_case_table_names'
                                      },
          'secure_auth' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'secure_auth'
                           },
          'log_bin' => {
                         'Value' => 'ON',
                         'Variable_name' => 'log_bin'
                       },
          'sql_notes' => {
                           'Value' => 'ON',
                           'Variable_name' => 'sql_notes'
                         },
          'version' => {
                         'Value' => '5.5.60-log',
                         'Variable_name' => 'version'
                       },
          'innodb_file_per_table' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_file_per_table'
                                     },
          'innodb_additional_mem_pool_size' => {
                                                 'Value' => '8388608',
                                                 'Variable_name' => 'innodb_additional_mem_pool_size'
                                               },
          'init_connect' => {
                              'Value' => '',
                              'Variable_name' => 'init_connect'
                            },
          'slave_net_timeout' => {
                                   'Value' => '3600',
                                   'Variable_name' => 'slave_net_timeout'
                                 },
          'datadir' => {
                         'Value' => '/usr/mysql/5.5.60/data/',
                         'Variable_name' => 'datadir'
                       },
          'read_rnd_buffer_size' => {
                                      'Value' => '262144',
                                      'Variable_name' => 'read_rnd_buffer_size'
                                    },
          'sql_auto_is_null' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'sql_auto_is_null'
                                },
          'general_log' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'general_log'
                           },
          'sql_max_join_size' => {
                                   'Value' => '18446744073709551615',
                                   'Variable_name' => 'sql_max_join_size'
                                 },
          'report_password' => {
                                 'Value' => '',
                                 'Variable_name' => 'report_password'
                               },
          'min_examined_row_limit' => {
                                        'Value' => '0',
                                        'Variable_name' => 'min_examined_row_limit'
                                      },
          'max_user_connections' => {
                                      'Value' => '0',
                                      'Variable_name' => 'max_user_connections'
                                    },
          'max_sp_recursion_depth' => {
                                        'Value' => '0',
                                        'Variable_name' => 'max_sp_recursion_depth'
                                      },
          'innodb_log_group_home_dir' => {
                                           'Value' => './',
                                           'Variable_name' => 'innodb_log_group_home_dir'
                                         },
          'delay_key_write' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'delay_key_write'
                               },
          'myisam_max_sort_file_size' => {
                                           'Value' => '9223372036853727232',
                                           'Variable_name' => 'myisam_max_sort_file_size'
                                         },
          'innodb_flush_log_at_trx_commit' => {
                                                'Value' => '1',
                                                'Variable_name' => 'innodb_flush_log_at_trx_commit'
                                              },
          'innodb_doublewrite' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_doublewrite'
                                  },
          'innodb_thread_concurrency' => {
                                           'Value' => '0',
                                           'Variable_name' => 'innodb_thread_concurrency'
                                         },
          'innodb_stats_sample_pages' => {
                                           'Value' => '8',
                                           'Variable_name' => 'innodb_stats_sample_pages'
                                         },
          'relay_log_purge' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'relay_log_purge'
                               },
          'bulk_insert_buffer_size' => {
                                         'Value' => '8388608',
                                         'Variable_name' => 'bulk_insert_buffer_size'
                                       },
          'back_log' => {
                          'Value' => '50',
                          'Variable_name' => 'back_log'
                        },
          'sql_log_off' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'sql_log_off'
                           },
          'server_id' => {
                           'Value' => '1055',
                           'Variable_name' => 'server_id'
                         },
          'open_files_limit' => {
                                  'Value' => '1024',
                                  'Variable_name' => 'open_files_limit'
                                },
          'innodb_table_locks' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_table_locks'
                                  },
          'ssl_cert' => {
                          'Value' => '',
                          'Variable_name' => 'ssl_cert'
                        },
          'key_cache_block_size' => {
                                      'Value' => '1024',
                                      'Variable_name' => 'key_cache_block_size'
                                    },
          'performance_schema_max_table_handles' => {
                                                      'Value' => '100000',
                                                      'Variable_name' => 'performance_schema_max_table_handles'
                                                    },
          'sync_frm' => {
                          'Value' => 'ON',
                          'Variable_name' => 'sync_frm'
                        },
          'sort_buffer_size' => {
                                  'Value' => '2097152',
                                  'Variable_name' => 'sort_buffer_size'
                                },
          'have_crypt' => {
                            'Value' => 'YES',
                            'Variable_name' => 'have_crypt'
                          },
          'have_rtree_keys' => {
                                 'Value' => 'YES',
                                 'Variable_name' => 'have_rtree_keys'
                               },
          'optimizer_search_depth' => {
                                        'Value' => '62',
                                        'Variable_name' => 'optimizer_search_depth'
                                      },
          'concurrent_insert' => {
                                   'Value' => 'AUTO',
                                   'Variable_name' => 'concurrent_insert'
                                 },
          'sql_slave_skip_counter' => {
                                        'Value' => '0',
                                        'Variable_name' => 'sql_slave_skip_counter'
                                      },
          'thread_handling' => {
                                 'Value' => 'one-thread-per-connection',
                                 'Variable_name' => 'thread_handling'
                               },
          'net_read_timeout' => {
                                  'Value' => '30',
                                  'Variable_name' => 'net_read_timeout'
                                },
          'have_symlink' => {
                              'Value' => 'YES',
                              'Variable_name' => 'have_symlink'
                            },
          'sql_quote_show_create' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'sql_quote_show_create'
                                     },
          'slow_query_log_file' => {
                                     'Value' => 'slow.log',
                                     'Variable_name' => 'slow_query_log_file'
                                   },
          'performance_schema_max_file_handles' => {
                                                     'Value' => '32768',
                                                     'Variable_name' => 'performance_schema_max_file_handles'
                                                   },
          'max_error_count' => {
                                 'Value' => '64',
                                 'Variable_name' => 'max_error_count'
                               },
          'net_buffer_length' => {
                                   'Value' => '16384',
                                   'Variable_name' => 'net_buffer_length'
                                 },
          'have_dynamic_loading' => {
                                      'Value' => 'YES',
                                      'Variable_name' => 'have_dynamic_loading'
                                    },
          'automatic_sp_privileges' => {
                                         'Value' => 'ON',
                                         'Variable_name' => 'automatic_sp_privileges'
                                       },
          'innodb_print_all_deadlocks' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_print_all_deadlocks'
                                          },
          'hostname' => {
                          'Value' => '163-44-175-117',
                          'Variable_name' => 'hostname'
                        },
          'innodb_file_format' => {
                                    'Value' => 'Barracuda',
                                    'Variable_name' => 'innodb_file_format'
                                  },
          'autocommit' => {
                            'Value' => 'ON',
                            'Variable_name' => 'autocommit'
                          },
          'max_connections' => {
                                 'Value' => '151',
                                 'Variable_name' => 'max_connections'
                               },
          'lc_messages_dir' => {
                                 'Value' => '/usr/mysql/5.5.60/share/',
                                 'Variable_name' => 'lc_messages_dir'
                               },
          'innodb_flush_method' => {
                                     'Value' => 'O_DIRECT',
                                     'Variable_name' => 'innodb_flush_method'
                                   },
          'group_concat_max_len' => {
                                      'Value' => '1024',
                                      'Variable_name' => 'group_concat_max_len'
                                    },
          'relay_log_info_file' => {
                                     'Value' => 'relay-log.info',
                                     'Variable_name' => 'relay_log_info_file'
                                   },
          'sql_big_tables' => {
                                'Value' => 'OFF',
                                'Variable_name' => 'sql_big_tables'
                              },
          'connect_timeout' => {
                                 'Value' => '10',
                                 'Variable_name' => 'connect_timeout'
                               },
          'local_infile' => {
                              'Value' => 'ON',
                              'Variable_name' => 'local_infile'
                            },
          'innodb_read_io_threads' => {
                                        'Value' => '4',
                                        'Variable_name' => 'innodb_read_io_threads'
                                      },
          'query_cache_min_res_unit' => {
                                          'Value' => '4096',
                                          'Variable_name' => 'query_cache_min_res_unit'
                                        },
          'key_cache_age_threshold' => {
                                         'Value' => '300',
                                         'Variable_name' => 'key_cache_age_threshold'
                                       },
          'innodb_old_blocks_time' => {
                                        'Value' => '0',
                                        'Variable_name' => 'innodb_old_blocks_time'
                                      },
          'innodb_data_file_path' => {
                                       'Value' => 'ibdata1:10M:autoextend',
                                       'Variable_name' => 'innodb_data_file_path'
                                     },
          'innodb_force_recovery' => {
                                       'Value' => '0',
                                       'Variable_name' => 'innodb_force_recovery'
                                     },
          'expire_logs_days' => {
                                  'Value' => '0',
                                  'Variable_name' => 'expire_logs_days'
                                },
          'innodb_stats_method' => {
                                     'Value' => 'nulls_equal',
                                     'Variable_name' => 'innodb_stats_method'
                                   },
          'performance_schema_max_mutex_classes' => {
                                                      'Value' => '200',
                                                      'Variable_name' => 'performance_schema_max_mutex_classes'
                                                    },
          'optimizer_prune_level' => {
                                       'Value' => '1',
                                       'Variable_name' => 'optimizer_prune_level'
                                     },
          'relay_log_recovery' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'relay_log_recovery'
                                  },
          'innodb_max_purge_lag' => {
                                      'Value' => '0',
                                      'Variable_name' => 'innodb_max_purge_lag'
                                    },
          'innodb_version' => {
                                'Value' => '5.5.60',
                                'Variable_name' => 'innodb_version'
                              },
          'wait_timeout' => {
                              'Value' => '28800',
                              'Variable_name' => 'wait_timeout'
                            },
          'skip_name_resolve' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'skip_name_resolve'
                                 },
          'slave_compressed_protocol' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'slave_compressed_protocol'
                                         },
          'innodb_log_files_in_group' => {
                                           'Value' => '2',
                                           'Variable_name' => 'innodb_log_files_in_group'
                                         },
          'lower_case_file_system' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'lower_case_file_system'
                                      },
          'have_innodb' => {
                             'Value' => 'YES',
                             'Variable_name' => 'have_innodb'
                           },
          'transaction_alloc_block_size' => {
                                              'Value' => '8192',
                                              'Variable_name' => 'transaction_alloc_block_size'
                                            },
          'ft_boolean_syntax' => {
                                   'Value' => '+ -><()~*:""&|',
                                   'Variable_name' => 'ft_boolean_syntax'
                                 },
          'keep_files_on_create' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'keep_files_on_create'
                                    },
          'performance_schema_max_cond_instances' => {
                                                       'Value' => '1000',
                                                       'Variable_name' => 'performance_schema_max_cond_instances'
                                                     },
          'collation_database' => {
                                    'Value' => 'utf8mb4_general_ci',
                                    'Variable_name' => 'collation_database'
                                  },
          'innodb_lock_wait_timeout' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_lock_wait_timeout'
                                        },
          'query_cache_limit' => {
                                   'Value' => '1048576',
                                   'Variable_name' => 'query_cache_limit'
                                 },
          'collation_connection' => {
                                      'Value' => 'utf8mb4_general_ci',
                                      'Variable_name' => 'collation_connection'
                                    },
          'time_format' => {
                             'Value' => '%H:%i:%s',
                             'Variable_name' => 'time_format'
                           },
          'performance_schema_max_thread_instances' => {
                                                         'Value' => '1000',
                                                         'Variable_name' => 'performance_schema_max_thread_instances'
                                                       },
          'log_warnings' => {
                              'Value' => '1',
                              'Variable_name' => 'log_warnings'
                            },
          'read_only' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'read_only'
                         },
          'innodb_replication_delay' => {
                                          'Value' => '0',
                                          'Variable_name' => 'innodb_replication_delay'
                                        },
          'new' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'new'
                   },
          'innodb_adaptive_hash_index' => {
                                            'Value' => 'ON',
                                            'Variable_name' => 'innodb_adaptive_hash_index'
                                          },
          'performance_schema_max_rwlock_instances' => {
                                                         'Value' => '1000000',
                                                         'Variable_name' => 'performance_schema_max_rwlock_instances'
                                                       },
          'character_set_results' => {
                                       'Value' => 'utf8mb4',
                                       'Variable_name' => 'character_set_results'
                                     },
          'slave_skip_errors' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'slave_skip_errors'
                                 },
          'max_join_size' => {
                               'Value' => '18446744073709551615',
                               'Variable_name' => 'max_join_size'
                             },
          'innodb_large_prefix' => {
                                     'Value' => 'OFF',
                                     'Variable_name' => 'innodb_large_prefix'
                                   },
          'innodb_file_format_check' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_file_format_check'
                                        },
          'slow_launch_time' => {
                                  'Value' => '2',
                                  'Variable_name' => 'slow_launch_time'
                                },
          'have_ndbcluster' => {
                                 'Value' => 'NO',
                                 'Variable_name' => 'have_ndbcluster'
                               },
          'foreign_key_checks' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'foreign_key_checks'
                                  },
          'ignore_builtin_innodb' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'ignore_builtin_innodb'
                                     },
          'innodb_support_xa' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'innodb_support_xa'
                                 },
          'innodb_spin_wait_delay' => {
                                        'Value' => '6',
                                        'Variable_name' => 'innodb_spin_wait_delay'
                                      },
          'version_comment' => {
                                 'Value' => 'Source distribution',
                                 'Variable_name' => 'version_comment'
                               },
          'max_prepared_stmt_count' => {
                                         'Value' => '16382',
                                         'Variable_name' => 'max_prepared_stmt_count'
                                       },
          'max_delayed_threads' => {
                                     'Value' => '20',
                                     'Variable_name' => 'max_delayed_threads'
                                   },
          'sql_warnings' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'sql_warnings'
                            },
          'max_tmp_tables' => {
                                'Value' => '32',
                                'Variable_name' => 'max_tmp_tables'
                              },
          'log' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'log'
                   },
          'init_slave' => {
                            'Value' => '',
                            'Variable_name' => 'init_slave'
                          },
          'log_output' => {
                            'Value' => 'FILE',
                            'Variable_name' => 'log_output'
                          },
          'innodb_buffer_pool_instances' => {
                                              'Value' => '1',
                                              'Variable_name' => 'innodb_buffer_pool_instances'
                                            },
          'innodb_fast_shutdown' => {
                                      'Value' => '1',
                                      'Variable_name' => 'innodb_fast_shutdown'
                                    },
          'ft_stopword_file' => {
                                  'Value' => '(built-in)',
                                  'Variable_name' => 'ft_stopword_file'
                                },
          'innodb_log_file_size' => {
                                      'Value' => '5242880',
                                      'Variable_name' => 'innodb_log_file_size'
                                    },
          'max_binlog_size' => {
                                 'Value' => '1073741824',
                                 'Variable_name' => 'max_binlog_size'
                               },
          'time_zone' => {
                           'Value' => 'SYSTEM',
                           'Variable_name' => 'time_zone'
                         },
          'delayed_queue_size' => {
                                    'Value' => '1000',
                                    'Variable_name' => 'delayed_queue_size'
                                  },
          'myisam_mmap_size' => {
                                  'Value' => '18446744073709551615',
                                  'Variable_name' => 'myisam_mmap_size'
                                },
          'log_error' => {
                           'Value' => './error.log',
                           'Variable_name' => 'log_error'
                         },
          'range_alloc_block_size' => {
                                        'Value' => '4096',
                                        'Variable_name' => 'range_alloc_block_size'
                                      },
          'completion_type' => {
                                 'Value' => 'NO_CHAIN',
                                 'Variable_name' => 'completion_type'
                               },
          'innodb_use_sys_malloc' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_use_sys_malloc'
                                     },
          'character_set_server' => {
                                      'Value' => 'utf8mb4',
                                      'Variable_name' => 'character_set_server'
                                    },
          'transaction_prealloc_size' => {
                                           'Value' => '4096',
                                           'Variable_name' => 'transaction_prealloc_size'
                                         },
          'character_set_filesystem' => {
                                          'Value' => 'binary',
                                          'Variable_name' => 'character_set_filesystem'
                                        },
          'large_page_size' => {
                                 'Value' => '0',
                                 'Variable_name' => 'large_page_size'
                               },
          'performance_schema' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'performance_schema'
                                  },
          'sync_relay_log' => {
                                'Value' => '0',
                                'Variable_name' => 'sync_relay_log'
                              },
          'sync_master_info' => {
                                  'Value' => '0',
                                  'Variable_name' => 'sync_master_info'
                                },
          'innodb_log_buffer_size' => {
                                        'Value' => '8388608',
                                        'Variable_name' => 'innodb_log_buffer_size'
                                      },
          'innodb_old_blocks_pct' => {
                                       'Value' => '37',
                                       'Variable_name' => 'innodb_old_blocks_pct'
                                     },
          'character_set_database' => {
                                        'Value' => 'utf8mb4',
                                        'Variable_name' => 'character_set_database'
                                      },
          'sql_safe_updates' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'sql_safe_updates'
                                },
          'sql_mode' => {
                          'Value' => '',
                          'Variable_name' => 'sql_mode'
                        },
          'key_cache_division_limit' => {
                                          'Value' => '100',
                                          'Variable_name' => 'key_cache_division_limit'
                                        },
          'sync_relay_log_info' => {
                                     'Value' => '0',
                                     'Variable_name' => 'sync_relay_log_info'
                                   },
          'have_compress' => {
                               'Value' => 'YES',
                               'Variable_name' => 'have_compress'
                             },
          'sync_binlog' => {
                             'Value' => '0',
                             'Variable_name' => 'sync_binlog'
                           },
          'innodb_file_format_max' => {
                                        'Value' => 'Antelope',
                                        'Variable_name' => 'innodb_file_format_max'
                                      },
          'myisam_stats_method' => {
                                     'Value' => 'nulls_unequal',
                                     'Variable_name' => 'myisam_stats_method'
                                   },
          'plugin_dir' => {
                            'Value' => '/usr/mysql/5.5.60/lib/plugin/',
                            'Variable_name' => 'plugin_dir'
                          },
          'innodb_rollback_on_timeout' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_rollback_on_timeout'
                                          },
          'performance_schema_max_thread_classes' => {
                                                       'Value' => '50',
                                                       'Variable_name' => 'performance_schema_max_thread_classes'
                                                     },
          'query_cache_wlock_invalidate' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'query_cache_wlock_invalidate'
                                            },
          'tmpdir' => {
                        'Value' => '/tmp',
                        'Variable_name' => 'tmpdir'
                      },
          'performance_schema_max_rwlock_classes' => {
                                                       'Value' => '30',
                                                       'Variable_name' => 'performance_schema_max_rwlock_classes'
                                                     },
          'myisam_recover_options' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'myisam_recover_options'
                                      },
          'engine_condition_pushdown' => {
                                           'Value' => 'ON',
                                           'Variable_name' => 'engine_condition_pushdown'
                                         },
          'have_csv' => {
                          'Value' => 'YES',
                          'Variable_name' => 'have_csv'
                        },
          'have_query_cache' => {
                                  'Value' => 'YES',
                                  'Variable_name' => 'have_query_cache'
                                },
          'innodb_read_ahead_threshold' => {
                                             'Value' => '56',
                                             'Variable_name' => 'innodb_read_ahead_threshold'
                                           },
          'max_relay_log_size' => {
                                    'Value' => '0',
                                    'Variable_name' => 'max_relay_log_size'
                                  },
          'report_host' => {
                             'Value' => '',
                             'Variable_name' => 'report_host'
                           },
          'character_set_system' => {
                                      'Value' => 'utf8',
                                      'Variable_name' => 'character_set_system'
                                    },
          'innodb_locks_unsafe_for_binlog' => {
                                                'Value' => 'OFF',
                                                'Variable_name' => 'innodb_locks_unsafe_for_binlog'
                                              },
          'binlog_stmt_cache_size' => {
                                        'Value' => '32768',
                                        'Variable_name' => 'binlog_stmt_cache_size'
                                      },
          'delayed_insert_timeout' => {
                                        'Value' => '300',
                                        'Variable_name' => 'delayed_insert_timeout'
                                      },
          'basedir' => {
                         'Value' => '/usr/mysql/5.5.60',
                         'Variable_name' => 'basedir'
                       },
          'default_storage_engine' => {
                                        'Value' => 'InnoDB',
                                        'Variable_name' => 'default_storage_engine'
                                      },
          'innodb_stats_on_metadata' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_stats_on_metadata'
                                        },
          'myisam_data_pointer_size' => {
                                          'Value' => '6',
                                          'Variable_name' => 'myisam_data_pointer_size'
                                        },
          'myisam_repair_threads' => {
                                       'Value' => '1',
                                       'Variable_name' => 'myisam_repair_threads'
                                     },
          'long_query_time' => {
                                 'Value' => '1.000000',
                                 'Variable_name' => 'long_query_time'
                               },
          'old_alter_table' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'old_alter_table'
                               },
          'query_prealloc_size' => {
                                     'Value' => '8192',
                                     'Variable_name' => 'query_prealloc_size'
                                   },
          'thread_concurrency' => {
                                    'Value' => '10',
                                    'Variable_name' => 'thread_concurrency'
                                  },
          'ssl_capath' => {
                            'Value' => '',
                            'Variable_name' => 'ssl_capath'
                          },
          'stored_program_cache' => {
                                      'Value' => '256',
                                      'Variable_name' => 'stored_program_cache'
                                    },
          'sql_low_priority_updates' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'sql_low_priority_updates'
                                        },
          'ft_max_word_len' => {
                                 'Value' => '84',
                                 'Variable_name' => 'ft_max_word_len'
                               },
          'event_scheduler' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'event_scheduler'
                               },
          'storage_engine' => {
                                'Value' => 'InnoDB',
                                'Variable_name' => 'storage_engine'
                              },
          'big_tables' => {
                            'Value' => 'OFF',
                            'Variable_name' => 'big_tables'
                          },
          'slave_transaction_retries' => {
                                           'Value' => '10',
                                           'Variable_name' => 'slave_transaction_retries'
                                         },
          'binlog_format' => {
                               'Value' => 'STATEMENT',
                               'Variable_name' => 'binlog_format'
                             },
          'protocol_version' => {
                                  'Value' => '10',
                                  'Variable_name' => 'protocol_version'
                                },
          'skip_external_locking' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'skip_external_locking'
                                     },
          'innodb_io_capacity' => {
                                    'Value' => '200',
                                    'Variable_name' => 'innodb_io_capacity'
                                  },
          'binlog_direct_non_transactional_updates' => {
                                                         'Value' => 'OFF',
                                                         'Variable_name' => 'binlog_direct_non_transactional_updates'
                                                       },
          'version_compile_os' => {
                                    'Value' => 'Linux',
                                    'Variable_name' => 'version_compile_os'
                                  },
          'lc_messages' => {
                             'Value' => 'en_US',
                             'Variable_name' => 'lc_messages'
                           },
          'delayed_insert_limit' => {
                                      'Value' => '100',
                                      'Variable_name' => 'delayed_insert_limit'
                                    },
          'max_seeks_for_key' => {
                                   'Value' => '18446744073709551615',
                                   'Variable_name' => 'max_seeks_for_key'
                                 },
          'innodb_purge_threads' => {
                                      'Value' => '0',
                                      'Variable_name' => 'innodb_purge_threads'
                                    },
          'slave_max_allowed_packet' => {
                                          'Value' => '1073741824',
                                          'Variable_name' => 'slave_max_allowed_packet'
                                        },
          'log_queries_not_using_indexes' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'log_queries_not_using_indexes'
                                             },
          'innodb_thread_sleep_delay' => {
                                           'Value' => '10000',
                                           'Variable_name' => 'innodb_thread_sleep_delay'
                                         },
          'lc_time_names' => {
                               'Value' => 'en_US',
                               'Variable_name' => 'lc_time_names'
                             },
          'report_user' => {
                             'Value' => '',
                             'Variable_name' => 'report_user'
                           },
          'slow_query_log' => {
                                'Value' => 'ON',
                                'Variable_name' => 'slow_query_log'
                              },
          'innodb_autoinc_lock_mode' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_autoinc_lock_mode'
                                        },
          'innodb_open_files' => {
                                   'Value' => '300',
                                   'Variable_name' => 'innodb_open_files'
                                 },
          'slave_exec_mode' => {
                                 'Value' => 'STRICT',
                                 'Variable_name' => 'slave_exec_mode'
                               },
          'max_binlog_cache_size' => {
                                       'Value' => '18446744073709547520',
                                       'Variable_name' => 'max_binlog_cache_size'
                                     },
          'join_buffer_size' => {
                                  'Value' => '131072',
                                  'Variable_name' => 'join_buffer_size'
                                },
          'table_open_cache' => {
                                  'Value' => '400',
                                  'Variable_name' => 'table_open_cache'
                                },
          'sql_log_bin' => {
                             'Value' => 'ON',
                             'Variable_name' => 'sql_log_bin'
                           },
          'large_pages' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'large_pages'
                           },
          'key_buffer_size' => {
                                 'Value' => '8388608',
                                 'Variable_name' => 'key_buffer_size'
                               },
          'innodb_force_load_corrupted' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_force_load_corrupted'
                                           },
          'skip_networking' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'skip_networking'
                               },
          'max_long_data_size' => {
                                    'Value' => '1048576',
                                    'Variable_name' => 'max_long_data_size'
                                  },
          'license' => {
                         'Value' => 'GPL',
                         'Variable_name' => 'license'
                       },
          'innodb_concurrency_tickets' => {
                                            'Value' => '500',
                                            'Variable_name' => 'innodb_concurrency_tickets'
                                          },
          'skip_show_database' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'skip_show_database'
                                  },
          'flush_time' => {
                            'Value' => '0',
                            'Variable_name' => 'flush_time'
                          },
          'net_write_timeout' => {
                                   'Value' => '60',
                                   'Variable_name' => 'net_write_timeout'
                                 },
          'max_heap_table_size' => {
                                     'Value' => '16777216',
                                     'Variable_name' => 'max_heap_table_size'
                                   },
          'sql_select_limit' => {
                                  'Value' => '18446744073709551615',
                                  'Variable_name' => 'sql_select_limit'
                                },
          'ft_query_expansion_limit' => {
                                          'Value' => '20',
                                          'Variable_name' => 'ft_query_expansion_limit'
                                        },
          'max_connect_errors' => {
                                    'Value' => '10',
                                    'Variable_name' => 'max_connect_errors'
                                  },
          'performance_schema_max_file_classes' => {
                                                     'Value' => '50',
                                                     'Variable_name' => 'performance_schema_max_file_classes'
                                                   },
          'max_write_lock_count' => {
                                      'Value' => '18446744073709551615',
                                      'Variable_name' => 'max_write_lock_count'
                                    },
          'myisam_use_mmap' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'myisam_use_mmap'
                               },
          'performance_schema_max_file_instances' => {
                                                       'Value' => '10000',
                                                       'Variable_name' => 'performance_schema_max_file_instances'
                                                     },
          'have_profiling' => {
                                'Value' => 'YES',
                                'Variable_name' => 'have_profiling'
                              },
          'interactive_timeout' => {
                                     'Value' => '28800',
                                     'Variable_name' => 'interactive_timeout'
                                   },
          'report_port' => {
                             'Value' => '64055',
                             'Variable_name' => 'report_port'
                           },
          'have_geometry' => {
                               'Value' => 'YES',
                               'Variable_name' => 'have_geometry'
                             },
          'relay_log' => {
                           'Value' => 'relay',
                           'Variable_name' => 'relay_log'
                         },
          'performance_schema_events_waits_history_size' => {
                                                              'Value' => '10',
                                                              'Variable_name' => 'performance_schema_events_waits_history_size'
                                                            },
          'ssl_ca' => {
                        'Value' => '',
                        'Variable_name' => 'ssl_ca'
                      },
          'relay_log_index' => {
                                 'Value' => '',
                                 'Variable_name' => 'relay_log_index'
                               },
          'flush' => {
                       'Value' => 'OFF',
                       'Variable_name' => 'flush'
                     },
          'character_set_client' => {
                                      'Value' => 'utf8mb4',
                                      'Variable_name' => 'character_set_client'
                                    },
          'locked_in_memory' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'locked_in_memory'
                                },
          'innodb_use_native_aio' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_use_native_aio'
                                     },
          'binlog_cache_size' => {
                                   'Value' => '32768',
                                   'Variable_name' => 'binlog_cache_size'
                                 },
          'innodb_sync_spin_loops' => {
                                        'Value' => '30',
                                        'Variable_name' => 'innodb_sync_spin_loops'
                                      },
          'system_time_zone' => {
                                  'Value' => 'JST',
                                  'Variable_name' => 'system_time_zone'
                                },
          'innodb_checksums' => {
                                  'Value' => 'ON',
                                  'Variable_name' => 'innodb_checksums'
                                },
          'datetime_format' => {
                                 'Value' => '%Y-%m-%d %H:%i:%s',
                                 'Variable_name' => 'datetime_format'
                               },
          'innodb_change_buffering' => {
                                         'Value' => 'all',
                                         'Variable_name' => 'innodb_change_buffering'
                                       },
          'tx_isolation' => {
                              'Value' => 'REPEATABLE-READ',
                              'Variable_name' => 'tx_isolation'
                            },
          'log_bin_trust_function_creators' => {
                                                 'Value' => 'OFF',
                                                 'Variable_name' => 'log_bin_trust_function_creators'
                                               },
          'performance_schema_max_mutex_instances' => {
                                                        'Value' => '1000000',
                                                        'Variable_name' => 'performance_schema_max_mutex_instances'
                                                      },
          'log_slow_queries' => {
                                  'Value' => 'ON',
                                  'Variable_name' => 'log_slow_queries'
                                },
          'timed_mutexes' => {
                               'Value' => 'OFF',
                               'Variable_name' => 'timed_mutexes'
                             },
          'innodb_buffer_pool_size' => {
                                         'Value' => '134217728',
                                         'Variable_name' => 'innodb_buffer_pool_size'
                                       },
          'slave_type_conversions' => {
                                        'Value' => '',
                                        'Variable_name' => 'slave_type_conversions'
                                      },
          'myisam_sort_buffer_size' => {
                                         'Value' => '8388608',
                                         'Variable_name' => 'myisam_sort_buffer_size'
                                       },
          'init_file' => {
                           'Value' => '',
                           'Variable_name' => 'init_file'
                         },
          'innodb_rollback_segments' => {
                                          'Value' => '128',
                                          'Variable_name' => 'innodb_rollback_segments'
                                        },
          'default_week_format' => {
                                     'Value' => '0',
                                     'Variable_name' => 'default_week_format'
                                   },
          'innodb_commit_concurrency' => {
                                           'Value' => '0',
                                           'Variable_name' => 'innodb_commit_concurrency'
                                         },
          'optimizer_switch' => {
                                  'Value' => 'index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on',
                                  'Variable_name' => 'optimizer_switch'
                                },
          'innodb_purge_batch_size' => {
                                         'Value' => '20',
                                         'Variable_name' => 'innodb_purge_batch_size'
                                       },
          'unique_checks' => {
                               'Value' => 'ON',
                               'Variable_name' => 'unique_checks'
                             },
          'preload_buffer_size' => {
                                     'Value' => '32768',
                                     'Variable_name' => 'preload_buffer_size'
                                   },
          'read_buffer_size' => {
                                  'Value' => '131072',
                                  'Variable_name' => 'read_buffer_size'
                                },
          'innodb_data_home_dir' => {
                                      'Value' => '',
                                      'Variable_name' => 'innodb_data_home_dir'
                                    },
          'character_set_connection' => {
                                          'Value' => 'utf8mb4',
                                          'Variable_name' => 'character_set_connection'
                                        },
          'query_cache_type' => {
                                  'Value' => 'DEMAND',
                                  'Variable_name' => 'query_cache_type'
                                },
          'secure_file_priv' => {
                                  'Value' => '',
                                  'Variable_name' => 'secure_file_priv'
                                },
          'query_alloc_block_size' => {
                                        'Value' => '8192',
                                        'Variable_name' => 'query_alloc_block_size'
                                      },
          'log_slave_updates' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'log_slave_updates'
                                 },
          'port' => {
                      'Value' => '64055',
                      'Variable_name' => 'port'
                    },
          'socket' => {
                        'Value' => '/usr/mysql/5.5.60/data/mysql.sock',
                        'Variable_name' => 'socket'
                      },
          'tmp_table_size' => {
                                'Value' => '16777216',
                                'Variable_name' => 'tmp_table_size'
                              },
          'div_precision_increment' => {
                                         'Value' => '4',
                                         'Variable_name' => 'div_precision_increment'
                                       },
          'query_cache_size' => {
                                  'Value' => '33554432',
                                  'Variable_name' => 'query_cache_size'
                                },
          'innodb_strict_mode' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'innodb_strict_mode'
                                  },
          'collation_server' => {
                                  'Value' => 'utf8mb4_general_ci',
                                  'Variable_name' => 'collation_server'
                                },
          'old_passwords' => {
                               'Value' => 'OFF',
                               'Variable_name' => 'old_passwords'
                             },
          'relay_log_space_limit' => {
                                       'Value' => '0',
                                       'Variable_name' => 'relay_log_space_limit'
                                     },
          'ft_min_word_len' => {
                                 'Value' => '4',
                                 'Variable_name' => 'ft_min_word_len'
                               },
          'ssl_cipher' => {
                            'Value' => '',
                            'Variable_name' => 'ssl_cipher'
                          },
          'innodb_adaptive_flushing' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_adaptive_flushing'
                                        },
          'date_format' => {
                             'Value' => '%Y-%m-%d',
                             'Variable_name' => 'date_format'
                           },
          'max_binlog_stmt_cache_size' => {
                                            'Value' => '18446744073709547520',
                                            'Variable_name' => 'max_binlog_stmt_cache_size'
                                          },
          'innodb_write_io_threads' => {
                                         'Value' => '4',
                                         'Variable_name' => 'innodb_write_io_threads'
                                       },
          'metadata_locks_cache_size' => {
                                           'Value' => '1024',
                                           'Variable_name' => 'metadata_locks_cache_size'
                                         },
          'thread_cache_size' => {
                                   'Value' => '0',
                                   'Variable_name' => 'thread_cache_size'
                                 },
          'profiling' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'profiling'
                         },
          'updatable_views_with_limit' => {
                                            'Value' => 'YES',
                                            'Variable_name' => 'updatable_views_with_limit'
                                          },
          'table_definition_cache' => {
                                        'Value' => '400',
                                        'Variable_name' => 'table_definition_cache'
                                      },
          'performance_schema_max_cond_classes' => {
                                                     'Value' => '80',
                                                     'Variable_name' => 'performance_schema_max_cond_classes'
                                                   },
          'profiling_history_size' => {
                                        'Value' => '15',
                                        'Variable_name' => 'profiling_history_size'
                                      },
          'innodb_random_read_ahead' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_random_read_ahead'
                                        },
          'innodb_autoextend_increment' => {
                                             'Value' => '8',
                                             'Variable_name' => 'innodb_autoextend_increment'
                                           },
          'general_log_file' => {
                                  'Value' => 'general.log',
                                  'Variable_name' => 'general_log_file'
                                },
          'have_openssl' => {
                              'Value' => 'DISABLED',
                              'Variable_name' => 'have_openssl'
                            },
          'max_sort_length' => {
                                 'Value' => '1024',
                                 'Variable_name' => 'max_sort_length'
                               },
          'rpl_recovery_rank' => {
                                   'Value' => '0',
                                   'Variable_name' => 'rpl_recovery_rank'
                                 },
          'max_length_for_sort_data' => {
                                          'Value' => '1024',
                                          'Variable_name' => 'max_length_for_sort_data'
                                        }
        };


$mysql80 = {
          'sql_buffer_result' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'sql_buffer_result'
                                 },
          'admin_ssl_capath' => {
                                  'Value' => '',
                                  'Variable_name' => 'admin_ssl_capath'
                                },
          'innodb_log_checksums' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'innodb_log_checksums'
                                    },
          'low_priority_updates' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'low_priority_updates'
                                    },
          'innodb_page_cleaners' => {
                                      'Value' => '1',
                                      'Variable_name' => 'innodb_page_cleaners'
                                    },
          'innodb_buffer_pool_load_now' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_buffer_pool_load_now'
                                           },
          'ngram_token_size' => {
                                  'Value' => '2',
                                  'Variable_name' => 'ngram_token_size'
                                },
          'innodb_print_ddl_logs' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'innodb_print_ddl_logs'
                                     },
          'performance_schema_events_waits_history_long_size' => {
                                                                   'Value' => '1000',
                                                                   'Variable_name' => 'performance_schema_events_waits_history_long_size'
                                                                 },
          'binlog_max_flush_queue_time' => {
                                             'Value' => '0',
                                             'Variable_name' => 'binlog_max_flush_queue_time'
                                           },
          'gtid_owned' => {
                            'Value' => '',
                            'Variable_name' => 'gtid_owned'
                          },
          'innodb_compression_level' => {
                                          'Value' => '6',
                                          'Variable_name' => 'innodb_compression_level'
                                        },
          'innodb_deadlock_detect' => {
                                        'Value' => 'ON',
                                        'Variable_name' => 'innodb_deadlock_detect'
                                      },
          'slave_load_tmpdir' => {
                                   'Value' => '/tmp',
                                   'Variable_name' => 'slave_load_tmpdir'
                                 },
          'admin_ssl_ca' => {
                              'Value' => '',
                              'Variable_name' => 'admin_ssl_ca'
                            },
          'clone_buffer_size' => {
                                   'Value' => '4194304',
                                   'Variable_name' => 'clone_buffer_size'
                                 },
          'innodb_buffer_pool_filename' => {
                                             'Value' => 'ib_buffer_pool',
                                             'Variable_name' => 'innodb_buffer_pool_filename'
                                           },
          'auto_increment_offset' => {
                                       'Value' => '1',
                                       'Variable_name' => 'auto_increment_offset'
                                     },
          'innodb_stats_include_delete_marked' => {
                                                    'Value' => 'OFF',
                                                    'Variable_name' => 'innodb_stats_include_delete_marked'
                                                  },
          'caching_sha2_password_private_key_path' => {
                                                        'Value' => 'private_key.pem',
                                                        'Variable_name' => 'caching_sha2_password_private_key_path'
                                                      },
          'binlog_row_metadata' => {
                                     'Value' => 'MINIMAL',
                                     'Variable_name' => 'binlog_row_metadata'
                                   },
          'performance_schema_max_table_instances' => {
                                                        'Value' => '-1',
                                                        'Variable_name' => 'performance_schema_max_table_instances'
                                                      },
          'performance_schema_max_socket_instances' => {
                                                         'Value' => '-1',
                                                         'Variable_name' => 'performance_schema_max_socket_instances'
                                                       },
          'large_files_support' => {
                                     'Value' => 'ON',
                                     'Variable_name' => 'large_files_support'
                                   },
          'lock_wait_timeout' => {
                                   'Value' => '31536000',
                                   'Variable_name' => 'lock_wait_timeout'
                                 },
          'lower_case_table_names' => {
                                        'Value' => '1',
                                        'Variable_name' => 'lower_case_table_names'
                                      },
          'innodb_stats_persistent' => {
                                         'Value' => 'ON',
                                         'Variable_name' => 'innodb_stats_persistent'
                                       },
          'slave_checkpoint_period' => {
                                         'Value' => '300',
                                         'Variable_name' => 'slave_checkpoint_period'
                                       },
          'sql_notes' => {
                           'Value' => 'ON',
                           'Variable_name' => 'sql_notes'
                         },
          'default_authentication_plugin' => {
                                               'Value' => 'mysql_native_password',
                                               'Variable_name' => 'default_authentication_plugin'
                                             },
          'init_connect' => {
                              'Value' => '',
                              'Variable_name' => 'init_connect'
                            },
          'slave_net_timeout' => {
                                   'Value' => '60',
                                   'Variable_name' => 'slave_net_timeout'
                                 },
          'datadir' => {
                         'Value' => '/usr/mysql/8.0.22/data/',
                         'Variable_name' => 'datadir'
                       },
          'innodb_api_enable_mdl' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'innodb_api_enable_mdl'
                                     },
          'sql_auto_is_null' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'sql_auto_is_null'
                                },
          'general_log' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'general_log'
                           },
          'innodb_buffer_pool_chunk_size' => {
                                               'Value' => '134217728',
                                               'Variable_name' => 'innodb_buffer_pool_chunk_size'
                                             },
          'report_password' => {
                                 'Value' => '',
                                 'Variable_name' => 'report_password'
                               },
          'min_examined_row_limit' => {
                                        'Value' => '0',
                                        'Variable_name' => 'min_examined_row_limit'
                                      },
          'max_user_connections' => {
                                      'Value' => '0',
                                      'Variable_name' => 'max_user_connections'
                                    },
          'gtid_executed' => {
                               'Value' => '04829ca1-136d-11eb-97d8-0201965f8d32:1-3257003',
                               'Variable_name' => 'gtid_executed'
                             },
          'innodb_ft_enable_diag_print' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_ft_enable_diag_print'
                                           },
          'innodb_compression_failure_threshold_pct' => {
                                                          'Value' => '5',
                                                          'Variable_name' => 'innodb_compression_failure_threshold_pct'
                                                        },
          'delay_key_write' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'delay_key_write'
                               },
          'innodb_buffer_pool_dump_pct' => {
                                             'Value' => '100',
                                             'Variable_name' => 'innodb_buffer_pool_dump_pct'
                                           },
          'performance_schema_max_stage_classes' => {
                                                      'Value' => '175',
                                                      'Variable_name' => 'performance_schema_max_stage_classes'
                                                    },
          'myisam_max_sort_file_size' => {
                                           'Value' => '9223372036853727232',
                                           'Variable_name' => 'myisam_max_sort_file_size'
                                         },
          'innodb_undo_tablespaces' => {
                                         'Value' => '2',
                                         'Variable_name' => 'innodb_undo_tablespaces'
                                       },
          'innodb_flush_log_at_trx_commit' => {
                                                'Value' => '1',
                                                'Variable_name' => 'innodb_flush_log_at_trx_commit'
                                              },
          'innodb_doublewrite' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_doublewrite'
                                  },
          'bulk_insert_buffer_size' => {
                                         'Value' => '8388608',
                                         'Variable_name' => 'bulk_insert_buffer_size'
                                       },
          'session_track_state_change' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'session_track_state_change'
                                          },
          'back_log' => {
                          'Value' => '151',
                          'Variable_name' => 'back_log'
                        },
          'performance_schema_events_transactions_history_size' => {
                                                                     'Value' => '10',
                                                                     'Variable_name' => 'performance_schema_events_transactions_history_size'
                                                                   },
          'innodb_ft_cache_size' => {
                                      'Value' => '8000000',
                                      'Variable_name' => 'innodb_ft_cache_size'
                                    },
          'relay_log_info_repository' => {
                                           'Value' => 'TABLE',
                                           'Variable_name' => 'relay_log_info_repository'
                                         },
          'binlog_gtid_simple_recovery' => {
                                             'Value' => 'ON',
                                             'Variable_name' => 'binlog_gtid_simple_recovery'
                                           },
          'ssl_cert' => {
                          'Value' => 'server-cert.pem',
                          'Variable_name' => 'ssl_cert'
                        },
          'sort_buffer_size' => {
                                  'Value' => '262144',
                                  'Variable_name' => 'sort_buffer_size'
                                },
          'persist_only_admin_x509_subject' => {
                                                 'Value' => '',
                                                 'Variable_name' => 'persist_only_admin_x509_subject'
                                               },
          'binlog_encryption' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'binlog_encryption'
                                 },
          'password_reuse_interval' => {
                                         'Value' => '0',
                                         'Variable_name' => 'password_reuse_interval'
                                       },
          'concurrent_insert' => {
                                   'Value' => 'AUTO',
                                   'Variable_name' => 'concurrent_insert'
                                 },
          'sql_slave_skip_counter' => {
                                        'Value' => '0',
                                        'Variable_name' => 'sql_slave_skip_counter'
                                      },
          'performance_schema_hosts_size' => {
                                               'Value' => '-1',
                                               'Variable_name' => 'performance_schema_hosts_size'
                                             },
          'end_markers_in_json' => {
                                     'Value' => 'OFF',
                                     'Variable_name' => 'end_markers_in_json'
                                   },
          'net_read_timeout' => {
                                  'Value' => '30',
                                  'Variable_name' => 'net_read_timeout'
                                },
          'log_slow_slave_statements' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'log_slow_slave_statements'
                                         },
          'slow_query_log_file' => {
                                     'Value' => 'slow.log',
                                     'Variable_name' => 'slow_query_log_file'
                                   },
          'have_dynamic_loading' => {
                                      'Value' => 'YES',
                                      'Variable_name' => 'have_dynamic_loading'
                                    },
          'block_encryption_mode' => {
                                       'Value' => 'aes-128-ecb',
                                       'Variable_name' => 'block_encryption_mode'
                                     },
          'innodb_checksum_algorithm' => {
                                           'Value' => 'crc32',
                                           'Variable_name' => 'innodb_checksum_algorithm'
                                         },
          'autocommit' => {
                            'Value' => 'ON',
                            'Variable_name' => 'autocommit'
                          },
          'max_connections' => {
                                 'Value' => '151',
                                 'Variable_name' => 'max_connections'
                               },
          'log_bin_use_v1_row_events' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'log_bin_use_v1_row_events'
                                         },
          'innodb_stats_auto_recalc' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_stats_auto_recalc'
                                        },
          'innodb_flush_method' => {
                                     'Value' => 'O_DIRECT',
                                     'Variable_name' => 'innodb_flush_method'
                                   },
          'binlog_order_commits' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'binlog_order_commits'
                                    },
          'binlog_transaction_dependency_history_size' => {
                                                            'Value' => '25000',
                                                            'Variable_name' => 'binlog_transaction_dependency_history_size'
                                                          },
          'sha256_password_proxy_users' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'sha256_password_proxy_users'
                                           },
          'optimizer_trace' => {
                                 'Value' => 'enabled=off,one_line=off',
                                 'Variable_name' => 'optimizer_trace'
                               },
          'transaction_allow_batching' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'transaction_allow_batching'
                                          },
          'innodb_read_io_threads' => {
                                        'Value' => '4',
                                        'Variable_name' => 'innodb_read_io_threads'
                                      },
          'innodb_ft_user_stopword_table' => {
                                               'Value' => '',
                                               'Variable_name' => 'innodb_ft_user_stopword_table'
                                             },
          'admin_ssl_key' => {
                               'Value' => '',
                               'Variable_name' => 'admin_ssl_key'
                             },
          'key_cache_age_threshold' => {
                                         'Value' => '300',
                                         'Variable_name' => 'key_cache_age_threshold'
                                       },
          'clone_ssl_cert' => {
                                'Value' => '',
                                'Variable_name' => 'clone_ssl_cert'
                              },
          'innodb_log_wait_for_flush_spin_hwm' => {
                                                    'Value' => '400',
                                                    'Variable_name' => 'innodb_log_wait_for_flush_spin_hwm'
                                                  },
          'admin_ssl_crlpath' => {
                                   'Value' => '',
                                   'Variable_name' => 'admin_ssl_crlpath'
                                 },
          'clone_max_network_bandwidth' => {
                                             'Value' => '0',
                                             'Variable_name' => 'clone_max_network_bandwidth'
                                           },
          'innodb_old_blocks_time' => {
                                        'Value' => '1000',
                                        'Variable_name' => 'innodb_old_blocks_time'
                                      },
          'innodb_data_file_path' => {
                                       'Value' => 'ibdata1:12M:autoextend',
                                       'Variable_name' => 'innodb_data_file_path'
                                     },
          'log_raw' => {
                         'Value' => 'OFF',
                         'Variable_name' => 'log_raw'
                       },
          'innodb_stats_method' => {
                                     'Value' => 'nulls_equal',
                                     'Variable_name' => 'innodb_stats_method'
                                   },
          'pseudo_slave_mode' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'pseudo_slave_mode'
                                 },
          'performance_schema_max_mutex_classes' => {
                                                      'Value' => '300',
                                                      'Variable_name' => 'performance_schema_max_mutex_classes'
                                                    },
          'optimizer_prune_level' => {
                                       'Value' => '1',
                                       'Variable_name' => 'optimizer_prune_level'
                                     },
          'print_identified_with_as_hex' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'print_identified_with_as_hex'
                                            },
          'relay_log_recovery' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'relay_log_recovery'
                                  },
          'innodb_version' => {
                                'Value' => '8.0.22',
                                'Variable_name' => 'innodb_version'
                              },
          'wait_timeout' => {
                              'Value' => '28800',
                              'Variable_name' => 'wait_timeout'
                            },
          'skip_name_resolve' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'skip_name_resolve'
                                 },
          'performance_schema_max_table_lock_stat' => {
                                                        'Value' => '-1',
                                                        'Variable_name' => 'performance_schema_max_table_lock_stat'
                                                      },
          'transaction_read_only' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'transaction_read_only'
                                     },
          'performance_schema_max_metadata_locks' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_max_metadata_locks'
                                                     },
          'clone_valid_donor_list' => {
                                        'Value' => '',
                                        'Variable_name' => 'clone_valid_donor_list'
                                      },
          'ft_boolean_syntax' => {
                                   'Value' => '+ -><()~*:""&|',
                                   'Variable_name' => 'ft_boolean_syntax'
                                 },
          'keep_files_on_create' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'keep_files_on_create'
                                    },
          'innodb_idle_flush_pct' => {
                                       'Value' => '100',
                                       'Variable_name' => 'innodb_idle_flush_pct'
                                     },
          'performance_schema_max_cond_instances' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_max_cond_instances'
                                                     },
          'host_cache_size' => {
                                 'Value' => '279',
                                 'Variable_name' => 'host_cache_size'
                               },
          'avoid_temporal_upgrade' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'avoid_temporal_upgrade'
                                      },
          'collation_database' => {
                                    'Value' => 'utf8mb4_0900_ai_ci',
                                    'Variable_name' => 'collation_database'
                                  },
          'clone_ddl_timeout' => {
                                   'Value' => '300',
                                   'Variable_name' => 'clone_ddl_timeout'
                                 },
          'innodb_io_capacity_max' => {
                                        'Value' => '2000',
                                        'Variable_name' => 'innodb_io_capacity_max'
                                      },
          'innodb_lock_wait_timeout' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_lock_wait_timeout'
                                        },
          'collation_connection' => {
                                      'Value' => 'utf8_general_ci',
                                      'Variable_name' => 'collation_connection'
                                    },
          'innodb_dedicated_server' => {
                                         'Value' => 'OFF',
                                         'Variable_name' => 'innodb_dedicated_server'
                                       },
          'performance_schema_max_thread_instances' => {
                                                         'Value' => '-1',
                                                         'Variable_name' => 'performance_schema_max_thread_instances'
                                                       },
          'server_id_bits' => {
                                'Value' => '32',
                                'Variable_name' => 'server_id_bits'
                              },
          'innodb_adaptive_hash_index' => {
                                            'Value' => 'ON',
                                            'Variable_name' => 'innodb_adaptive_hash_index'
                                          },
          'performance_schema_max_rwlock_instances' => {
                                                         'Value' => '-1',
                                                         'Variable_name' => 'performance_schema_max_rwlock_instances'
                                                       },
          'performance_schema_max_index_stat' => {
                                                   'Value' => '-1',
                                                   'Variable_name' => 'performance_schema_max_index_stat'
                                                 },
          'table_open_cache_instances' => {
                                            'Value' => '16',
                                            'Variable_name' => 'table_open_cache_instances'
                                          },
          'max_join_size' => {
                               'Value' => '18446744073709551615',
                               'Variable_name' => 'max_join_size'
                             },
          'bind_address' => {
                              'Value' => '*',
                              'Variable_name' => 'bind_address'
                            },
          'performance_schema_session_connect_attrs_size' => {
                                                               'Value' => '512',
                                                               'Variable_name' => 'performance_schema_session_connect_attrs_size'
                                                             },
          'binlog_group_commit_sync_no_delay_count' => {
                                                         'Value' => '0',
                                                         'Variable_name' => 'binlog_group_commit_sync_no_delay_count'
                                                       },
          'admin_ssl_cipher' => {
                                  'Value' => '',
                                  'Variable_name' => 'admin_ssl_cipher'
                                },
          'pseudo_thread_id' => {
                                  'Value' => '12',
                                  'Variable_name' => 'pseudo_thread_id'
                                },
          'persisted_globals_load' => {
                                        'Value' => 'ON',
                                        'Variable_name' => 'persisted_globals_load'
                                      },
          'insert_id' => {
                           'Value' => '0',
                           'Variable_name' => 'insert_id'
                         },
          'log_output' => {
                            'Value' => 'FILE',
                            'Variable_name' => 'log_output'
                          },
          'password_history' => {
                                  'Value' => '0',
                                  'Variable_name' => 'password_history'
                                },
          'mandatory_roles' => {
                                 'Value' => '',
                                 'Variable_name' => 'mandatory_roles'
                               },
          'innodb_fast_shutdown' => {
                                      'Value' => '1',
                                      'Variable_name' => 'innodb_fast_shutdown'
                                    },
          'innodb_log_file_size' => {
                                      'Value' => '50331648',
                                      'Variable_name' => 'innodb_log_file_size'
                                    },
          'ft_stopword_file' => {
                                  'Value' => '(built-in)',
                                  'Variable_name' => 'ft_stopword_file'
                                },
          'time_zone' => {
                           'Value' => 'SYSTEM',
                           'Variable_name' => 'time_zone'
                         },
          'partial_revokes' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'partial_revokes'
                               },
          'range_alloc_block_size' => {
                                        'Value' => '4096',
                                        'Variable_name' => 'range_alloc_block_size'
                                      },
          'log_slow_admin_statements' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'log_slow_admin_statements'
                                         },
          'completion_type' => {
                                 'Value' => 'NO_CHAIN',
                                 'Variable_name' => 'completion_type'
                               },
          'character_set_server' => {
                                      'Value' => 'utf8mb4',
                                      'Variable_name' => 'character_set_server'
                                    },
          'character_set_filesystem' => {
                                          'Value' => 'binary',
                                          'Variable_name' => 'character_set_filesystem'
                                        },
          'master_info_repository' => {
                                        'Value' => 'TABLE',
                                        'Variable_name' => 'master_info_repository'
                                      },
          'innodb_status_output' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'innodb_status_output'
                                    },
          'performance_schema' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'performance_schema'
                                  },
          'innodb_default_row_format' => {
                                           'Value' => 'dynamic',
                                           'Variable_name' => 'innodb_default_row_format'
                                         },
          'sync_relay_log' => {
                                'Value' => '10000',
                                'Variable_name' => 'sync_relay_log'
                              },
          'sync_master_info' => {
                                  'Value' => '10000',
                                  'Variable_name' => 'sync_master_info'
                                },
          'innodb_log_buffer_size' => {
                                        'Value' => '16777216',
                                        'Variable_name' => 'innodb_log_buffer_size'
                                      },
          'character_set_database' => {
                                        'Value' => 'utf8mb4',
                                        'Variable_name' => 'character_set_database'
                                      },
          'innodb_ft_enable_stopword' => {
                                           'Value' => 'ON',
                                           'Variable_name' => 'innodb_ft_enable_stopword'
                                         },
          'sql_safe_updates' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'sql_safe_updates'
                                },
          'original_commit_timestamp' => {
                                           'Value' => '36028797018963968',
                                           'Variable_name' => 'original_commit_timestamp'
                                         },
          'innodb_ft_total_cache_size' => {
                                            'Value' => '640000000',
                                            'Variable_name' => 'innodb_ft_total_cache_size'
                                          },
          'sql_mode' => {
                          'Value' => 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION',
                          'Variable_name' => 'sql_mode'
                        },
          'key_cache_division_limit' => {
                                          'Value' => '100',
                                          'Variable_name' => 'key_cache_division_limit'
                                        },
          'have_compress' => {
                               'Value' => 'YES',
                               'Variable_name' => 'have_compress'
                             },
          'sync_binlog' => {
                             'Value' => '1',
                             'Variable_name' => 'sync_binlog'
                           },
          'secondary_engine_cost_threshold' => {
                                                 'Value' => '100000.000000',
                                                 'Variable_name' => 'secondary_engine_cost_threshold'
                                               },
          'innodb_doublewrite_pages' => {
                                          'Value' => '4',
                                          'Variable_name' => 'innodb_doublewrite_pages'
                                        },
          'plugin_dir' => {
                            'Value' => '/usr/mysql/8.0.22/lib/plugin/',
                            'Variable_name' => 'plugin_dir'
                          },
          'performance_schema_max_thread_classes' => {
                                                       'Value' => '100',
                                                       'Variable_name' => 'performance_schema_max_thread_classes'
                                                     },
          'admin_tls_version' => {
                                   'Value' => 'TLSv1,TLSv1.1,TLSv1.2',
                                   'Variable_name' => 'admin_tls_version'
                                 },
          'generated_random_password_length' => {
                                                  'Value' => '20',
                                                  'Variable_name' => 'generated_random_password_length'
                                                },
          'gtid_mode' => {
                           'Value' => 'ON',
                           'Variable_name' => 'gtid_mode'
                         },
          'innodb_read_ahead_threshold' => {
                                             'Value' => '56',
                                             'Variable_name' => 'innodb_read_ahead_threshold'
                                           },
          'max_relay_log_size' => {
                                    'Value' => '0',
                                    'Variable_name' => 'max_relay_log_size'
                                  },
          'report_host' => {
                             'Value' => '',
                             'Variable_name' => 'report_host'
                           },
          'log_statements_unsafe_for_binlog' => {
                                                  'Value' => 'ON',
                                                  'Variable_name' => 'log_statements_unsafe_for_binlog'
                                                },
          'character_set_system' => {
                                      'Value' => 'utf8',
                                      'Variable_name' => 'character_set_system'
                                    },
          'performance_schema_max_prepared_statements_instances' => {
                                                                      'Value' => '-1',
                                                                      'Variable_name' => 'performance_schema_max_prepared_statements_instances'
                                                                    },
          'performance_schema_error_size' => {
                                               'Value' => '4808',
                                               'Variable_name' => 'performance_schema_error_size'
                                             },
          'performance_schema_max_statement_stack' => {
                                                        'Value' => '10',
                                                        'Variable_name' => 'performance_schema_max_statement_stack'
                                                      },
          'optimizer_trace_features' => {
                                          'Value' => 'greedy_search=on,range_optimizer=on,dynamic_range=on,repeated_subselect=on',
                                          'Variable_name' => 'optimizer_trace_features'
                                        },
          'log_error_verbosity' => {
                                     'Value' => '3',
                                     'Variable_name' => 'log_error_verbosity'
                                   },
          'ssl_fips_mode' => {
                               'Value' => 'OFF',
                               'Variable_name' => 'ssl_fips_mode'
                             },
          'basedir' => {
                         'Value' => '/usr/mysql/8.0.22/',
                         'Variable_name' => 'basedir'
                       },
          'require_row_format' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'require_row_format'
                                  },
          'cte_max_recursion_depth' => {
                                         'Value' => '1000',
                                         'Variable_name' => 'cte_max_recursion_depth'
                                       },
          'clone_enable_compression' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'clone_enable_compression'
                                        },
          'identity' => {
                          'Value' => '0',
                          'Variable_name' => 'identity'
                        },
          'myisam_data_pointer_size' => {
                                          'Value' => '6',
                                          'Variable_name' => 'myisam_data_pointer_size'
                                        },
          'myisam_repair_threads' => {
                                       'Value' => '1',
                                       'Variable_name' => 'myisam_repair_threads'
                                     },
          'innodb_compression_pad_pct_max' => {
                                                'Value' => '50',
                                                'Variable_name' => 'innodb_compression_pad_pct_max'
                                              },
          'version_compile_zlib' => {
                                      'Value' => '1.2.11',
                                      'Variable_name' => 'version_compile_zlib'
                                    },
          'long_query_time' => {
                                 'Value' => '0.000000',
                                 'Variable_name' => 'long_query_time'
                               },
          'sha256_password_private_key_path' => {
                                                  'Value' => 'private_key.pem',
                                                  'Variable_name' => 'sha256_password_private_key_path'
                                                },
          'stored_program_cache' => {
                                      'Value' => '256',
                                      'Variable_name' => 'stored_program_cache'
                                    },
          'ft_max_word_len' => {
                                 'Value' => '84',
                                 'Variable_name' => 'ft_max_word_len'
                               },
          'protocol_version' => {
                                  'Value' => '10',
                                  'Variable_name' => 'protocol_version'
                                },
          'skip_external_locking' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'skip_external_locking'
                                     },
          'performance_schema_max_digest_sample_age' => {
                                                          'Value' => '60',
                                                          'Variable_name' => 'performance_schema_max_digest_sample_age'
                                                        },
          'binlog_direct_non_transactional_updates' => {
                                                         'Value' => 'OFF',
                                                         'Variable_name' => 'binlog_direct_non_transactional_updates'
                                                       },
          'version_compile_os' => {
                                    'Value' => 'Linux',
                                    'Variable_name' => 'version_compile_os'
                                  },
          'lc_messages' => {
                             'Value' => 'en_US',
                             'Variable_name' => 'lc_messages'
                           },
          'innodb_purge_threads' => {
                                      'Value' => '4',
                                      'Variable_name' => 'innodb_purge_threads'
                                    },
          'windowing_use_high_precision' => {
                                              'Value' => 'ON',
                                              'Variable_name' => 'windowing_use_high_precision'
                                            },
          'performance_schema_events_statements_history_long_size' => {
                                                                        'Value' => '1000',
                                                                        'Variable_name' => 'performance_schema_events_statements_history_long_size'
                                                                      },
          'slave_max_allowed_packet' => {
                                          'Value' => '1073741824',
                                          'Variable_name' => 'slave_max_allowed_packet'
                                        },
          'log_queries_not_using_indexes' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'log_queries_not_using_indexes'
                                             },
          'lc_time_names' => {
                               'Value' => 'en_US',
                               'Variable_name' => 'lc_time_names'
                             },
          'report_user' => {
                             'Value' => '',
                             'Variable_name' => 'report_user'
                           },
          'innodb_tmpdir' => {
                               'Value' => '',
                               'Variable_name' => 'innodb_tmpdir'
                             },
          'binlog_rows_query_log_events' => {
                                              'Value' => 'ON',
                                              'Variable_name' => 'binlog_rows_query_log_events'
                                            },
          'innodb_autoinc_lock_mode' => {
                                          'Value' => '2',
                                          'Variable_name' => 'innodb_autoinc_lock_mode'
                                        },
          'innodb_open_files' => {
                                   'Value' => '431',
                                   'Variable_name' => 'innodb_open_files'
                                 },
          'slave_exec_mode' => {
                                 'Value' => 'STRICT',
                                 'Variable_name' => 'slave_exec_mode'
                               },
          'max_binlog_cache_size' => {
                                       'Value' => '18446744073709547520',
                                       'Variable_name' => 'max_binlog_cache_size'
                                     },
          'slave_pending_jobs_size_max' => {
                                             'Value' => '134217728',
                                             'Variable_name' => 'slave_pending_jobs_size_max'
                                           },
          'innodb_monitor_reset' => {
                                      'Value' => '',
                                      'Variable_name' => 'innodb_monitor_reset'
                                    },
          'table_open_cache' => {
                                  'Value' => '431',
                                  'Variable_name' => 'table_open_cache'
                                },
          'performance_schema_setup_actors_size' => {
                                                      'Value' => '-1',
                                                      'Variable_name' => 'performance_schema_setup_actors_size'
                                                    },
          'large_pages' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'large_pages'
                           },
          'proxy_user' => {
                            'Value' => '',
                            'Variable_name' => 'proxy_user'
                          },
          'default_tmp_storage_engine' => {
                                            'Value' => 'InnoDB',
                                            'Variable_name' => 'default_tmp_storage_engine'
                                          },
          'innodb_ft_num_word_optimize' => {
                                             'Value' => '2000',
                                             'Variable_name' => 'innodb_ft_num_word_optimize'
                                           },
          'skip_networking' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'skip_networking'
                               },
          'max_digest_length' => {
                                   'Value' => '1024',
                                   'Variable_name' => 'max_digest_length'
                                 },
          'innodb_directories' => {
                                    'Value' => '',
                                    'Variable_name' => 'innodb_directories'
                                  },
          'license' => {
                         'Value' => 'GPL',
                         'Variable_name' => 'license'
                       },
          'innodb_log_compressed_pages' => {
                                             'Value' => 'ON',
                                             'Variable_name' => 'innodb_log_compressed_pages'
                                           },
          'innodb_concurrency_tickets' => {
                                            'Value' => '5000',
                                            'Variable_name' => 'innodb_concurrency_tickets'
                                          },
          'innodb_fsync_threshold' => {
                                        'Value' => '0',
                                        'Variable_name' => 'innodb_fsync_threshold'
                                      },
          'skip_show_database' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'skip_show_database'
                                  },
          'performance_schema_users_size' => {
                                               'Value' => '-1',
                                               'Variable_name' => 'performance_schema_users_size'
                                             },
          'binlog_row_value_options' => {
                                          'Value' => '',
                                          'Variable_name' => 'binlog_row_value_options'
                                        },
          'admin_ssl_cert' => {
                                'Value' => '',
                                'Variable_name' => 'admin_ssl_cert'
                              },
          'binlog_row_event_max_size' => {
                                           'Value' => '8192',
                                           'Variable_name' => 'binlog_row_event_max_size'
                                         },
          'auto_generate_certs' => {
                                     'Value' => 'ON',
                                     'Variable_name' => 'auto_generate_certs'
                                   },
          'caching_sha2_password_public_key_path' => {
                                                       'Value' => 'public_key.pem',
                                                       'Variable_name' => 'caching_sha2_password_public_key_path'
                                                     },
          'performance_schema_max_file_classes' => {
                                                     'Value' => '80',
                                                     'Variable_name' => 'performance_schema_max_file_classes'
                                                   },
          'myisam_use_mmap' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'myisam_use_mmap'
                               },
          'max_write_lock_count' => {
                                      'Value' => '18446744073709551615',
                                      'Variable_name' => 'max_write_lock_count'
                                    },
          'innodb_log_spin_cpu_pct_hwm' => {
                                             'Value' => '50',
                                             'Variable_name' => 'innodb_log_spin_cpu_pct_hwm'
                                           },
          'interactive_timeout' => {
                                     'Value' => '28800',
                                     'Variable_name' => 'interactive_timeout'
                                   },
          'report_port' => {
                             'Value' => '64080',
                             'Variable_name' => 'report_port'
                           },
          'group_replication_consistency' => {
                                               'Value' => 'EVENTUAL',
                                               'Variable_name' => 'group_replication_consistency'
                                             },
          'innodb_adaptive_flushing_lwm' => {
                                              'Value' => '10',
                                              'Variable_name' => 'innodb_adaptive_flushing_lwm'
                                            },
          'check_proxy_users' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'check_proxy_users'
                                 },
          'default_password_lifetime' => {
                                           'Value' => '0',
                                           'Variable_name' => 'default_password_lifetime'
                                         },
          'have_geometry' => {
                               'Value' => 'YES',
                               'Variable_name' => 'have_geometry'
                             },
          'innodb_optimize_fulltext_only' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'innodb_optimize_fulltext_only'
                                             },
          'ssl_ca' => {
                        'Value' => 'ca.pem',
                        'Variable_name' => 'ssl_ca'
                      },
          'binlog_group_commit_sync_delay' => {
                                                'Value' => '0',
                                                'Variable_name' => 'binlog_group_commit_sync_delay'
                                              },
          'clone_max_concurrency' => {
                                       'Value' => '16',
                                       'Variable_name' => 'clone_max_concurrency'
                                     },
          'character_set_client' => {
                                      'Value' => 'utf8',
                                      'Variable_name' => 'character_set_client'
                                    },
          'binlog_checksum' => {
                                 'Value' => 'CRC32',
                                 'Variable_name' => 'binlog_checksum'
                               },
          'binlog_transaction_compression' => {
                                                'Value' => 'ON',
                                                'Variable_name' => 'binlog_transaction_compression'
                                              },
          'system_time_zone' => {
                                  'Value' => 'JST',
                                  'Variable_name' => 'system_time_zone'
                                },
          'performance_schema_max_statement_classes' => {
                                                          'Value' => '218',
                                                          'Variable_name' => 'performance_schema_max_statement_classes'
                                                        },
          'innodb_stats_transient_sample_pages' => {
                                                     'Value' => '8',
                                                     'Variable_name' => 'innodb_stats_transient_sample_pages'
                                                   },
          'performance_schema_events_stages_history_long_size' => {
                                                                    'Value' => '1000',
                                                                    'Variable_name' => 'performance_schema_events_stages_history_long_size'
                                                                  },
          'innodb_change_buffer_max_size' => {
                                               'Value' => '25',
                                               'Variable_name' => 'innodb_change_buffer_max_size'
                                             },
          'innodb_sync_array_size' => {
                                        'Value' => '1',
                                        'Variable_name' => 'innodb_sync_array_size'
                                      },
          'innodb_ft_result_cache_limit' => {
                                              'Value' => '2000000000',
                                              'Variable_name' => 'innodb_ft_result_cache_limit'
                                            },
          'disabled_storage_engines' => {
                                          'Value' => '',
                                          'Variable_name' => 'disabled_storage_engines'
                                        },
          'disconnect_on_expired_password' => {
                                                'Value' => 'ON',
                                                'Variable_name' => 'disconnect_on_expired_password'
                                              },
          'performance_schema_max_mutex_instances' => {
                                                        'Value' => '-1',
                                                        'Variable_name' => 'performance_schema_max_mutex_instances'
                                                      },
          'log_slow_extra' => {
                                'Value' => 'ON',
                                'Variable_name' => 'log_slow_extra'
                              },
          'session_track_schema' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'session_track_schema'
                                    },
          'innodb_buffer_pool_size' => {
                                         'Value' => '134217728',
                                         'Variable_name' => 'innodb_buffer_pool_size'
                                       },
          'innodb_disable_sort_file_cache' => {
                                                'Value' => 'OFF',
                                                'Variable_name' => 'innodb_disable_sort_file_cache'
                                              },
          'log_timestamps' => {
                                'Value' => 'SYSTEM',
                                'Variable_name' => 'log_timestamps'
                              },
          'innodb_rollback_segments' => {
                                          'Value' => '128',
                                          'Variable_name' => 'innodb_rollback_segments'
                                        },
          'transaction_isolation' => {
                                       'Value' => 'REPEATABLE-READ',
                                       'Variable_name' => 'transaction_isolation'
                                     },
          'preload_buffer_size' => {
                                     'Value' => '32768',
                                     'Variable_name' => 'preload_buffer_size'
                                   },
          'read_buffer_size' => {
                                  'Value' => '131072',
                                  'Variable_name' => 'read_buffer_size'
                                },
          'slave_preserve_commit_order' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'slave_preserve_commit_order'
                                           },
          'mysql_native_password_proxy_users' => {
                                                   'Value' => 'OFF',
                                                   'Variable_name' => 'mysql_native_password_proxy_users'
                                                 },
          'query_alloc_block_size' => {
                                        'Value' => '8192',
                                        'Variable_name' => 'query_alloc_block_size'
                                      },
          'port' => {
                      'Value' => '64080',
                      'Variable_name' => 'port'
                    },
          'log_slave_updates' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'log_slave_updates'
                                 },
          'socket' => {
                        'Value' => '/usr/mysql/8.0.22/data/mysql.sock',
                        'Variable_name' => 'socket'
                      },
          'show_create_table_skip_secondary_engine' => {
                                                         'Value' => 'OFF',
                                                         'Variable_name' => 'show_create_table_skip_secondary_engine'
                                                       },
          'div_precision_increment' => {
                                         'Value' => '4',
                                         'Variable_name' => 'div_precision_increment'
                                       },
          'innodb_strict_mode' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_strict_mode'
                                  },
          'innodb_log_write_ahead_size' => {
                                             'Value' => '8192',
                                             'Variable_name' => 'innodb_log_write_ahead_size'
                                           },
          'optimizer_trace_max_mem_size' => {
                                              'Value' => '1048576',
                                              'Variable_name' => 'optimizer_trace_max_mem_size'
                                            },
          'collation_server' => {
                                  'Value' => 'utf8mb4_0900_ai_ci',
                                  'Variable_name' => 'collation_server'
                                },
          'relay_log_space_limit' => {
                                       'Value' => '0',
                                       'Variable_name' => 'relay_log_space_limit'
                                     },
          'ft_min_word_len' => {
                                 'Value' => '4',
                                 'Variable_name' => 'ft_min_word_len'
                               },
          'thread_cache_size' => {
                                   'Value' => '9',
                                   'Variable_name' => 'thread_cache_size'
                                 },
          'log_bin_basename' => {
                                  'Value' => '/usr/mysql/8.0.22/data/bin',
                                  'Variable_name' => 'log_bin_basename'
                                },
          'table_definition_cache' => {
                                        'Value' => '615',
                                        'Variable_name' => 'table_definition_cache'
                                      },
          'performance_schema_max_cond_classes' => {
                                                     'Value' => '100',
                                                     'Variable_name' => 'performance_schema_max_cond_classes'
                                                   },
          'profiling_history_size' => {
                                        'Value' => '15',
                                        'Variable_name' => 'profiling_history_size'
                                      },
          'log_bin_index' => {
                               'Value' => '/usr/mysql/8.0.22/data/bin.index',
                               'Variable_name' => 'log_bin_index'
                             },
          'slave_sql_verify_checksum' => {
                                           'Value' => 'ON',
                                           'Variable_name' => 'slave_sql_verify_checksum'
                                         },
          'have_openssl' => {
                              'Value' => 'YES',
                              'Variable_name' => 'have_openssl'
                            },
          'slave_parallel_type' => {
                                     'Value' => 'DATABASE',
                                     'Variable_name' => 'slave_parallel_type'
                                   },
          'innodb_api_trx_level' => {
                                      'Value' => '0',
                                      'Variable_name' => 'innodb_api_trx_level'
                                    },
          'max_allowed_packet' => {
                                    'Value' => '67108864',
                                    'Variable_name' => 'max_allowed_packet'
                                  },
          'performance_schema_max_memory_classes' => {
                                                       'Value' => '450',
                                                       'Variable_name' => 'performance_schema_max_memory_classes'
                                                     },
          'thread_stack' => {
                              'Value' => '286720',
                              'Variable_name' => 'thread_stack'
                            },
          'character_sets_dir' => {
                                    'Value' => '/usr/mysql/8.0.22/share/charsets/',
                                    'Variable_name' => 'character_sets_dir'
                                  },
          'max_insert_delayed_threads' => {
                                            'Value' => '20',
                                            'Variable_name' => 'max_insert_delayed_threads'
                                          },
          'innodb_flushing_avg_loops' => {
                                           'Value' => '30',
                                           'Variable_name' => 'innodb_flushing_avg_loops'
                                         },
          'pid_file' => {
                          'Value' => '/usr/mysql/8.0.22/data/mysql.pid',
                          'Variable_name' => 'pid_file'
                        },
          'ssl_key' => {
                         'Value' => 'server-key.pem',
                         'Variable_name' => 'ssl_key'
                       },
          'sql_big_selects' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'sql_big_selects'
                               },
          'admin_tls_ciphersuites' => {
                                        'Value' => '',
                                        'Variable_name' => 'admin_tls_ciphersuites'
                                      },
          'last_insert_id' => {
                                'Value' => '0',
                                'Variable_name' => 'last_insert_id'
                              },
          'default_table_encryption' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'default_table_encryption'
                                        },
          'internal_tmp_mem_storage_engine' => {
                                                 'Value' => 'TempTable',
                                                 'Variable_name' => 'internal_tmp_mem_storage_engine'
                                               },
          'net_retry_count' => {
                                 'Value' => '10',
                                 'Variable_name' => 'net_retry_count'
                               },
          'innodb_doublewrite_files' => {
                                          'Value' => '2',
                                          'Variable_name' => 'innodb_doublewrite_files'
                                        },
          'offline_mode' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'offline_mode'
                            },
          'old' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'old'
                   },
          'auto_increment_increment' => {
                                          'Value' => '1',
                                          'Variable_name' => 'auto_increment_increment'
                                        },
          'innodb_monitor_reset_all' => {
                                          'Value' => '',
                                          'Variable_name' => 'innodb_monitor_reset_all'
                                        },
          'innodb_max_dirty_pages_pct' => {
                                            'Value' => '90.000000',
                                            'Variable_name' => 'innodb_max_dirty_pages_pct'
                                          },
          'have_ssl' => {
                          'Value' => 'YES',
                          'Variable_name' => 'have_ssl'
                        },
          'version_compile_machine' => {
                                         'Value' => 'x86_64',
                                         'Variable_name' => 'version_compile_machine'
                                       },
          'innodb_fill_factor' => {
                                    'Value' => '100',
                                    'Variable_name' => 'innodb_fill_factor'
                                  },
          'innodb_log_spin_cpu_abs_lwm' => {
                                             'Value' => '80',
                                             'Variable_name' => 'innodb_log_spin_cpu_abs_lwm'
                                           },
          'parser_max_mem_size' => {
                                     'Value' => '18446744073709551615',
                                     'Variable_name' => 'parser_max_mem_size'
                                   },
          'log_bin' => {
                         'Value' => 'ON',
                         'Variable_name' => 'log_bin'
                       },
          'innodb_purge_rseg_truncate_frequency' => {
                                                      'Value' => '128',
                                                      'Variable_name' => 'innodb_purge_rseg_truncate_frequency'
                                                    },
          'version' => {
                         'Value' => '8.0.22',
                         'Variable_name' => 'version'
                       },
          'innodb_adaptive_hash_index_parts' => {
                                                  'Value' => '8',
                                                  'Variable_name' => 'innodb_adaptive_hash_index_parts'
                                                },
          'innodb_file_per_table' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_file_per_table'
                                     },
          'read_rnd_buffer_size' => {
                                      'Value' => '262144',
                                      'Variable_name' => 'read_rnd_buffer_size'
                                    },
          'transaction_write_set_extraction' => {
                                                  'Value' => 'XXHASH64',
                                                  'Variable_name' => 'transaction_write_set_extraction'
                                                },
          'binlog_row_image' => {
                                  'Value' => 'FULL',
                                  'Variable_name' => 'binlog_row_image'
                                },
          'have_statement_timeout' => {
                                        'Value' => 'YES',
                                        'Variable_name' => 'have_statement_timeout'
                                      },
          'error_count' => {
                             'Value' => '0',
                             'Variable_name' => 'error_count'
                           },
          'rand_seed2' => {
                            'Value' => '0',
                            'Variable_name' => 'rand_seed2'
                          },
          'innodb_max_dirty_pages_pct_lwm' => {
                                                'Value' => '10.000000',
                                                'Variable_name' => 'innodb_max_dirty_pages_pct_lwm'
                                              },
          'max_sp_recursion_depth' => {
                                        'Value' => '0',
                                        'Variable_name' => 'max_sp_recursion_depth'
                                      },
          'innodb_log_group_home_dir' => {
                                           'Value' => './',
                                           'Variable_name' => 'innodb_log_group_home_dir'
                                         },
          'show_old_temporals' => {
                                    'Value' => 'OFF',
                                    'Variable_name' => 'show_old_temporals'
                                  },
          'use_secondary_engine' => {
                                      'Value' => 'ON',
                                      'Variable_name' => 'use_secondary_engine'
                                    },
          'optimizer_trace_offset' => {
                                        'Value' => '-1',
                                        'Variable_name' => 'optimizer_trace_offset'
                                      },
          'admin_port' => {
                            'Value' => '33062',
                            'Variable_name' => 'admin_port'
                          },
          'information_schema_stats_expiry' => {
                                                 'Value' => '86400',
                                                 'Variable_name' => 'information_schema_stats_expiry'
                                               },
          'innodb_sort_buffer_size' => {
                                         'Value' => '1048576',
                                         'Variable_name' => 'innodb_sort_buffer_size'
                                       },
          'innodb_thread_concurrency' => {
                                           'Value' => '0',
                                           'Variable_name' => 'innodb_thread_concurrency'
                                         },
          'performance_schema_setup_objects_size' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_setup_objects_size'
                                                     },
          'relay_log_purge' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'relay_log_purge'
                               },
          'temptable_use_mmap' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'temptable_use_mmap'
                                  },
          'binlog_error_action' => {
                                     'Value' => 'ABORT_SERVER',
                                     'Variable_name' => 'binlog_error_action'
                                   },
          'sql_log_off' => {
                             'Value' => 'OFF',
                             'Variable_name' => 'sql_log_off'
                           },
          'server_id' => {
                           'Value' => '1080',
                           'Variable_name' => 'server_id'
                         },
          'sql_require_primary_key' => {
                                         'Value' => 'OFF',
                                         'Variable_name' => 'sql_require_primary_key'
                                       },
          'open_files_limit' => {
                                  'Value' => '1024',
                                  'Variable_name' => 'open_files_limit'
                                },
          'innodb_buffer_pool_in_core_file' => {
                                                 'Value' => 'ON',
                                                 'Variable_name' => 'innodb_buffer_pool_in_core_file'
                                               },
          'innodb_redo_log_archive_dirs' => {
                                              'Value' => '',
                                              'Variable_name' => 'innodb_redo_log_archive_dirs'
                                            },
          'enforce_gtid_consistency' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'enforce_gtid_consistency'
                                        },
          'innodb_buffer_pool_dump_at_shutdown' => {
                                                     'Value' => 'OFF',
                                                     'Variable_name' => 'innodb_buffer_pool_dump_at_shutdown'
                                                   },
          'innodb_table_locks' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'innodb_table_locks'
                                  },
          'key_cache_block_size' => {
                                      'Value' => '1024',
                                      'Variable_name' => 'key_cache_block_size'
                                    },
          'password_require_current' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'password_require_current'
                                        },
          'performance_schema_max_table_handles' => {
                                                      'Value' => '-1',
                                                      'Variable_name' => 'performance_schema_max_table_handles'
                                                    },
          'tablespace_definition_cache' => {
                                             'Value' => '256',
                                             'Variable_name' => 'tablespace_definition_cache'
                                           },
          'histogram_generation_max_mem_size' => {
                                                   'Value' => '20000000',
                                                   'Variable_name' => 'histogram_generation_max_mem_size'
                                                 },
          'session_track_transaction_info' => {
                                                'Value' => 'OFF',
                                                'Variable_name' => 'session_track_transaction_info'
                                              },
          'have_rtree_keys' => {
                                 'Value' => 'YES',
                                 'Variable_name' => 'have_rtree_keys'
                               },
          'stored_program_definition_cache' => {
                                                 'Value' => '256',
                                                 'Variable_name' => 'stored_program_definition_cache'
                                               },
          'innodb_temp_tablespaces_dir' => {
                                             'Value' => './#innodb_temp/',
                                             'Variable_name' => 'innodb_temp_tablespaces_dir'
                                           },
          'optimizer_search_depth' => {
                                        'Value' => '62',
                                        'Variable_name' => 'optimizer_search_depth'
                                      },
          'clone_autotune_concurrency' => {
                                            'Value' => 'ON',
                                            'Variable_name' => 'clone_autotune_concurrency'
                                          },
          'innodb_flush_log_at_timeout' => {
                                             'Value' => '1',
                                             'Variable_name' => 'innodb_flush_log_at_timeout'
                                           },
          'thread_handling' => {
                                 'Value' => 'one-thread-per-connection',
                                 'Variable_name' => 'thread_handling'
                               },
          'have_symlink' => {
                              'Value' => 'DISABLED',
                              'Variable_name' => 'have_symlink'
                            },
          'sql_quote_show_create' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'sql_quote_show_create'
                                     },
          'sha256_password_auto_generate_rsa_keys' => {
                                                        'Value' => 'ON',
                                                        'Variable_name' => 'sha256_password_auto_generate_rsa_keys'
                                                      },
          'innodb_undo_log_encrypt' => {
                                         'Value' => 'OFF',
                                         'Variable_name' => 'innodb_undo_log_encrypt'
                                       },
          'max_error_count' => {
                                 'Value' => '1024',
                                 'Variable_name' => 'max_error_count'
                               },
          'performance_schema_max_file_handles' => {
                                                     'Value' => '32768',
                                                     'Variable_name' => 'performance_schema_max_file_handles'
                                                   },
          'net_buffer_length' => {
                                   'Value' => '16384',
                                   'Variable_name' => 'net_buffer_length'
                                 },
          'automatic_sp_privileges' => {
                                         'Value' => 'ON',
                                         'Variable_name' => 'automatic_sp_privileges'
                                       },
          'innodb_print_all_deadlocks' => {
                                            'Value' => 'ON',
                                            'Variable_name' => 'innodb_print_all_deadlocks'
                                          },
          'hostname' => {
                          'Value' => '150-95-141-50',
                          'Variable_name' => 'hostname'
                        },
          'innodb_ft_server_stopword_table' => {
                                                 'Value' => '',
                                                 'Variable_name' => 'innodb_ft_server_stopword_table'
                                               },
          'ssl_crlpath' => {
                             'Value' => '',
                             'Variable_name' => 'ssl_crlpath'
                           },
          'external_user' => {
                               'Value' => '',
                               'Variable_name' => 'external_user'
                             },
          'lc_messages_dir' => {
                                 'Value' => '/usr/mysql/8.0.22/share/',
                                 'Variable_name' => 'lc_messages_dir'
                               },
          'binlog_transaction_dependency_tracking' => {
                                                        'Value' => 'COMMIT_ORDER',
                                                        'Variable_name' => 'binlog_transaction_dependency_tracking'
                                                      },
          'group_concat_max_len' => {
                                      'Value' => '1024',
                                      'Variable_name' => 'group_concat_max_len'
                                    },
          'relay_log_info_file' => {
                                     'Value' => 'relay-log.info',
                                     'Variable_name' => 'relay_log_info_file'
                                   },
          'connect_timeout' => {
                                 'Value' => '10',
                                 'Variable_name' => 'connect_timeout'
                               },
          'innodb_page_size' => {
                                  'Value' => '16384',
                                  'Variable_name' => 'innodb_page_size'
                                },
          'performance_schema_events_stages_history_size' => {
                                                               'Value' => '10',
                                                               'Variable_name' => 'performance_schema_events_stages_history_size'
                                                             },
          'regexp_stack_limit' => {
                                    'Value' => '8000000',
                                    'Variable_name' => 'regexp_stack_limit'
                                  },
          'local_infile' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'local_infile'
                            },
          'innodb_online_alter_log_max_size' => {
                                                  'Value' => '134217728',
                                                  'Variable_name' => 'innodb_online_alter_log_max_size'
                                                },
          'binlog_rotate_encryption_master_key_at_startup' => {
                                                                'Value' => 'OFF',
                                                                'Variable_name' => 'binlog_rotate_encryption_master_key_at_startup'
                                                              },
          'innodb_force_recovery' => {
                                       'Value' => '0',
                                       'Variable_name' => 'innodb_force_recovery'
                                     },
          'expire_logs_days' => {
                                  'Value' => '0',
                                  'Variable_name' => 'expire_logs_days'
                                },
          'innodb_buffer_pool_load_abort' => {
                                               'Value' => 'OFF',
                                               'Variable_name' => 'innodb_buffer_pool_load_abort'
                                             },
          'innodb_max_purge_lag' => {
                                      'Value' => '0',
                                      'Variable_name' => 'innodb_max_purge_lag'
                                    },
          'slave_compressed_protocol' => {
                                           'Value' => 'OFF',
                                           'Variable_name' => 'slave_compressed_protocol'
                                         },
          'ssl_crl' => {
                         'Value' => '',
                         'Variable_name' => 'ssl_crl'
                       },
          'innodb_doublewrite_dir' => {
                                        'Value' => '',
                                        'Variable_name' => 'innodb_doublewrite_dir'
                                      },
          'innodb_log_files_in_group' => {
                                           'Value' => '2',
                                           'Variable_name' => 'innodb_log_files_in_group'
                                         },
          'lower_case_file_system' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'lower_case_file_system'
                                      },
          'transaction_alloc_block_size' => {
                                              'Value' => '8192',
                                              'Variable_name' => 'transaction_alloc_block_size'
                                            },
          'innodb_spin_wait_pause_multiplier' => {
                                                   'Value' => '50',
                                                   'Variable_name' => 'innodb_spin_wait_pause_multiplier'
                                                 },
          'clone_max_data_bandwidth' => {
                                          'Value' => '0',
                                          'Variable_name' => 'clone_max_data_bandwidth'
                                        },
          'gtid_next' => {
                           'Value' => 'AUTOMATIC',
                           'Variable_name' => 'gtid_next'
                         },
          'binlog_expire_logs_seconds' => {
                                            'Value' => '705600',
                                            'Variable_name' => 'binlog_expire_logs_seconds'
                                          },
          'innodb_buffer_pool_dump_now' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_buffer_pool_dump_now'
                                           },
          'performance_schema_events_statements_history_size' => {
                                                                   'Value' => '10',
                                                                   'Variable_name' => 'performance_schema_events_statements_history_size'
                                                                 },
          'innodb_replication_delay' => {
                                          'Value' => '0',
                                          'Variable_name' => 'innodb_replication_delay'
                                        },
          'read_only' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'read_only'
                         },
          'new' => {
                     'Value' => 'OFF',
                     'Variable_name' => 'new'
                   },
          'original_server_version' => {
                                         'Value' => '999999',
                                         'Variable_name' => 'original_server_version'
                                       },
          'select_into_disk_sync' => {
                                       'Value' => 'OFF',
                                       'Variable_name' => 'select_into_disk_sync'
                                     },
          'character_set_results' => {
                                       'Value' => 'utf8',
                                       'Variable_name' => 'character_set_results'
                                     },
          'protocol_compression_algorithms' => {
                                                 'Value' => 'zlib,zstd,uncompressed',
                                                 'Variable_name' => 'protocol_compression_algorithms'
                                               },
          'slave_skip_errors' => {
                                   'Value' => 'OFF',
                                   'Variable_name' => 'slave_skip_errors'
                                 },
          'slow_launch_time' => {
                                  'Value' => '2',
                                  'Variable_name' => 'slow_launch_time'
                                },
          'foreign_key_checks' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'foreign_key_checks'
                                  },
          'keyring_operations' => {
                                    'Value' => 'ON',
                                    'Variable_name' => 'keyring_operations'
                                  },
          'max_points_in_geometry' => {
                                        'Value' => '65536',
                                        'Variable_name' => 'max_points_in_geometry'
                                      },
          'innodb_spin_wait_delay' => {
                                        'Value' => '6',
                                        'Variable_name' => 'innodb_spin_wait_delay'
                                      },
          'version_comment' => {
                                 'Value' => 'Source distribution',
                                 'Variable_name' => 'version_comment'
                               },
          'max_delayed_threads' => {
                                     'Value' => '20',
                                     'Variable_name' => 'max_delayed_threads'
                                   },
          'max_prepared_stmt_count' => {
                                         'Value' => '16382',
                                         'Variable_name' => 'max_prepared_stmt_count'
                                       },
          'sql_warnings' => {
                              'Value' => 'OFF',
                              'Variable_name' => 'sql_warnings'
                            },
          'innodb_buffer_pool_load_at_startup' => {
                                                    'Value' => 'OFF',
                                                    'Variable_name' => 'innodb_buffer_pool_load_at_startup'
                                                  },
          'innodb_doublewrite_batch_size' => {
                                               'Value' => '0',
                                               'Variable_name' => 'innodb_doublewrite_batch_size'
                                             },
          'init_slave' => {
                            'Value' => '',
                            'Variable_name' => 'init_slave'
                          },
          'innodb_buffer_pool_instances' => {
                                              'Value' => '1',
                                              'Variable_name' => 'innodb_buffer_pool_instances'
                                            },
          'rand_seed1' => {
                            'Value' => '0',
                            'Variable_name' => 'rand_seed1'
                          },
          'innodb_log_writer_threads' => {
                                           'Value' => 'ON',
                                           'Variable_name' => 'innodb_log_writer_threads'
                                         },
          'max_binlog_size' => {
                                 'Value' => '1073741824',
                                 'Variable_name' => 'max_binlog_size'
                               },
          'delayed_queue_size' => {
                                    'Value' => '1000',
                                    'Variable_name' => 'delayed_queue_size'
                                  },
          'innodb_api_enable_binlog' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_api_enable_binlog'
                                        },
          'log_error' => {
                           'Value' => './error.log',
                           'Variable_name' => 'log_error'
                         },
          'myisam_mmap_size' => {
                                  'Value' => '18446744073709551615',
                                  'Variable_name' => 'myisam_mmap_size'
                                },
          'slave_rows_search_algorithms' => {
                                              'Value' => 'INDEX_SCAN,HASH_SCAN',
                                              'Variable_name' => 'slave_rows_search_algorithms'
                                            },
          'innodb_monitor_enable' => {
                                       'Value' => '',
                                       'Variable_name' => 'innodb_monitor_enable'
                                     },
          'transaction_prealloc_size' => {
                                           'Value' => '4096',
                                           'Variable_name' => 'transaction_prealloc_size'
                                         },
          'large_page_size' => {
                                 'Value' => '0',
                                 'Variable_name' => 'large_page_size'
                               },
          'gtid_purged' => {
                             'Value' => '04829ca1-136d-11eb-97d8-0201965f8d32:1-3236996',
                             'Variable_name' => 'gtid_purged'
                           },
          'binlog_transaction_compression_level_zstd' => {
                                                           'Value' => '3',
                                                           'Variable_name' => 'binlog_transaction_compression_level_zstd'
                                                         },
          'table_encryption_privilege_check' => {
                                                  'Value' => 'OFF',
                                                  'Variable_name' => 'table_encryption_privilege_check'
                                                },
          'innodb_old_blocks_pct' => {
                                       'Value' => '37',
                                       'Variable_name' => 'innodb_old_blocks_pct'
                                     },
          'master_verify_checksum' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'master_verify_checksum'
                                      },
          'log_error_suppression_list' => {
                                            'Value' => '',
                                            'Variable_name' => 'log_error_suppression_list'
                                          },
          'performance_schema_show_processlist' => {
                                                     'Value' => 'OFF',
                                                     'Variable_name' => 'performance_schema_show_processlist'
                                                   },
          'innodb_cmp_per_index_enabled' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'innodb_cmp_per_index_enabled'
                                            },
          'innodb_api_bk_commit_interval' => {
                                               'Value' => '5',
                                               'Variable_name' => 'innodb_api_bk_commit_interval'
                                             },
          'sync_relay_log_info' => {
                                     'Value' => '10000',
                                     'Variable_name' => 'sync_relay_log_info'
                                   },
          'innodb_adaptive_max_sleep_delay' => {
                                                 'Value' => '150000',
                                                 'Variable_name' => 'innodb_adaptive_max_sleep_delay'
                                               },
          'core_file' => {
                           'Value' => 'ON',
                           'Variable_name' => 'core_file'
                         },
          'log_throttle_queries_not_using_indexes' => {
                                                        'Value' => '0',
                                                        'Variable_name' => 'log_throttle_queries_not_using_indexes'
                                                      },
          'sha256_password_public_key_path' => {
                                                 'Value' => 'public_key.pem',
                                                 'Variable_name' => 'sha256_password_public_key_path'
                                               },
          'innodb_stats_persistent_sample_pages' => {
                                                      'Value' => '20',
                                                      'Variable_name' => 'innodb_stats_persistent_sample_pages'
                                                    },
          'myisam_stats_method' => {
                                     'Value' => 'nulls_unequal',
                                     'Variable_name' => 'myisam_stats_method'
                                   },
          'require_secure_transport' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'require_secure_transport'
                                        },
          'innodb_rollback_on_timeout' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_rollback_on_timeout'
                                          },
          'tmpdir' => {
                        'Value' => '/tmp',
                        'Variable_name' => 'tmpdir'
                      },
          'innodb_status_output_locks' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_status_output_locks'
                                          },
          'performance_schema_max_rwlock_classes' => {
                                                       'Value' => '60',
                                                       'Variable_name' => 'performance_schema_max_rwlock_classes'
                                                     },
          'innodb_ft_min_token_size' => {
                                          'Value' => '1',
                                          'Variable_name' => 'innodb_ft_min_token_size'
                                        },
          'myisam_recover_options' => {
                                        'Value' => 'OFF',
                                        'Variable_name' => 'myisam_recover_options'
                                      },
          'have_query_cache' => {
                                  'Value' => 'NO',
                                  'Variable_name' => 'have_query_cache'
                                },
          'rpl_stop_slave_timeout' => {
                                        'Value' => '31536000',
                                        'Variable_name' => 'rpl_stop_slave_timeout'
                                      },
          'innodb_numa_interleave' => {
                                        'Value' => 'ON',
                                        'Variable_name' => 'innodb_numa_interleave'
                                      },
          'performance_schema_accounts_size' => {
                                                  'Value' => '-1',
                                                  'Variable_name' => 'performance_schema_accounts_size'
                                                },
          'show_create_table_verbosity' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'show_create_table_verbosity'
                                           },
          'slave_allow_batching' => {
                                      'Value' => 'OFF',
                                      'Variable_name' => 'slave_allow_batching'
                                    },
          'performance_schema_digests_size' => {
                                                 'Value' => '5000',
                                                 'Variable_name' => 'performance_schema_digests_size'
                                               },
          'log_error_services' => {
                                    'Value' => 'log_filter_internal; log_sink_internal',
                                    'Variable_name' => 'log_error_services'
                                  },
          'gtid_executed_compression_period' => {
                                                  'Value' => '1000',
                                                  'Variable_name' => 'gtid_executed_compression_period'
                                                },
          'binlog_stmt_cache_size' => {
                                        'Value' => '32768',
                                        'Variable_name' => 'binlog_stmt_cache_size'
                                      },
          'delayed_insert_timeout' => {
                                        'Value' => '300',
                                        'Variable_name' => 'delayed_insert_timeout'
                                      },
          'default_storage_engine' => {
                                        'Value' => 'InnoDB',
                                        'Variable_name' => 'default_storage_engine'
                                      },
          'innodb_stats_on_metadata' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_stats_on_metadata'
                                        },
          'range_optimizer_max_mem_size' => {
                                              'Value' => '8388608',
                                              'Variable_name' => 'range_optimizer_max_mem_size'
                                            },
          'old_alter_table' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'old_alter_table'
                               },
          'innodb_max_purge_lag_delay' => {
                                            'Value' => '0',
                                            'Variable_name' => 'innodb_max_purge_lag_delay'
                                          },
          'innodb_parallel_read_threads' => {
                                              'Value' => '4',
                                              'Variable_name' => 'innodb_parallel_read_threads'
                                            },
          'caching_sha2_password_auto_generate_rsa_keys' => {
                                                              'Value' => 'ON',
                                                              'Variable_name' => 'caching_sha2_password_auto_generate_rsa_keys'
                                                            },
          'query_prealloc_size' => {
                                     'Value' => '8192',
                                     'Variable_name' => 'query_prealloc_size'
                                   },
          'ssl_capath' => {
                            'Value' => '',
                            'Variable_name' => 'ssl_capath'
                          },
          'performance_schema_max_socket_classes' => {
                                                       'Value' => '10',
                                                       'Variable_name' => 'performance_schema_max_socket_classes'
                                                     },
          'innodb_flush_neighbors' => {
                                        'Value' => '0',
                                        'Variable_name' => 'innodb_flush_neighbors'
                                      },
          'event_scheduler' => {
                                 'Value' => 'ON',
                                 'Variable_name' => 'event_scheduler'
                               },
          'default_collation_for_utf8mb4' => {
                                               'Value' => 'utf8mb4_0900_ai_ci',
                                               'Variable_name' => 'default_collation_for_utf8mb4'
                                             },
          'server_uuid' => {
                             'Value' => '04829ca1-136d-11eb-97d8-0201965f8d32',
                             'Variable_name' => 'server_uuid'
                           },
          'big_tables' => {
                            'Value' => 'OFF',
                            'Variable_name' => 'big_tables'
                          },
          'slave_transaction_retries' => {
                                           'Value' => '10',
                                           'Variable_name' => 'slave_transaction_retries'
                                         },
          'binlog_format' => {
                               'Value' => 'ROW',
                               'Variable_name' => 'binlog_format'
                             },
          'innodb_validate_tablespace_paths' => {
                                                  'Value' => 'ON',
                                                  'Variable_name' => 'innodb_validate_tablespace_paths'
                                                },
          'session_track_gtids' => {
                                     'Value' => 'OFF',
                                     'Variable_name' => 'session_track_gtids'
                                   },
          'innodb_io_capacity' => {
                                    'Value' => '200',
                                    'Variable_name' => 'innodb_io_capacity'
                                  },
          'innodb_ft_max_token_size' => {
                                          'Value' => '84',
                                          'Variable_name' => 'innodb_ft_max_token_size'
                                        },
          'delayed_insert_limit' => {
                                      'Value' => '100',
                                      'Variable_name' => 'delayed_insert_limit'
                                    },
          'max_seeks_for_key' => {
                                   'Value' => '18446744073709551615',
                                   'Variable_name' => 'max_seeks_for_key'
                                 },
          'session_track_system_variables' => {
                                                'Value' => 'time_zone,autocommit,character_set_client,character_set_results,character_set_connection',
                                                'Variable_name' => 'session_track_system_variables'
                                              },
          'innodb_thread_sleep_delay' => {
                                           'Value' => '10000',
                                           'Variable_name' => 'innodb_thread_sleep_delay'
                                         },
          'slow_query_log' => {
                                'Value' => 'ON',
                                'Variable_name' => 'slow_query_log'
                              },
          'schema_definition_cache' => {
                                         'Value' => '256',
                                         'Variable_name' => 'schema_definition_cache'
                                       },
          'join_buffer_size' => {
                                  'Value' => '262144',
                                  'Variable_name' => 'join_buffer_size'
                                },
          'sql_log_bin' => {
                             'Value' => 'ON',
                             'Variable_name' => 'sql_log_bin'
                           },
          'tls_ciphersuites' => {
                                  'Value' => '',
                                  'Variable_name' => 'tls_ciphersuites'
                                },
          'innodb_ft_sort_pll_degree' => {
                                           'Value' => '2',
                                           'Variable_name' => 'innodb_ft_sort_pll_degree'
                                         },
          'explicit_defaults_for_timestamp' => {
                                                 'Value' => 'ON',
                                                 'Variable_name' => 'explicit_defaults_for_timestamp'
                                               },
          'innodb_undo_directory' => {
                                       'Value' => './',
                                       'Variable_name' => 'innodb_undo_directory'
                                     },
          'key_buffer_size' => {
                                 'Value' => '8388608',
                                 'Variable_name' => 'key_buffer_size'
                               },
          'innodb_force_load_corrupted' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'innodb_force_load_corrupted'
                                           },
          'temptable_max_ram' => {
                                   'Value' => '1073741824',
                                   'Variable_name' => 'temptable_max_ram'
                                 },
          'flush_time' => {
                            'Value' => '0',
                            'Variable_name' => 'flush_time'
                          },
          'rbr_exec_mode' => {
                               'Value' => 'STRICT',
                               'Variable_name' => 'rbr_exec_mode'
                             },
          'innodb_monitor_disable' => {
                                        'Value' => '',
                                        'Variable_name' => 'innodb_monitor_disable'
                                      },
          'net_write_timeout' => {
                                   'Value' => '60',
                                   'Variable_name' => 'net_write_timeout'
                                 },
          'admin_ssl_crl' => {
                               'Value' => '',
                               'Variable_name' => 'admin_ssl_crl'
                             },
          'max_heap_table_size' => {
                                     'Value' => '16777216',
                                     'Variable_name' => 'max_heap_table_size'
                                   },
          'sql_select_limit' => {
                                  'Value' => '18446744073709551615',
                                  'Variable_name' => 'sql_select_limit'
                                },
          'ft_query_expansion_limit' => {
                                          'Value' => '20',
                                          'Variable_name' => 'ft_query_expansion_limit'
                                        },
          'max_connect_errors' => {
                                    'Value' => '100',
                                    'Variable_name' => 'max_connect_errors'
                                  },
          'innodb_extend_and_initialize' => {
                                              'Value' => 'ON',
                                              'Variable_name' => 'innodb_extend_and_initialize'
                                            },
          'performance_schema_max_file_instances' => {
                                                       'Value' => '-1',
                                                       'Variable_name' => 'performance_schema_max_file_instances'
                                                     },
          'have_profiling' => {
                                'Value' => 'YES',
                                'Variable_name' => 'have_profiling'
                              },
          'innodb_api_disable_rowlock' => {
                                            'Value' => 'OFF',
                                            'Variable_name' => 'innodb_api_disable_rowlock'
                                          },
          'performance_schema_max_sql_text_length' => {
                                                        'Value' => '1024',
                                                        'Variable_name' => 'performance_schema_max_sql_text_length'
                                                      },
          'relay_log' => {
                           'Value' => 'relay',
                           'Variable_name' => 'relay_log'
                         },
          'performance_schema_events_waits_history_size' => {
                                                              'Value' => '10',
                                                              'Variable_name' => 'performance_schema_events_waits_history_size'
                                                            },
          'relay_log_index' => {
                                 'Value' => '/usr/mysql/8.0.22/data/relay.index',
                                 'Variable_name' => 'relay_log_index'
                               },
          'innodb_undo_log_truncate' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_undo_log_truncate'
                                        },
          'flush' => {
                       'Value' => 'OFF',
                       'Variable_name' => 'flush'
                     },
          'locked_in_memory' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'locked_in_memory'
                                },
          'binlog_cache_size' => {
                                   'Value' => '32768',
                                   'Variable_name' => 'binlog_cache_size'
                                 },
          'innodb_use_native_aio' => {
                                       'Value' => 'ON',
                                       'Variable_name' => 'innodb_use_native_aio'
                                     },
          'innodb_ft_aux_table' => {
                                     'Value' => '',
                                     'Variable_name' => 'innodb_ft_aux_table'
                                   },
          'performance_schema_max_program_instances' => {
                                                          'Value' => '-1',
                                                          'Variable_name' => 'performance_schema_max_program_instances'
                                                        },
          'innodb_sync_spin_loops' => {
                                        'Value' => '30',
                                        'Variable_name' => 'innodb_sync_spin_loops'
                                      },
          'performance_schema_events_transactions_history_long_size' => {
                                                                          'Value' => '1000',
                                                                          'Variable_name' => 'performance_schema_events_transactions_history_long_size'
                                                                        },
          'regexp_time_limit' => {
                                   'Value' => '32',
                                   'Variable_name' => 'regexp_time_limit'
                                 },
          'innodb_flush_sync' => {
                                   'Value' => 'ON',
                                   'Variable_name' => 'innodb_flush_sync'
                                 },
          'super_read_only' => {
                                 'Value' => 'OFF',
                                 'Variable_name' => 'super_read_only'
                               },
          'select_into_buffer_size' => {
                                         'Value' => '131072',
                                         'Variable_name' => 'select_into_buffer_size'
                                       },
          'innodb_change_buffering' => {
                                         'Value' => 'all',
                                         'Variable_name' => 'innodb_change_buffering'
                                       },
          'rpl_read_size' => {
                               'Value' => '8192',
                               'Variable_name' => 'rpl_read_size'
                             },
          'timestamp' => {
                           'Value' => '1610446384.223017',
                           'Variable_name' => 'timestamp'
                         },
          'innodb_max_undo_log_size' => {
                                          'Value' => '1073741824',
                                          'Variable_name' => 'innodb_max_undo_log_size'
                                        },
          'eq_range_index_dive_limit' => {
                                           'Value' => '200',
                                           'Variable_name' => 'eq_range_index_dive_limit'
                                         },
          'performance_schema_max_digest_length' => {
                                                      'Value' => '1024',
                                                      'Variable_name' => 'performance_schema_max_digest_length'
                                                    },
          'immediate_server_version' => {
                                          'Value' => '999999',
                                          'Variable_name' => 'immediate_server_version'
                                        },
          'log_bin_trust_function_creators' => {
                                                 'Value' => 'OFF',
                                                 'Variable_name' => 'log_bin_trust_function_creators'
                                               },
          'relay_log_basename' => {
                                    'Value' => '/usr/mysql/8.0.22/data/relay',
                                    'Variable_name' => 'relay_log_basename'
                                  },
          'activate_all_roles_on_login' => {
                                             'Value' => 'OFF',
                                             'Variable_name' => 'activate_all_roles_on_login'
                                           },
          'max_execution_time' => {
                                    'Value' => '0',
                                    'Variable_name' => 'max_execution_time'
                                  },
          'create_admin_listener_thread' => {
                                              'Value' => 'OFF',
                                              'Variable_name' => 'create_admin_listener_thread'
                                            },
          'clone_ssl_key' => {
                               'Value' => '',
                               'Variable_name' => 'clone_ssl_key'
                             },
          'slave_checkpoint_group' => {
                                        'Value' => '512',
                                        'Variable_name' => 'slave_checkpoint_group'
                                      },
          'slave_type_conversions' => {
                                        'Value' => '',
                                        'Variable_name' => 'slave_type_conversions'
                                      },
          'admin_address' => {
                               'Value' => '',
                               'Variable_name' => 'admin_address'
                             },
          'warning_count' => {
                               'Value' => '0',
                               'Variable_name' => 'warning_count'
                             },
          'myisam_sort_buffer_size' => {
                                         'Value' => '8388608',
                                         'Variable_name' => 'myisam_sort_buffer_size'
                                       },
          'innodb_temp_data_file_path' => {
                                            'Value' => 'ibtmp1:12M:autoextend',
                                            'Variable_name' => 'innodb_temp_data_file_path'
                                          },
          'innodb_read_only' => {
                                  'Value' => 'OFF',
                                  'Variable_name' => 'innodb_read_only'
                                },
          'init_file' => {
                           'Value' => '',
                           'Variable_name' => 'init_file'
                         },
          'default_week_format' => {
                                     'Value' => '0',
                                     'Variable_name' => 'default_week_format'
                                   },
          'innodb_commit_concurrency' => {
                                           'Value' => '0',
                                           'Variable_name' => 'innodb_commit_concurrency'
                                         },
          'optimizer_switch' => {
                                  'Value' => 'index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on,use_invisible_indexes=off,skip_scan=on,hash_join=on,subquery_to_derived=off,prefer_ordering_index=on,hypergraph_optimizer=off,derived_condition_pushdown=on',
                                  'Variable_name' => 'optimizer_switch'
                                },
          'resultset_metadata' => {
                                    'Value' => 'FULL',
                                    'Variable_name' => 'resultset_metadata'
                                  },
          'innodb_purge_batch_size' => {
                                         'Value' => '300',
                                         'Variable_name' => 'innodb_purge_batch_size'
                                       },
          'unique_checks' => {
                               'Value' => 'ON',
                               'Variable_name' => 'unique_checks'
                             },
          'innodb_lru_scan_depth' => {
                                       'Value' => '1024',
                                       'Variable_name' => 'innodb_lru_scan_depth'
                                     },
          'innodb_data_home_dir' => {
                                      'Value' => '',
                                      'Variable_name' => 'innodb_data_home_dir'
                                    },
          'character_set_connection' => {
                                          'Value' => 'utf8',
                                          'Variable_name' => 'character_set_connection'
                                        },
          'tls_version' => {
                             'Value' => 'TLSv1,TLSv1.1,TLSv1.2',
                             'Variable_name' => 'tls_version'
                           },
          'secure_file_priv' => {
                                  'Value' => '',
                                  'Variable_name' => 'secure_file_priv'
                                },
          'tmp_table_size' => {
                                'Value' => '16777216',
                                'Variable_name' => 'tmp_table_size'
                              },
          'clone_ssl_ca' => {
                              'Value' => '',
                              'Variable_name' => 'clone_ssl_ca'
                            },
          'innodb_redo_log_encrypt' => {
                                         'Value' => 'OFF',
                                         'Variable_name' => 'innodb_redo_log_encrypt'
                                       },
          'ssl_cipher' => {
                            'Value' => '',
                            'Variable_name' => 'ssl_cipher'
                          },
          'innodb_adaptive_flushing' => {
                                          'Value' => 'ON',
                                          'Variable_name' => 'innodb_adaptive_flushing'
                                        },
          'max_binlog_stmt_cache_size' => {
                                            'Value' => '18446744073709547520',
                                            'Variable_name' => 'max_binlog_stmt_cache_size'
                                          },
          'slave_parallel_workers' => {
                                        'Value' => '0',
                                        'Variable_name' => 'slave_parallel_workers'
                                      },
          'innodb_write_io_threads' => {
                                         'Value' => '4',
                                         'Variable_name' => 'innodb_write_io_threads'
                                       },
          'profiling' => {
                           'Value' => 'OFF',
                           'Variable_name' => 'profiling'
                         },
          'updatable_views_with_limit' => {
                                            'Value' => 'YES',
                                            'Variable_name' => 'updatable_views_with_limit'
                                          },
          'innodb_random_read_ahead' => {
                                          'Value' => 'OFF',
                                          'Variable_name' => 'innodb_random_read_ahead'
                                        },
          'innodb_autoextend_increment' => {
                                             'Value' => '64',
                                             'Variable_name' => 'innodb_autoextend_increment'
                                           },
          'select_into_disk_sync_delay' => {
                                             'Value' => '0',
                                             'Variable_name' => 'select_into_disk_sync_delay'
                                           },
          'general_log_file' => {
                                  'Value' => 'general.log',
                                  'Variable_name' => 'general_log_file'
                                },
          'max_sort_length' => {
                                 'Value' => '1024',
                                 'Variable_name' => 'max_sort_length'
                               },
          'optimizer_trace_limit' => {
                                       'Value' => '1',
                                       'Variable_name' => 'optimizer_trace_limit'
                                     },
          'max_length_for_sort_data' => {
                                          'Value' => '4096',
                                          'Variable_name' => 'max_length_for_sort_data'
                                        }
        };

$mysql80_another_uuid= clone($mysql80);
$mysql80_another_uuid->{server_uuid}->{Value}= "90d425fc-XXXX-11eb-913c-127591ee184b";

return 1;
