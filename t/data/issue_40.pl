package Ytkit::Test::ISSUE40;

$before8019 = [
          {
            'column_type' => 'bigint(20) unsigned',
            'table_schema' => 'd1',
            'column_name' => 'num',
            'auto_increment' => 1,
            'table_name' => 't1'
          }
        ];

$after8019 = [
          {
            'column_type' => 'bigint unsigned',
            'table_schema' => 'd1',
            'column_name' => 'num',
            'auto_increment' => 1,
            'table_name' => 't1'
          }
        ];



return 1;
