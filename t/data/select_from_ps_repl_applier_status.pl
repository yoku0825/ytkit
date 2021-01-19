package Ytkit::Test::SELECT_FROM_ps_repl_applier_status;

use Clone qw{ clone };

$applier_0s_recovery_0s = {
          'group_replication_recovery' => {
                                            'applying_transaction' => '',
                                            'applying_transaction_start_apply_timestamp' => '0000-00-00 00:00:00.000000',
                                            'service_state' => 'OFF',
                                            'channel_name' => 'group_replication_recovery',
                                            '_diff' => undef,
                                            'applying_transaction_original_commit_timestamp' => '0000-00-00 00:00:00.000000'
                                          },
          'group_replication_applier' => {
                                           'applying_transaction' => '',
                                           'applying_transaction_start_apply_timestamp' => '0000-00-00 00:00:00.000000',
                                           'service_state' => 'ON',
                                           'channel_name' => 'group_replication_applier',
                                           '_diff' => undef,
                                           'applying_transaction_original_commit_timestamp' => '0000-00-00 00:00:00.000000'
                                         }
        };

$applier_working_fine = {
          'group_replication_recovery' => {
                                            'applying_transaction' => '',
                                            'applying_transaction_start_apply_timestamp' => '0000-00-00 00:00:00.000000',
                                            'service_state' => 'OFF',
                                            'channel_name' => 'group_replication_recovery',
                                            '_diff' => undef,
                                            'applying_transaction_original_commit_timestamp' => '0000-00-00 00:00:00.000000'
                                          },
          'group_replication_applier' => {
                                           'applying_transaction' => '868f06a9-56f4-11eb-95f2-12aae384970d:87792',
                                           'applying_transaction_start_apply_timestamp' => '2021-01-15 06:28:25.466366',
                                           'service_state' => 'ON',
                                           'channel_name' => 'group_replication_applier',
                                           '_diff' => 0,
                                           'applying_transaction_original_commit_timestamp' => '2021-01-15 06:28:25.465745'
                                         }
        };

$applier_1s_lag = clone($applier_working_fine);
$applier_1s_lag->{group_replication_applier}->{_diff}= 1;

$applier_11s_lag = clone($applier_working_fine);
$applier_11s_lag->{group_replication_applier}->{_diff}= 11;

$applier_21s_lag = clone($applier_working_fine);
$applier_21s_lag->{group_replication_applier}->{_diff}= 21;

$recovery_much_lag = {
          'group_replication_recovery' => {
                                            'applying_transaction' => '868f06a9-56f4-11eb-95f2-12aae384970d:837487',
                                            'applying_transaction_start_apply_timestamp' => '2021-01-15 08:30:58.406646',
                                            'service_state' => 'ON',
                                            'channel_name' => 'group_replication_recovery',
                                            '_diff' => 745,
                                            'applying_transaction_original_commit_timestamp' => '2021-01-15 08:18:32.674919'
                                          },
          'group_replication_applier' => {
                                           'applying_transaction' => '',
                                           'applying_transaction_start_apply_timestamp' => '0000-00-00 00:00:00.000000',
                                           'service_state' => 'ON',
                                           'channel_name' => 'group_replication_applier',
                                           '_diff' => undef,
                                           'applying_transaction_original_commit_timestamp' => '0000-00-00 00:00:00.000000'
                                         }
        };

$recovery_1s_lag = clone($recovery_much_lag);
$recovery_1s_lag->{group_replication_recovery}->{_diff}= 1;

$recovery_11s_lag = clone($recovery_much_lag);
$recovery_11s_lag->{group_replication_recovery}->{_diff}= 11;

$recovery_21s_lag = clone($recovery_much_lag);
$recovery_21s_lag->{group_replication_recovery}->{_diff}= 21;


return 1;
