package Ytkit::Test::SHOW_PROCESSLIST_WITH_GTID_SLAVE;

$VAR1 = [
          {
            'Time' => '6',
            'Id' => '3',
            'db' => undef,
            'User' => 'rsandbox',
            'State' => 'Master has sent all binlog to slave; waiting for binlog to be updated',
            'Command' => 'Binlog Dump GTID',
            'Info' => undef,
            'Host' => 'localhost:46670'
          },
          {
            'Time' => '6',
            'Id' => '4',
            'db' => undef,
            'User' => 'rsandbox',
            'State' => 'Master has sent all binlog to slave; waiting for binlog to be updated',
            'Command' => 'Binlog Dump GTID',
            'Info' => undef,
            'Host' => 'localhost:46672'
          },
          {
            'Time' => '0',
            'Id' => '5',
            'db' => undef,
            'User' => 'msandbox',
            'State' => 'init',
            'Command' => 'Query',
            'Info' => 'SHOW FULL PROCESSLIST',
            'Host' => 'localhost'
          }
        ];

return 1;
