package Ytkit::Test::alter_table_progress;

$VAR1 = [
          {
            'thread_id' => '51',
            'event_name' => 'stage/innodb/alter table (read PK and internal sort)',
            'processlist_id' => '17',
            'sql_text' => 'ALTER TABLE t1 ADD KEY (charcol1, intcol1)',
            'progress' => '15.384615300',
            'estimated' => '11.09567381512188',
            'elapsed' => '2.017395226'
          }
        ];

$alter_with_lr_and_spaces = [
          {
            'thread_id' => 32,
            'event_name' => 'stage/innodb/alter table (flush)',
            'processlist_id' => 7,
            'sql_text' => 'ALTER TABLE sbtest1  ADD KEY (c)     ,
                         ADD KEY (pad)',
            'progress' => '100.000000000',
            'estimated' => '0',
            'elapsed' => '12.716780226'
          }
        ];

return 1;
