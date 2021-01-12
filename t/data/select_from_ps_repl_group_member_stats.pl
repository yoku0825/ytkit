package Ytkit::Test::SELECT_FROM_ps_repl_group_member_stats;

use Clone qw{ clone };

$all_synced = [
          {
            'count_transactions_remote_in_applier_queue' => 0,
            'transactions_committed_all_members' => '868f06a9-56f4-11eb-95f2-12aae384970d:1-588070'
          }
        ];

$behind_1001= clone($all_synced);
$behind_1001->[0]->{count_transactions_remote_in_applier_queue}= 1001;

$behind_2001= clone($all_synced);
$behind_2001->[0]->{count_transactions_remote_in_applier_queue}= 2001;

return 1;
