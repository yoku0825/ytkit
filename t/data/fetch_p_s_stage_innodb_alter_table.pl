package Ytkit::Test::fetch_p_s_stage_innodb_alter_table;

$ALL_YES = [
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (end)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (flush)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (insert)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (log apply index)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (log apply table)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (merge sort)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (read PK and internal sort)',
            'enabled' => 'YES'
          }
        ];

$SOMETHING_NO = [
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (end)',
            'enabled' => 'NO'
          },
          {
            'timed' => 'NO',
            'name' => 'stage/innodb/alter table (flush)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'NO',
            'name' => 'stage/innodb/alter table (insert)',
            'enabled' => 'NO'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (log apply index)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (log apply table)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (merge sort)',
            'enabled' => 'YES'
          },
          {
            'timed' => 'YES',
            'name' => 'stage/innodb/alter table (read PK and internal sort)',
            'enabled' => 'YES'
          }
        ];


return 1;
