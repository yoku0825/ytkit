package Ytkit::Test::SELECT_FROM_ps_repl_group_members;

use Clone qw{ clone };

my $my_gtid= "04829ca1-136d-11eb-97d8-0201965f8d32";
$online3 = [
          {
            'member_id' => $my_gtid,
            'member_state' => 'ONLINE',
            'member_role' => 'PRIMARY'
          },
          {
            'member_id' => '90d425fc-54bb-11eb-913c-127591ee184b',
            'member_state' => 'ONLINE',
            'member_role' => 'SECONDARY'
          },
          {
            'member_id' => '90d425fc-XXXX-11eb-913c-127591ee184b',
            'member_state' => 'ONLINE',
            'member_role' => 'SECONDARY'
          }
 
        ];

$online2= clone($online3);
shift(@$online2);

$online2_unreach1= clone($online3);
$online2_unreach1->[2]->{member_state}= "UNREACHABLE";

$online1_unreach2= clone($online3);
$online1_unreach2->[1]->{member_state}= "UNREACHABLE";
$online1_unreach2->[2]->{member_state}= "UNREACHABLE";

$offline1 = [
          {
            'member_id' => '90d425fc-54bb-11eb-913c-127591ee184b',
            'member_state' => 'OFFLINE',
            'member_role' => 'SECONDARY'
          }
        ];

return 1;
