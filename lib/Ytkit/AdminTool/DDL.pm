package Ytkit::AdminTool::DDL;

########################################################################
# Copyright (C) 2020, 2021  yoku0825
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
########################################################################

use strict;
use warnings;
use utf8;

### admintool_schema
my $instance_info= << 'EOS';
CREATE TABLE `instance_info` (
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `last_update` datetime NOT NULL,
  `monitoring_enable` tinyint NOT NULL DEFAULT '1',
  `healthcheck_role` varchar(32) NOT NULL DEFAULT 'auto',
  `last_status` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`ipaddr`,`port`)
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $variable_info= << 'EOS';
CREATE TABLE `variable_info` (
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `variable_name` varchar(255) NOT NULL,
  `value` text,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`ipaddr`,`port`,`variable_name`),
  CONSTRAINT `variable_info_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic 
EOS

my $table_status_info= << 'EOS';
CREATE TABLE `table_status_info` (
  `seq` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `table_schema` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `table_rows` bigint unsigned NOT NULL,
  `data_length` bigint unsigned NOT NULL,
  `index_length` bigint unsigned NOT NULL,
  `data_free` bigint unsigned NOT NULL,
  `engine` varchar(32) NOT NULL,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `idx_lastupdate` (`last_update`),
  CONSTRAINT `table_status_info_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $grant_info= << 'EOS';
CREATE TABLE `grant_info` (
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `user_name` varchar(32) NOT NULL,
  `user_host` varchar(60) NOT NULL,
  `grants` longtext,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`ipaddr`,`port`,`user_name`,`user_host`),
  CONSTRAINT `grant_info_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $is_innodb_metrics= << 'EOS';
CREATE TABLE `is_innodb_metrics` (
  `seq` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `name` varchar(193) NOT NULL,
  `count` bigint NOT NULL,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `idx_lastupdate` (`last_update`),
  CONSTRAINT `is_innodb_metrics_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $ps_digest_info= << 'EOS';
CREATE TABLE `ps_digest_info` (
  `seq` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `schema_name` varchar(255) NOT NULL,
  `digest` varchar(255) NOT NULL,
  `digest_text` text NOT NULL,
  `count_star` bigint unsigned NOT NULL,
  `sum_rows_examined` bigint unsigned NOT NULL,
  `sum_rows_sent` bigint unsigned NOT NULL,
  `last_update` datetime NOT NULL,
  `sum_timer_wait` bigint unsigned NOT NULL,
  `sum_sort_rows` bigint unsigned NOT NULL,
  `sum_created_tmp_tables` bigint unsigned NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `idx_lastupdate` (`last_update`),
  CONSTRAINT `ps_digest_info_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $ps_table_info= << 'EOS';
CREATE TABLE `ps_table_info` (
  `seq` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `table_schema` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `count_read` bigint unsigned NOT NULL,
  `count_write` bigint unsigned NOT NULL,
  `last_update` datetime NOT NULL,
  `sum_timer_read` bigint unsigned NOT NULL,
  `sum_timer_write` bigint unsigned NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `idx_lastupdate` (`last_update`),
  CONSTRAINT `ps_table_info_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $slave_info= << 'EOS';
CREATE TABLE `slave_info` (
  `ipaddr` varchar(15) NOT NULL DEFAULT '',
  `port` smallint unsigned NOT NULL DEFAULT '0',
  `master_ipaddr` varchar(15) DEFAULT NULL,
  `master_port` smallint unsigned DEFAULT NULL,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`ipaddr`,`port`),
  CONSTRAINT `slave_info_ibfk_2` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $status_info= << 'EOS';
CREATE TABLE `status_info` (
  `seq` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ipaddr` varchar(15) NOT NULL,
  `port` smallint unsigned NOT NULL,
  `variable_name` varchar(255) NOT NULL,
  `value` text,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `idx_lastupdate` (`last_update`),
  CONSTRAINT `status_info_ibfk_1` FOREIGN KEY (`ipaddr`, `port`) REFERENCES `instance_info` (`ipaddr`, `port`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

my $ytkit_option= << 'EOS';
CREATE TABLE `ytkit_option` (
  `program_name` varchar(32) NOT NULL,
  `option_name` varchar(64) NOT NULL,
  `option_value` varchar(64) NOT NULL,
  PRIMARY KEY (`program_name`,`option_name`)
) ENGINE=InnoDB, ROW_FORMAT=Dynamic
EOS

### adminview_schema(common)
my $datadir_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `datadir_list` AS
  SELECT `admintool`.`variable_info`.`ipaddr` AS `ipaddr`,
         `admintool`.`variable_info`.`port` AS `port`,
         `admintool`.`variable_info`.`value` AS `datadir`
  FROM `admintool`.`variable_info`
  WHERE `admintool`.`variable_info`.`variable_name` = 'datadir'
EOS

my $hostname_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `hostname_list` AS
  SELECT DISTINCT
         SUBSTRING_INDEX(`admintool`.`variable_info`.`value`,'.',1) AS `hostname`, /* Trim 1st dot */
         `admintool`.`variable_info`.`ipaddr` AS `ipaddr`
  FROM `admintool`.`variable_info`
  WHERE `admintool`.`variable_info`.`variable_name` = 'hostname'
EOS

my $version_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `version_list` AS
  SELECT `admintool`.`variable_info`.`ipaddr` AS `ipaddr`,
         `admintool`.`variable_info`.`port` AS `port`,
         `admintool`.`variable_info`.`value` AS `version`
  FROM `admintool`.`variable_info`
  WHERE `admintool`.`variable_info`.`variable_name` = 'version'
EOS

my $instance_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `instance_list` AS
  SELECT `hostname_list`.`hostname` AS `hostname`,
         `admintool`.`instance_info`.`ipaddr` AS `ipaddr`,
         `admintool`.`instance_info`.`port` AS `port`,
         CASE `admintool`.`instance_info`.`healthcheck_role`
           WHEN 'fabric' THEN 'fabric'
           ELSE `datadir_list`.`datadir` 
         END AS `datadir`,
         `version_list`.`version` AS `version`,
         CASE
           WHEN `admintool`.`slave_info`.`master_ipaddr` IS NOT NULL
             THEN CONCAT(`admintool`.`slave_info`.`master_ipaddr`, ':', `admintool`.`slave_info`.`master_port`)
             ELSE CASE `admintool`.`instance_info`.`healthcheck_role`
                    WHEN 'auto' THEN 'master'
                    ELSE `admintool`.`instance_info`.`healthcheck_role`
                  END
           END AS `master`,
         IF(`admintool`.`instance_info`.`monitoring_enable` = 1, 'ACTIVE', 'INACTIVE') AS `monitor`
  FROM `admintool`.`instance_info` 
    LEFT JOIN `hostname_list` USING (ipaddr)
    LEFT JOIN `datadir_list` USING(ipaddr, port)
    LEFT JOIN `version_list` USING(ipaddr, port)
    LEFT JOIN `admintool`.`slave_info` USING(ipaddr, port)
EOS

my $grant_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `grant_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`grant_info`.`user_name` AS `user_name`,
         `admintool`.`grant_info`.`user_host` AS `user_host`,
         `admintool`.`grant_info`.`grants` AS `grants`,
         `admintool`.`grant_info`.`last_update` AS `last_update`
  FROM `instance_list` JOIN `admintool`.`grant_info` USING(ipaddr, port)
EOS

my $is_metrics_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `is_metrics_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`is_innodb_metrics`.`name` AS `name`,
         `admintool`.`is_innodb_metrics`.`count` AS `count`,
         `admintool`.`is_innodb_metrics`.`last_update` AS `last_update`
  FROM `admintool`.`is_innodb_metrics` JOIN `instance_list` USING(ipaddr, port)
EOS

my $ps_digest_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `ps_digest_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`ps_digest_info`.`schema_name` AS `schema_name`,
         `admintool`.`ps_digest_info`.`digest` AS `digest`,
         `admintool`.`ps_digest_info`.`digest_text` AS `digest_text`,
         `admintool`.`ps_digest_info`.`count_star` AS `count_star`,
         `admintool`.`ps_digest_info`.`sum_timer_wait` AS `sum_timer_wait`,
         `admintool`.`ps_digest_info`.`sum_rows_examined` AS `sum_rows_examined`,
         `admintool`.`ps_digest_info`.`sum_rows_sent` AS `sum_rows_sent`,
         `admintool`.`ps_digest_info`.`sum_sort_rows` AS `sum_sort_rows`,
         `admintool`.`ps_digest_info`.`sum_created_tmp_tables` AS `sum_created_tmp_tables`,
         `admintool`.`ps_digest_info`.`last_update` AS `last_update`
  FROM `admintool`.`ps_digest_info` JOIN `instance_list` USING(ipaddr, port)
EOS

my $ps_table_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `ps_table_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`ps_table_info`.`table_schema` AS `table_schema`,
         `admintool`.`ps_table_info`.`table_name` AS `table_name`,
         `admintool`.`ps_table_info`.`count_read` AS `count_read`,
         `admintool`.`ps_table_info`.`count_write` AS `count_write`,
         `admintool`.`ps_table_info`.`last_update` AS `last_update`,
         `admintool`.`ps_table_info`.`sum_timer_read` AS `sum_timer_read`,
         `admintool`.`ps_table_info`.`sum_timer_write` AS `sum_timer_write`
  FROM `instance_list` JOIN `admintool`.`ps_table_info` USING(ipaddr, port)
EOS

my $status_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `status_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`status_info`.`variable_name` AS `variable_name`,
         `admintool`.`status_info`.`value` AS `value`,
         `admintool`.`status_info`.`last_update` AS `last_update`
  FROM `instance_list` JOIN `admintool`.`status_info` USING(ipaddr, port)
EOS

my $table_status_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `table_status_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`table_status_info`.`table_schema` AS `table_schema`,
         `admintool`.`table_status_info`.`table_name` AS `table_name`,
         `admintool`.`table_status_info`.`table_rows` AS `table_rows`,
         `admintool`.`table_status_info`.`data_length` AS `data_length`,
         `admintool`.`table_status_info`.`index_length` AS `index_length`,
         `admintool`.`table_status_info`.`data_free` AS `data_free`,
         `admintool`.`table_status_info`.`last_update` AS `last_update`
  FROM `instance_list` JOIN `admintool`.`table_status_info` USING(ipaddr, port)
EOS

my $variable_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `variable_list` AS
  SELECT `instance_list`.`hostname` AS `hostname`,
         `instance_list`.`ipaddr` AS `ipaddr`,
         `instance_list`.`port` AS `port`,
         `instance_list`.`datadir` AS `datadir`,
         `admintool`.`variable_info`.`variable_name` AS `variable_name`,
         `admintool`.`variable_info`.`value` AS `value`
  FROM `instance_list` JOIN `admintool`.`variable_info` USING(ipaddr, port)
EOS

my $daily_table_row_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `daily_table_row_list` AS
  SELECT CAST(`table_status_list`.`last_update` AS DATE) AS `_date`,
         `table_status_list`.`hostname` AS `hostname`,
         `table_status_list`.`ipaddr` AS `ipaddr`,
         `table_status_list`.`port` AS `port`,
         `table_status_list`.`datadir` AS `datadir`,
         `table_status_list`.`table_schema` AS `table_schema`,
         `table_status_list`.`table_name` AS `table_name`,
         AVG(`table_status_list`.`table_rows`) AS `table_rows`,
         AVG(`table_status_list`.`data_length`) AS `data_length`,
         AVG(`table_status_list`.`index_length`) AS `index_length`,
         AVG(`table_status_list`.`data_free`) AS `data_free`
  FROM `table_status_list`
  GROUP BY `_date`, `hostname`, `ipaddr`, `port`, `datadir`, `table_schema`, `table_name`
EOS

my $daily_table_latency_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `daily_table_latency_list` AS
  SELECT CAST(`ps_table_list`.`last_update` AS DATE) AS `_date`,
         `ps_table_list`.`hostname` AS `hostname`,
         `ps_table_list`.`ipaddr` AS `ipaddr`,
         `ps_table_list`.`port` AS `port`,
         `ps_table_list`.`datadir` AS `datadir`,
         `ps_table_list`.`table_schema` AS `table_schema`,
         `ps_table_list`.`table_name` AS `table_name`,
         AVG(`ps_table_list`.`count_read`) AS `count_read`,
         AVG(`ps_table_list`.`count_write`) AS `count_write`,
         AVG(`ps_table_list`.`sum_timer_read`) AS `sum_timer_read`,
         AVG(`ps_table_list`.`sum_timer_write`) AS `sum_timer_write`
  FROM `ps_table_list`
  GROUP BY `_date`, `hostname`, `ipaddr`, `port`, `datadir`, `table_schema`, `table_name`
EOS

my $daily_digest_latency_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `daily_digest_latency_list` AS
  SELECT CAST(`ps_digest_list`.`last_update` AS DATE) AS `_date`,
         `ps_digest_list`.`hostname` AS `hostname`,
         `ps_digest_list`.`ipaddr` AS `ipaddr`,
         `ps_digest_list`.`port` AS `port`,
         `ps_digest_list`.`datadir` AS `datadir`,
         `ps_digest_list`.`digest` AS `digest`,
         `ps_digest_list`.`digest_text` AS `digest_text`,
         AVG(`ps_digest_list`.`count_star`) AS `count_star`,
         AVG(`ps_digest_list`.`sum_timer_wait`) AS `sum_timer_wait`,
         AVG(`ps_digest_list`.`sum_rows_examined`) AS `sum_rows_examined`,
         AVG(`ps_digest_list`.`sum_rows_sent`) AS `sum_rows_sent`,
         AVG(`ps_digest_list`.`sum_sort_rows`) AS `sum_sort_rows`,
         AVG(`ps_digest_list`.`sum_created_tmp_tables`) AS `sum_created_tmp_tables`
  FROM `ps_digest_list`
  GROUP BY `_date`, `hostname`, `ipaddr`, `port`, `datadir`, `digest`, `digest_text`
EOS

my $daily_is_metrics_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `daily_is_metrics_list` AS
  SELECT CAST(`is_metrics_list`.`last_update` AS DATE) AS `_date`,
         `is_metrics_list`.`hostname` AS `hostname`,
         `is_metrics_list`.`ipaddr` AS `ipaddr`,
         `is_metrics_list`.`port` AS `port`,
         `is_metrics_list`.`datadir` AS `datadir`,
         `is_metrics_list`.`name` AS `name`,
         AVG(`is_metrics_list`.`count`) AS `avg_count`
  FROM `is_metrics_list`
  GROUP BY `_date`, `hostname`, `ipaddr`, `port`, `datadir`, `name`
EOS

my $daily_status_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `daily_status_list` AS
  SELECT CAST(`status_list`.`last_update` AS DATE) AS `_date`,
         `status_list`.`hostname` AS `hostname`,
         `status_list`.`ipaddr` AS `ipaddr`,
         `status_list`.`port` AS `port`,
         `status_list`.`datadir` AS `datadir`,
         `status_list`.`variable_name` AS `variable_name`,
         AVG(`status_list`.`value`) AS `avg_count`
  FROM `status_list`
  GROUP BY `_date`, `hostname`, `ipaddr`, `port`, `datadir`, `variable_name`
EOS

my $daily_innodb_rows_read_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `daily_innodb_rows_read_list` AS
  SELECT CAST(`status_list`.`last_update` AS DATE) AS `_date`,
         `status_list`.`hostname` AS `hostname`,
         `status_list`.`ipaddr` AS `ipaddr`,
         `status_list`.`port` AS `port`,
         `status_list`.`datadir` AS `datadir`,
         `status_list`.`variable_name` AS `variable_name`,
         AVG(`status_list`.`value`) AS `avg_count`
  FROM `status_list`
  WHERE `status_list`.`variable_name` = 'Innodb_rows_read'
  GROUP BY `_date`, `hostname`, `ipaddr`, `port`, `datadir`, `variable_name`
EOS




### adminview_schema (for 8.0.11 and later)
my $recent_status_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `recent_status_list` AS
  WITH ranked_status_list AS (
    SELECT `status_list`.`hostname` AS `hostname`,
           `status_list`.`ipaddr` AS `ipaddr`,
           `status_list`.`port` AS `port`,
           `status_list`.`datadir` AS `datadir`,
           `status_list`.`variable_name` AS `variable_name`,
           `status_list`.`value` AS `value`,
           `status_list`.`last_update` AS `last_update`,
           RANK() OVER w AS `_rank` 
    FROM `status_list`
    WINDOW w AS (PARTITION BY ipaddr, port ORDER BY last_update DESC))
  SELECT `ranked_status_list`.`hostname` AS `hostname`,
         `ranked_status_list`.`ipaddr` AS `ipaddr`,
         `ranked_status_list`.`port` AS `port`,
         `ranked_status_list`.`datadir` AS `datadir`,
         `ranked_status_list`.`variable_name` AS `variable_name`,
         `ranked_status_list`.`value` AS `value`,
         `ranked_status_list`.`last_update` AS `last_update`
  FROM ranked_status_list
  WHERE `ranked_status_list`.`_rank` = 1
EOS

my $recent_table_status_list= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `recent_table_status_list` AS
  WITH ranked_table_status_list AS (
    SELECT `table_status_list`.`hostname` AS `hostname`,
           `table_status_list`.`ipaddr` AS `ipaddr`,
           `table_status_list`.`port` AS `port`,
           `table_status_list`.`datadir` AS `datadir`,
           `table_status_list`.`table_schema` AS `table_schema`,
           `table_status_list`.`table_name` AS `table_name`,
           `table_status_list`.`table_rows` AS `table_rows`,
           `table_status_list`.`data_length` AS `data_length`,
           `table_status_list`.`index_length` AS `index_length`,
           `table_status_list`.`data_free` AS `data_free`,
           `table_status_list`.`last_update` AS `last_update`,
           RANK() OVER w AS `_rank`
    FROM `table_status_list`
    WINDOW w AS (PARTITION BY ipaddr, port, table_schema, table_name ORDER BY last_update DESC))
  SELECT `ranked_table_status_list`.`hostname` AS `hostname`,
         `ranked_table_status_list`.`ipaddr` AS `ipaddr`,
         `ranked_table_status_list`.`port` AS `port`,
         `ranked_table_status_list`.`datadir` AS `datadir`,
         `ranked_table_status_list`.`table_schema` AS `table_schema`,
         `ranked_table_status_list`.`table_name` AS `table_name`,
         `ranked_table_status_list`.`table_rows` AS `table_rows`,
         `ranked_table_status_list`.`data_length` AS `data_length`,
         `ranked_table_status_list`.`index_length` AS `index_length`,
         `ranked_table_status_list`.`data_free` AS `data_free`,
         `ranked_table_status_list`.`last_update` AS `last_update`
  FROM ranked_table_status_list
  WHERE `ranked_table_status_list`.`_rank` = 1
EOS

my $last_33_days_calendar= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `last_33_days_calendar` AS
  WITH RECURSIVE `last_33_days_calendar` AS (
    SELECT CURDATE() AS `_date`
    UNION ALL
    SELECT `last_33_days_calendar`.`_date` - INTERVAL 1 DAY AS `_date`
    FROM `last_33_days_calendar`
    WHERE `last_33_days_calendar`.`_date` > CURDATE() - INTERVAL 29 DAY)
  SELECT `last_33_days_calendar`.`_date` AS `_date`
  FROM `last_33_days_calendar`
EOS

my $last_90_days_calendar= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `last_90_days_calendar` AS
  WITH RECURSIVE `last_90_days_calendar` AS (
    SELECT CURDATE() AS `_date`
    UNION ALL
    SELECT `last_90_days_calendar`.`_date` - INTERVAL 1 DAY AS `_date`
    FROM `last_90_days_calendar`
    WHERE `last_90_days_calendar`.`_date` > CURDATE() - INTERVAL 89 DAY)
  SELECT `last_90_days_calendar`.`_date` AS `_date`
  FROM `last_90_days_calendar`
EOS

my $table_status_list_last_month= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `table_status_list_last_month` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_table_row_list`.`hostname` AS `hostname`,
         `daily_table_row_list`.`ipaddr` AS `ipaddr`,
         `daily_table_row_list`.`port` AS `port`,
         `daily_table_row_list`.`datadir` AS `datadir`,
         `daily_table_row_list`.`table_schema` AS `table_schema`,
         `daily_table_row_list`.`table_name` AS `table_name`,
         `daily_table_row_list`.`table_rows` AS `table_rows`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         AVG(`daily_table_row_list`.`table_rows`) OVER `w7` AS `moving_avg_7`,
         FIRST_VALUE(`daily_table_row_list`.`table_rows`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_table_row_list`.`table_rows`) OVER `w_all` AS `_last`,
         (`daily_table_row_list`.`table_rows` - LAG(`daily_table_row_list`.`table_rows`) OVER `w`) AS `_diff`
  FROM `last_90_days_calendar` LEFT JOIN `daily_table_row_list` USING(_date)
  WHERE MONTH(_date) = MONTH(CURDATE() - INTERVAL 1 MONTH)
  WINDOW `w` AS (PARTITION BY hostname, datadir, table_schema, table_name ORDER BY _date),
         `w7` AS (`w` ROWS BETWEEN 7 PRECEDING AND CURRENT ROW),
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $table_status_list_analyze_33= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `table_status_list_analyze_33` AS
  SELECT `last_33_days_calendar`.`_date` AS `_date`,
         `daily_table_row_list`.`hostname` AS `hostname`,
         `daily_table_row_list`.`ipaddr` AS `ipaddr`,
         `daily_table_row_list`.`port` AS `port`,
         `daily_table_row_list`.`datadir` AS `datadir`,
         `daily_table_row_list`.`table_schema` AS `table_schema`,
         `daily_table_row_list`.`table_name` AS `table_name`,
         `daily_table_row_list`.`table_rows` AS `table_rows`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         AVG(`daily_table_row_list`.`table_rows`) OVER `w7` AS `moving_avg_7`,
         FIRST_VALUE(`daily_table_row_list`.`table_rows`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_table_row_list`.`table_rows`) OVER `w_all` AS `_last`,
         (`daily_table_row_list`.`table_rows` - LAG(`daily_table_row_list`.`table_rows`) OVER `w`) AS `_diff`
  FROM `last_33_days_calendar` LEFT JOIN `daily_table_row_list` USING(_date)
  WINDOW `w` AS (PARTITION BY hostname, datadir, table_schema, table_name ORDER BY _date),
         `w7` AS (`w` ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) ,
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $table_status_list_analyze_90= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `table_status_list_analyze_90` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_table_row_list`.`hostname` AS `hostname`,
         `daily_table_row_list`.`ipaddr` AS `ipaddr`,
         `daily_table_row_list`.`port` AS `port`,
         `daily_table_row_list`.`datadir` AS `datadir`,
         `daily_table_row_list`.`table_schema` AS `table_schema`,
         `daily_table_row_list`.`table_name` AS `table_name`,
         `daily_table_row_list`.`table_rows` AS `table_rows`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         AVG(`daily_table_row_list`.`table_rows`) OVER `w7` AS `moving_avg_7`,
         FIRST_VALUE(`daily_table_row_list`.`table_rows`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_table_row_list`.`table_rows`) OVER `w_all` AS `_last`,
         (`daily_table_row_list`.`table_rows` - LAG(`daily_table_row_list`.`table_rows`) OVER `w`) AS `_diff`
  FROM `last_90_days_calendar` LEFT JOIN `daily_table_row_list` USING(_date)
  WINDOW `w` AS (PARTITION BY hostname, datadir, table_schema, table_name ORDER BY _date),
         `w7` AS (`w` ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) ,
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $table_read_list_analyze_last_month= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `table_read_list_analyze_last_month` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_table_latency_list`.`hostname` AS `hostname`,
         `daily_table_latency_list`.`ipaddr` AS `ipaddr`,
         `daily_table_latency_list`.`port` AS `port`,
         `daily_table_latency_list`.`datadir` AS `datadir`,
         `daily_table_latency_list`.`table_schema` AS `table_schema`,
         `daily_table_latency_list`.`table_name` AS `table_name`,
         `daily_table_latency_list`.`count_read` AS `count_read`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         AVG(`daily_table_latency_list`.`count_read`) OVER `w7` AS `moving_avg_7`,
         FIRST_VALUE(`daily_table_latency_list`.`count_read`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_table_latency_list`.`count_read`) OVER `w_all` AS `_last`,
         (`daily_table_latency_list`.`count_read` - LAG(`daily_table_latency_list`.`count_read`) OVER `w`) AS `_diff`
  FROM `last_90_days_calendar` LEFT JOIN `daily_table_latency_list` USING(_date)
  WHERE MONTH(_date) = MONTH(CURDATE() - INTERVAL 1 MONTH)
  WINDOW `w` AS (PARTITION BY hostname, datadir, table_schema, table_name ORDER BY _date),
         `w7` AS (`w` ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) ,
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $table_read_list_analyze_90= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `table_read_list_analyze_90` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_table_latency_list`.`hostname` AS `hostname`,
         `daily_table_latency_list`.`ipaddr` AS `ipaddr`,
         `daily_table_latency_list`.`port` AS `port`,
         `daily_table_latency_list`.`datadir` AS `datadir`,
         `daily_table_latency_list`.`table_schema` AS `table_schema`,
         `daily_table_latency_list`.`table_name` AS `table_name`,
         `daily_table_latency_list`.`count_read` AS `count_read`,
         FIRST_VALUE(`daily_table_latency_list`.`count_read`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_table_latency_list`.`count_read`) OVER `w_all` AS `_last`,
         (`daily_table_latency_list`.`count_read` - LAG(`daily_table_latency_list`.`count_read`) OVER `w`) AS `_diff`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         AVG(`daily_table_latency_list`.`count_read`) OVER `w7` AS `moving_avg_7`
  FROM `last_90_days_calendar` LEFT JOIN `daily_table_latency_list` USING(_date)
  WINDOW `w` AS (PARTITION BY hostname, datadir, table_schema, table_name ORDER BY _date),
         `w7` AS (`w` ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) ,
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $digest_list_analyze_90= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `digest_list_analyze_90` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_digest_latency_list`.`hostname` AS `hostname`,
         `daily_digest_latency_list`.`ipaddr` AS `ipaddr`,
         `daily_digest_latency_list`.`port` AS `port`,
         `daily_digest_latency_list`.`datadir` AS `datadir`,
         `daily_digest_latency_list`.`digest` AS `digest`,
         `daily_digest_latency_list`.`digest_text` AS `digest_text`,
         `daily_digest_latency_list`.`count_star` AS `count_star`,
         `daily_digest_latency_list`.`sum_rows_examined` AS `sum_rows_examined`,
         `daily_digest_latency_list`.`sum_rows_sent` AS `sum_rows_sent`,
         `daily_digest_latency_list`.`sum_sort_rows` AS `sum_sort_rows`,
         `daily_digest_latency_list`.`sum_created_tmp_tables` AS `sum_created_tmp_tables`,
         `sum_rows_examined` / `count_star` AS `avg_rows_examined`,
         `sum_rows_sent` / `count_star` AS `avg_rows_sent`,
         `sum_rows_examined` / `sum_rows_sent` AS `index_ratio`
  FROM `last_90_days_calendar` LEFT JOIN `daily_digest_latency_list` USING(_date)
EOS

my $is_metrics_list_analyze_90= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `is_metrics_list_analyze_90` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_is_metrics_list`.`hostname` AS `hostname`,
         `daily_is_metrics_list`.`ipaddr` AS `ipaddr`,
         `daily_is_metrics_list`.`port` AS `port`,
         `daily_is_metrics_list`.`datadir` AS `datadir`,
         `daily_is_metrics_list`.`name` AS `name`,
         `daily_is_metrics_list`.`avg_count` AS `avg_count`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         (`daily_is_metrics_list`.`avg_count` - LAG(`daily_is_metrics_list`.`avg_count`) OVER `w`) AS `_diff`,
         FIRST_VALUE(`daily_is_metrics_list`.`avg_count`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_is_metrics_list`.`avg_count`) OVER `w_all` AS `_last`
  FROM `last_90_days_calendar` LEFT JOIN `daily_is_metrics_list` USING(_date)
  WINDOW `w` AS (PARTITION BY hostname, datadir, name ORDER BY _date),
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $status_list_analyze_90= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `status_list_analyze_90` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_status_list`.`hostname` AS `hostname`,
         `daily_status_list`.`ipaddr` AS `ipaddr`,
         `daily_status_list`.`port` AS `port`,
         `daily_status_list`.`datadir` AS `datadir`,
         `daily_status_list`.`variable_name` AS `variable_name`,
         `daily_status_list`.`avg_count` AS `avg_count`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         (`daily_status_list`.`avg_count` - LAG(`daily_status_list`.`avg_count`) OVER `w`) AS `_diff`,
         FIRST_VALUE(`daily_status_list`.`avg_count`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_status_list`.`avg_count`) OVER `w_all` AS `_last`
  FROM `last_90_days_calendar` LEFT JOIN `daily_status_list` USING(_date)
  WINDOW `w` AS (PARTITION BY hostname, datadir, variable_name ORDER BY _date),
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS

my $innodb_rows_read_analyze_90= << 'EOS';
CREATE SQL SECURITY INVOKER VIEW `innodb_rows_read_analyze_90` AS
  SELECT `last_90_days_calendar`.`_date` AS `_date`,
         `daily_innodb_rows_read_list`.`hostname` AS `hostname`,
         `daily_innodb_rows_read_list`.`ipaddr` AS `ipaddr`,
         `daily_innodb_rows_read_list`.`port` AS `port`,
         `daily_innodb_rows_read_list`.`datadir` AS `datadir`,
         `daily_innodb_rows_read_list`.`variable_name` AS `variable_name`,
         `daily_innodb_rows_read_list`.`avg_count` AS `avg_count`,
         (`_date` - LAG(`_date`) OVER `w`) AS `_diff_date`,
         (`daily_innodb_rows_read_list`.`avg_count` - LAG(`daily_innodb_rows_read_list`.`avg_count`) OVER `w`) AS `_diff`,
         FIRST_VALUE(`daily_innodb_rows_read_list`.`avg_count`) OVER `w_all` AS `_first`,
         LAST_VALUE(`daily_innodb_rows_read_list`.`avg_count`) OVER `w_all` AS `_last`
  FROM `last_90_days_calendar` LEFT JOIN `daily_innodb_rows_read_list` USING(_date)
  WINDOW `w` AS (PARTITION BY hostname, datadir, variable_name ORDER BY _date),
         `w_all` AS (`w` RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
EOS


sub admintool_schema
{
  return [$instance_info, $variable_info, $table_status_info,
          $grant_info, $is_innodb_metrics, $ps_digest_info,
          $ps_table_info, $slave_info, $status_info, ### 12
          $ytkit_option];
}

sub adminview_schema
{
  return [$datadir_list, $hostname_list, $version_list,
          $instance_list, $grant_list, $is_metrics_list,
          $ps_digest_list, $ps_table_list, $status_list,
          $table_status_list, $variable_list, $daily_table_row_list,
          $daily_table_latency_list, $daily_digest_latency_list, $daily_is_metrics_list, ### 15
          $daily_status_list, $daily_innodb_rows_read_list];
}

sub adminview_schema_ex
{
  ### For 8.0.11 and later.
  return [$recent_status_list, $recent_table_status_list, $last_33_days_calendar,
          $last_90_days_calendar, $table_status_list_last_month, $table_status_list_analyze_33,
          $table_status_list_analyze_90, $table_read_list_analyze_last_month, $table_read_list_analyze_90, ### 9
          $digest_list_analyze_90, $is_metrics_list_analyze_90, $status_list_analyze_90, ### 12
          $innodb_rows_read_analyze_90]; 
}


return 1;
