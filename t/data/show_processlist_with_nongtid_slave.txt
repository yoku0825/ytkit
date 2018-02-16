package Ytkit::Test::SHOW_PROCESSLIST_WITH_NONGTID_SLAVE;

$VAR1 = [
          {
            'Time' => '513',
            'Id' => '3',
            'db' => undef,
            'User' => 'rsandbox',
            'State' => 'Master has sent all binlog to slave; waiting for binlog to be updated',
            'Command' => 'Binlog Dump',
            'Info' => undef,
            'Host' => 'localhost:46636'
          },
          {
            'Time' => '513',
            'Id' => '4',
            'db' => undef,
            'User' => 'rsandbox',
            'State' => 'Master has sent all binlog to slave; waiting for binlog to be updated',
            'Command' => 'Binlog Dump',
            'Info' => undef,
            'Host' => 'localhost:46638'
          },
          {
            'Time' => '0',
            'Id' => '8',
            'db' => undef,
            'User' => 'msandbox',
            'State' => 'init',
            'Command' => 'Query',
            'Info' => 'SHOW FULL PROCESSLIST',
            'Host' => 'localhost'
          }
        ];

return 1;
