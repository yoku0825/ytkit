package Ytkit::Test::SELECT_FROM_ps_digest;

$BEFORE = [
          {
            'sum_timer_wait' => '1134794420000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'world',
            'digest' => '3a8cfda4ae7ff05ba269aa13c8e8007ec0a6656e9192fcd6f92ebb83b727339f',
            'digest_text' => 'INSERT INTO `city` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 4079
          },
          {
            'sum_timer_wait' => '116391278000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'world',
            'digest' => '9a2e356170914fe732ffb7dfa2929f90e96adbd387a5adfc7dcee2498ca6101a',
            'digest_text' => 'INSERT INTO `countrylanguage` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 984
          },
          {
            'sum_timer_wait' => '1328729711000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'mysqlslap',
            'digest' => 'ad3f683e5cc182711f4a1c9c23c4932bc3efb24698a84843f9db7321baeb24fb',
            'digest_text' => 'INSERT INTO `t1` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 630
          },
          {
            'sum_timer_wait' => '39432803000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'world',
            'digest' => 'e751dbf9670ba82360d025580a3712cad26184de87b1a2a063f99ea673b6144a',
            'digest_text' => 'INSERT INTO `country` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 239
          },
          {
            'sum_timer_wait' => '392093167000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => undef,
            'digest' => 'c0066ea11affd8cfdecf6e133173291d0456413df0e3c1d722cf87551260c749',
            'digest_text' => 'SHOW GLOBAL VARIABLES',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 167,
            'count_star' => 167
          }
        ];

$AFTER = [
          {
            'sum_timer_wait' => '1134894420000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'world',
            'digest' => '3a8cfda4ae7ff05ba269aa13c8e8007ec0a6656e9192fcd6f92ebb83b727339f',
            'digest_text' => 'INSERT INTO `city` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 4079
          },
          {
            'sum_timer_wait' => '116398278000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'world',
            'digest' => '9a2e356170914fe732ffb7dfa2929f90e96adbd387a5adfc7dcee2498ca6101a',
            'digest_text' => 'INSERT INTO `countrylanguage` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 984
          },
          {
            'sum_timer_wait' => '1328729761000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'mysqlslap',
            'digest' => 'ad3f683e5cc182711f4a1c9c23c4932bc3efb24698a84843f9db7321baeb24fb',
            'digest_text' => 'INSERT INTO `t1` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 640
          },
          {
            'sum_timer_wait' => '39432873000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'world',
            'digest' => 'e751dbf9670ba82360d025580a3712cad26184de87b1a2a063f99ea673b6144a',
            'digest_text' => 'INSERT INTO `country` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 0,
            'count_star' => 239
          },
          {
            'sum_timer_wait' => '392094167000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => undef,
            'digest' => 'c0066ea11affd8cfdecf6e133173291d0456413df0e3c1d722cf87551260c749',
            'digest_text' => 'SHOW GLOBAL VARIABLES',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'sum_sort_rows' => 0,
            'sum_created_tmp_tables' => 367,
            'count_star' => 367
          }
        ];

$BEFORE_COMPAT = [
          {
            'sum_timer_wait' => '1134794420000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'world',
            'digest' => '3a8cfda4ae7ff05ba269aa13c8e8007ec0a6656e9192fcd6f92ebb83b727339f',
            'digest_text' => 'INSERT INTO `city` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 4079
          },
          {
            'sum_timer_wait' => '116391278000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'world',
            'digest' => '9a2e356170914fe732ffb7dfa2929f90e96adbd387a5adfc7dcee2498ca6101a',
            'digest_text' => 'INSERT INTO `countrylanguage` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 984
          },
          {
            'sum_timer_wait' => '1328729711000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'mysqlslap',
            'digest' => 'ad3f683e5cc182711f4a1c9c23c4932bc3efb24698a84843f9db7321baeb24fb',
            'digest_text' => 'INSERT INTO `t1` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 630
          },
          {
            'sum_timer_wait' => '39432803000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => 'world',
            'digest' => 'e751dbf9670ba82360d025580a3712cad26184de87b1a2a063f99ea673b6144a',
            'digest_text' => 'INSERT INTO `country` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 239
          },
          {
            'sum_timer_wait' => '392093167000',
            'last_update' => '2018-11-26 14:59:46',
            'schema_name' => undef,
            'digest' => 'c0066ea11affd8cfdecf6e133173291d0456413df0e3c1d722cf87551260c749',
            'digest_text' => 'SHOW GLOBAL VARIABLES',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 167
          }
        ];

$AFTER_COMPAT = [
          {
            'sum_timer_wait' => '1134894420000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'world',
            'digest' => '3a8cfda4ae7ff05ba269aa13c8e8007ec0a6656e9192fcd6f92ebb83b727339f',
            'digest_text' => 'INSERT INTO `city` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 4079
          },
          {
            'sum_timer_wait' => '116398278000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'world',
            'digest' => '9a2e356170914fe732ffb7dfa2929f90e96adbd387a5adfc7dcee2498ca6101a',
            'digest_text' => 'INSERT INTO `countrylanguage` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 984
          },
          {
            'sum_timer_wait' => '1328729761000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'mysqlslap',
            'digest' => 'ad3f683e5cc182711f4a1c9c23c4932bc3efb24698a84843f9db7321baeb24fb',
            'digest_text' => 'INSERT INTO `t1` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 640
          },
          {
            'sum_timer_wait' => '39432873000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => 'world',
            'digest' => 'e751dbf9670ba82360d025580a3712cad26184de87b1a2a063f99ea673b6144a',
            'digest_text' => 'INSERT INTO `country` VALUES (...)',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 239
          },
          {
            'sum_timer_wait' => '392094167000',
            'last_update' => '2018-11-26 14:59:48',
            'schema_name' => undef,
            'digest' => 'c0066ea11affd8cfdecf6e133173291d0456413df0e3c1d722cf87551260c749',
            'digest_text' => 'SHOW GLOBAL VARIABLES',
            'sum_rows_examined' => 0,
            'sum_rows_sent' => 0,
            'count_star' => 367
          }
        ];

return 1;
