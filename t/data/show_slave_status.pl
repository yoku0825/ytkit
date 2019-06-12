package Ytkit::Test::SHOW_SLAVE_STATUS;

use Clone qw{ clone };

$NG = [
          {
            'Master_SSL_Allowed' => 'No',
            'Master_SSL_Crl' => '',
            'Relay_Log_Space' => '1943772',
            'Master_SSL_Key' => '',
            'Master_SSL_Cipher' => '',
            'Relay_Master_Log_File' => 'mysql-bin.000004',
            'Exec_Master_Log_Pos' => '3978544',
            'Replicate_Ignore_DB' => '',
            'Master_SSL_CA_File' => '',
            'Slave_SQL_Running' => 'No',
            'Master_Port' => '24102',
            'Last_SQL_Error_Timestamp' => '170829 15:18:59',
            'Replicate_Wild_Do_Table' => '',
            'Seconds_Behind_Master' => undef,
            'Master_Server_Id' => '1',
            'Connect_Retry' => '60',
            'Relay_Log_Pos' => '1943515',
            'Replicate_Ignore_Server_Ids' => '',
            'Last_Errno' => '1007',
            'Master_Info_File' => '/home/yoku0825/sandboxes/rsandbox_5_6_37/node1/data/master.info',
            'Last_IO_Error_Timestamp' => '',
            'Retrieved_Gtid_Set' => '',
            'Skip_Counter' => '0',
            'Until_Log_Pos' => '0',
            'Last_Error' => 'Error \'Can\'t create database \'d2\'; database exists\' on query. Default database: \'d2\'. Query: \'create database d2\'',
            'Master_User' => 'rsandbox',
            'Last_IO_Errno' => '0',
            'Master_Host' => '127.0.0.1',
            'Master_Log_File' => 'mysql-bin.000004',
            'Replicate_Do_Table' => '',
            'Relay_Log_File' => 'mysql-relay.000002',
            'Replicate_Do_DB' => '',
            'SQL_Delay' => '0',
            'Executed_Gtid_Set' => '',
            'Slave_IO_Running' => 'Yes',
            'Slave_SQL_Running_State' => '',
            'Master_SSL_Crlpath' => '',
            'Replicate_Ignore_Table' => '',
            'Slave_IO_State' => 'Waiting for master to send event',
            'Until_Condition' => 'None',
            'Until_Log_File' => '',
            'Last_SQL_Errno' => '1007',
            'Last_SQL_Error' => 'Error \'Can\'t create database \'d2\'; database exists\' on query. Default database: \'d2\'. Query: \'create database d2\'',
            'Auto_Position' => '0',
            'Replicate_Wild_Ignore_Table' => '',
            'SQL_Remaining_Delay' => undef,
            'Master_SSL_Verify_Server_Cert' => 'No',
            'Master_SSL_CA_Path' => '',
            'Master_UUID' => '00024102-1111-1111-1111-111111111111',
            'Master_SSL_Cert' => '',
            'Read_Master_Log_Pos' => '3978632',
            'Master_Bind' => '',
            'Master_Retry_Count' => '86400',
            'Last_IO_Error' => ''
          }
        ];

$OK= clone($NG);
$OK->[0]->{Slave_SQL_Running} = "Yes";
$OK->[0]->{Seconds_Behind_Master} = "43";

return 1;
