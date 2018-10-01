package Ytkit::Test::DUMP_HEALTH;

$NO_FAULTY = [
          {
            'group_id' => 'myfabric',
            'primary' => '1',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '0'
          },
          {
            'group_id' => 'yourfabric',
            'primary' => '1',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '0'
          }
        ];

$WITH_FAULTY = [
          {
            'group_id' => 'myfabric',
            'primary' => '1',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '1'
          },
          {
            'group_id' => 'yourfabric',
            'primary' => '1',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '0'
          }
        ];

$NO_PRIMARY = [
          {
            'group_id' => 'myfabric',
            'primary' => '0',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '0'
          },
          {
            'group_id' => 'yourfabric',
            'primary' => '1',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '0'
          }
        ];

$NO_SECONDARY = [
          {
            'group_id' => 'myfabric',
            'primary' => '1',
            'secondary' => '0',
            'spare' => '5',
            'faulty' => '0'
          },
          {
            'group_id' => 'yourfabric',
            'primary' => '1',
            'secondary' => '4',
            'spare' => '1',
            'faulty' => '0'
          }
        ];

return 1;
