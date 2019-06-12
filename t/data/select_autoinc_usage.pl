package Ytkit::Test::AUTOINC_USAGE;

use Clone qw{ clone };

$UNSIGNED = [
          {
            'column_type' => 'smallint(5) unsigned',
            'table_schema' => 'd1',
            'column_name' => 'num',
            'auto_increment' => '10001',
            'table_name' => 't1'
          },
          {
            'column_type' => 'bigint(20) unsigned',
            'table_schema' => 'd2',
            'column_name' => 'num',
            'auto_increment' => '1',
            'table_name' => 't1'
          },
          {
            'column_type' => 'int(10) unsigned',
            'table_schema' => 'mysql',
            'column_name' => 'Time_zone_id',
            'auto_increment' => '1',
            'table_name' => 'time_zone'
          }
        ];

$SIGNED= clone($UNSIGNED);
$SIGNED->[0]->{column_type}= 'smallint(5)';

return 1;
