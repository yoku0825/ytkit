package Ytkit::Test::Issue62;

$replication_group_member_stats = [
          {
            'LAST_CONFLICT_FREE_TRANSACTION' => '',
            'MEMBER_ID' => '',
            'COUNT_TRANSACTIONS_REMOTE_APPLIED' => 0,
            'COUNT_TRANSACTIONS_CHECKED' => 0,
            'COUNT_TRANSACTIONS_LOCAL_ROLLBACK' => 0,
            'VIEW_ID' => '',
            'COUNT_TRANSACTIONS_ROWS_VALIDATING' => 0,
            'COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE' => 0,
            'TRANSACTIONS_COMMITTED_ALL_MEMBERS' => '',
            'COUNT_CONFLICTS_DETECTED' => 0,
            'COUNT_TRANSACTIONS_LOCAL_PROPOSED' => 0,
            'COUNT_TRANSACTIONS_IN_QUEUE' => 0,
            'CHANNEL_NAME' => 'group_replication_applier'
          }
        ];

$replication_group_members = [
          {
            'MEMBER_HOST' => '',
            'MEMBER_PORT' => undef,
            'MEMBER_STATE' => 'OFFLINE',
            'MEMBER_ID' => '',
            'MEMBER_ROLE' => '',
            'MEMBER_VERSION' => '',
            'CHANNEL_NAME' => 'group_replication_applier'
          }
        ];

return 1;
