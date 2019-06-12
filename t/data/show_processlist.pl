package Ytkit::Test::SHOW_PROCESSLIST;

use Clone qw{ clone };

$time_1000_query=
{
  'Time' => '1000',
  'Id' => '11',
  'db' => undef,
  'User' => 'userexclude',
  'State' => 'init',
  'Command' => 'Query',
  'Info' => 'SELECT SLEEP(100000)',
  'Host' => '192.168.0.1:32275'
};

$time_6000_query= clone($time_1000_query);
$time_6000_query->{Time}= "6000";

$time_1_0_1000_6000 = [
          {
            'Time' => '2464',
            'Id' => '1',
            'db' => undef,
            'User' => 'system user',
            'State' => 'Waiting for master to send event',
            'Command' => 'Connect',
            'Info' => undef,
            'Host' => ''
          },
          {
            'Time' => '2464',
            'Id' => '2',
            'db' => undef,
            'User' => 'system user',
            'State' => 'Slave has read all relay log; waiting for the slave I/O thread to update it',
            'Command' => 'Connect',
            'Info' => undef,
            'Host' => ''
          },
          {
            'Time' => '1',
            'Id' => '9',
            'db' => undef,
            'User' => 'msandbox',
            'State' => 'User sleep',
            'Command' => 'Query',
            'Info' => 'SELECT SLEEP(10000)',
            'Host' => 'localhost'
          },
          {
            'Time' => '0',
            'Id' => '10',
            'db' => undef,
            'User' => 'msandbox',
            'State' => 'init',
            'Command' => 'Query',
            'Info' => 'SHOW PROCESSLIST',
            'Host' => 'localhost'
          },
          $time_1000_query,
          $time_6000_query,
        ];

$time_1_0_1000_1000_6000_6000 = clone($time_1_0_1000_6000);
push(@$time_1_0_1000_1000_6000_6000, $time_1000_query, $time_6000_query);

$time_1_0_1000_1000_1000_6000_6000_6000 = clone($time_1_0_1000_1000_6000_6000);
push(@$time_1_0_1000_1000_1000_6000_6000_6000, $time_1000_query, $time_6000_query);

$processlist_at_slave= $time_1_0_1000_6000;

$processlist_at_master_gtid = [
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

$processlist_at_master_nongtid= clone($processlist_at_master_gtid);
$processlist_at_master_nongtid->[0]->{Command}= "Binlog Dump";
$processlist_at_master_nongtid->[1]->{Command}= "Binlog Dump";


return 1;
