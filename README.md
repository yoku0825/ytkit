# ytkit

- This is Yoku-san no Tool KIT scripts.

# tool overview

|         tool         |                        works                        |
| -------------------- | --------------------------------------------------- |
| yt-alter-progress    | Observe ALTER TABLE progress                        |
| yt-binlog-groupby    | Aggregate mysqlbinlog output                        |
| yt-bulk-delete       | DELETE all rows in the table                        |
| yt-collect           | Collect SHOW STATUS and more data source            |
| yt-healthcheck       | Nagios compatible observe script                    |
| yt-print-information | Dump information for diagnostic                     |
| yt-repl-topology     | Show replication topology by human-readable or JSON |
| yt-wait-replication  | Wait until Seconds_Behind_Source < threshold        |


## yt-alter-progress

- You need to launch this before starting ALTER TABLE, or a progress is not shown (this maybe performance_schema's limitation)
- Display progress InnoDB ALTER TABLE (need >= 5.7.6)

|              option_name              |            default             |                                                     text                                                      |
| ------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| --host=value, -h=value                | "localhost"                    | MySQL host                                                                                                    |
| --port=value, -P=value                | 3306                           | MySQL port                                                                                                    |
| --user=value, -u=value                | (as same as OS user)           | MySQL account using for connection and checking (need REPLICATION CLIENT, PROCESSLIST and global SELECT priv) |
| --password=value, -p=value            | ""                             | Password for the user specified by --user                                                                     |
| --ask_pass, --ask_password, --askpass | false                          | Ask --password by prompt                                                                                      |
| --socket=value, -S=value              | (depends on libmysqlclient.so) | Path to mysql.sock (this parameter is used when --host=localhost)                                             |
| --interval=value, -i=value            | 10                             | Sleeping duration for each SELECT                                                                             |
| --quiet, --silent, -q, -s             | false                          | No output any messages                                                                                        |
| --verbose, -v                         | false                          | Verbose output mode                                                                                           |
| --help, --usage                       | false                          | print help message                                                                                            |
| --version, -V                         | false                          | Show ytkit version                                                                                            |
| --timeout=value                       | 1                              | Seconds before timeout (Set into read_timeout, write_timeout, connect_timeout)                                |
| --debug                               | false                          | Set debug output                                                                                              |


### Example

- Values are `percentage of work_completed / work_estimated`, `estimated time calculated by percentage`, `elapsed time from starting ALTER TABLE`, `stage information`, `ALTER TABLE statement` .

```
$ yt-alter-progress -h127.0.0.1 -uroot -p'password' -i 100
..
| [ 38.31% ( 1610 sec | 1000 sec) ] stage/innodb/alter table (read PK and internal sort) : OPTIMIZE TABLE t1 |
| [ 61.58% ( 1248 sec | 2000 sec) ] stage/innodb/alter table (merge sort) : OPTIMIZE TABLE t1                |
| [ 100.00% ( 0 sec   | 2410 sec) ] stage/innodb/alter table (insert) : OPTIMIZE TABLE t1                    |
| [ 100.00% ( 0 sec   | 2420 sec) ] stage/innodb/alter table (flush) : OPTIMIZE TABLE t1                     |
| [ 100.00% ( 0 sec   | 2440 sec) ] stage/innodb/alter table (log apply table) : OPTIMIZE TABLE t1           |
| [ 100.00% ( 0 sec   | 2450 sec) ] stage/innodb/alter table (log apply table) : OPTIMIZE TABLE t1           |
| [ 100.00% ( 0 sec   | 2460 sec) ] stage/innodb/alter table (log apply table) : OPTIMIZE TABLE t1           |
| [ 100.00% ( 0 sec   | 2470 sec) ] stage/innodb/alter table (log apply table) : OPTIMIZE TABLE t1           |
```

- Whole sample logs are [yt\-alter\-progress](https://gist.github.com/yoku0825/f09f7c50bf57a1935368639112761310)

## yt-binlog-groupby

- mysqlbinlog summerize tool like a `SELECT COUNT(*) GROUP BY ..`
- pass `mysqlbinlog -vv` 's output by pipe

|   option_name   | default |                                                                                                                     text                                                                                                                     |
| --------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| --cell, -c      | 10m     | Time aggregation period when `--group-by` includes "time". Variations are s, second, 1s, 10s, m, minute, 1m, 10m, h, hour, 1h, d, 1d                                                                                                         |
| --group-by, -g  | time    | How aggregate the `mysqlbinlog -vv` 's output. "time", "table", "statement", "time,table", "time,statement", "table,statement", "all", "time,table,statement" (same as "all"),  "all,exec", "exec,time,table,statement" (same as "all,exec") |
| --output, -o    | tsv     | ~How to print aggregated output~ This feature is breaking. See [Issue #54](https://github.com/yoku0825/ytkit/issues/54)                                                                                                                      |
| --verbose, -v   | false   | Verbose output mode                                                                                                                                                                                                                          |
| --help, --usage | false   | print help message                                                                                                                                                                                                                           |
| --version, -V   | false   | Show ytkit version                                                                                                                                                                                                                           |
| --debug         | false   | Set debug output                                                                                                                                                                                                                             |


### Example

```
$ mysqlbinlog -vv bin.000017 | yt-binlog-groupby --cell=10m --group-by=time,table
240821 15:20    d1.t1   2
240821 15:20    mysql.user      1
240822 11:00    d1.t1   1000000
```

```
$ mysqlbinlog -vv bin.000022 | yt-binlog-groupby --cell=10s --group-by=time,table,statement
240831 22:10:40 mysqlslap.t1    INSERT  110
240831 22:10:50 mysqlslap.t1    INSERT  220
240831 22:11:20 mysqlslap.t1    INSERT  110
240831 22:11:40 mysqlslap.t1    INSERT  99
240831 22:11:40 mysqlslap.t1    UPDATE  1980
```

## yt-bulk-delete

- Only one purpose that "deleting all rows in target table" little by little as soon as possible.
  - Original mode: DELETE at ReplicationSource node, observe all Replica's `Seconds_Behind_Master` amd handling an accell or a break.
  - Parallel mode: sql_log_bin=OFFed DELETE at Source and All Replicas(replicas has been discovered automatically)
- To more safety when unnecessay table to drop, empty table seems safety&lightly DROP TABLE.


|                        option_name                        |            default             |                                                                                                                                                                 text                                                                                                                                                                 |
| --------------------------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| --host=value, -h=value                                    | "localhost"                    | MySQL host                                                                                                                                                                                                                                                                                                                           |
| --port=value, -P=value                                    | 3306                           | MySQL port                                                                                                                                                                                                                                                                                                                           |
| --user=value, -u=value                                    | (as same as OS user)           | MySQL account using for connection and checking (need REPLICATION CLIENT, PROCESSLIST and global SELECT priv)                                                                                                                                                                                                                        |
| --password=value, -p=value                                | ""                             | Password for the user specified by --user                                                                                                                                                                                                                                                                                            |
| --ask_pass, --ask_password, --askpass                     | false                          | Ask --password by prompt                                                                                                                                                                                                                                                                                                             |
| --socket=value, -S=value                                  | (depends on libmysqlclient.so) | Path to mysql.sock (this parameter is used when --host=localhost)                                                                                                                                                                                                                                                                    |
| --interval=value, -i=value                                | 10                             | Sleeping duration for each SELECT                                                                                                                                                                                                                                                                                                    |
| --quiet, --silent, -q, -s                                 | false                          | No output any messages                                                                                                                                                                                                                                                                                                               |
| --verbose, -v                                             | false                          | Verbose output mode                                                                                                                                                                                                                                                                                                                  |
| --help, --usage                                           | false                          | print help message                                                                                                                                                                                                                                                                                                                   |
| --version, -V                                             | false                          | Show ytkit version                                                                                                                                                                                                                                                                                                                   |
| --timeout=value                                           | 1                              | Seconds before timeout (Set into read_timeout, write_timeout, connect_timeout)                                                                                                                                                                                                                                                       |
| --debug                                                   | false                          | Set debug output                                                                                                                                                                                                                                                                                                                     |
| --accelerating_throttling=value           F               | 2                              | How many times DELETE succeed smoothly, before accelerating LIMIT Clause.                                                                                                                                                                                                                                                            |
| --delete_row_multiplier=value                             | 1.1                            | Change LIMIT Clause dinamically by multiplying this number. When script detects 'Smooth', next LIMIT Caluse is current_limit * delete_row_multiplier. When script detects 'Busy', next LIMIT Clause is current_limit / delete_row_multiplier.If you specify --delete_row_multiplier=1, the script doesn't change LIMIT Clause value. |
| --delete_row_start=value,  --delete_row_start_count=value | 1000                           | Start value of LIMIT Clause (DELETE FROM `<table>` LIMIT ?)                                                                                                                                                                                                                                                                          |
| --force, -f                                               | false                          | Force execute even if the table doesn't have Primary Key.                                                                                                                                                                                                                                                                            |
| --table=value                                             | ""                             | (Mandatory) Target table name. Should be specified `<database>.<table>`                                                                                                                                                                                                                                                              |
| --timer_wait=value                                        | 1                              | Seconds which allowed each iteration                                                                  - Execution time of DELETE > --timer_wait, start throttling.                                                                                                                                                                   |

- Throttling mechanism
  - Waiting time of waiting while Seconds_Behind_Master < --timer_wait, start throttling. 
  - Execution time of DELETE < --timer_wait keeps --accelerating_throttling times, start accelerating.
  - Seconds_Behind_Master > --timer_wait, script sleeping.
  - New throttled/accelerated `LIMIT` calculated by --delete_row_multiplier


## yt-healthcheck

- Healthcheck script for Nagios compatibility interface.

```
$ yt-healthcheck -h 172.17.0.1 -u user_name -p'password' -P 3306
```

|                  option_name                  |            default             |                                                                     text                                                                      |
| --------------------------------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| --host=value, -h=value                        | "localhost"                    | MySQL host                                                                                                                                    |
| --port=value, -P=value                        | 3306                           | MySQL port                                                                                                                                    |
| --user=value, -u=value                        | (as same as OS user)           | MySQL account using for connection and checking (need REPLICATION CLIENT, PROCESSLIST and global SELECT priv)                                 |
| --password=value, -p=value                    | ""                             | Password for the user specified by --user                                                                                                     |
| --ask_pass, --ask_password, --askpass         | false                          | Ask --password by prompt                                                                                                                      |
| --socket=value, -S=value                      | (depends on libmysqlclient.so) | Path to mysql.sock (this parameter is used when --host=localhost)                                                                             |
| --quiet, --silent, -q, -s                     | false                          | No output any messages                                                                                                                        |
| --verbose, -v                                 | false                          | Verbose output mode                                                                                                                           |
| --help, --usage                               | false                          | print help message                                                                                                                            |
| --version, -V                                 | false                          | Show ytkit version                                                                                                                            |
| --timeout=value                               | 1                              | Seconds before timeout (Set into read_timeout, write_timeout, connect_timeout)                                                                |
| --debug                                       | false                          | Set debug output                                                                                                                              |
| --dump_detail                                 | "" (OFF when empty)            | When result is NOT NAGIOS_OK,  output results of "SHOW PROCESSLIST", "SHOW SLAVE STATUS" and "SHOW ENGINE INNODB STATUS"" into specified file |
| --autoinc_usage_enable                        | 1 (ON)                         | Enable "auto_increment checking"                                                                                                              |
| --autoinc_usage_warning                       | 50                             | Warning threshold for "current_auto_increment_value / datatype_max"(percentage)                                                               |
| --autoinc_usage_critical                      | 90                             | Critical threshold for "current_auto_increment_value / datatype_max"(percentage)                                                              |
| --connection_count_enable                     | 1 (ON)                         | Enable "connection count checking"                                                                                                            |
| --connection_count_warning                    | 70                             | Warning threshold for "Threads_connected / max_connections"(percentage)                                                                       |
| --connection_count_critical                   | 95                             | Critical threshold for "Threads_connected / max_connections"(percentage)                                                                      |
| --threads_running_enable                      | 1 (ON)                         | Enable "threads_running count checking"                                                                                                            |
| --threads_running_warning                     | 10                             | Warning threshold for "Threads_running"                                                                      |
| --threads_running_critical                    | 20                             | Critical threshold for "Threads_running"                                                                      |

| --deadlock_enable                             | 0 (OFF)                        | Enable "deadlock detection checking"                                                                                                          |
| --deadlock_warning                            | 300                            | Warning threshold for LATEST DETECTED DEADLOCK time (seconds)                                                                                 |
| --deadlock_critical                           | 1                              | Critical threshold for LATEST DETECTED DEADLOCK time (seconds)                                                                                |
| --fabric_faulty                               | ignore                         | (mikasafabric will be removed future release) Reporting level when mikasafabric has faulty-state managed server                               |
| --fabric_fd_enable                            | 1 (ON)                         | (mikasafabric will be removed future release) Enable "open fds checking"                                                                      |
| --fabric_fd_warning                           | 50                             | (mikasafabric will be removed future release)  Warning threshold for "current_fd / max_fd"(percentage)                                        |
| --fabric_fd_critical                          | 70                             | (mikasafabric will be removed future release) Critical threshold for "current_fd / max_fd"(percentage)                                        |
| --fabric_no_candidate                         | critical                       | (mikasafabric will be removed future release) Reporting level when managed group has no Candidate-Slave server                                |
| --group_replication_lag_enable                | 1 (ON)                         | Enable "Group Replication lag checking" (both "Seconds" and "Transactions")                                                                   |
| --group_replication_lag_seconds_warning       | 5                              | Warning threshold for Group Replication Lag (seconds)                                                                                         |
| --group_replication_lag_seconds_critical      | 30                             | Critical threshold for Group Replication Lag (seconds)                                                                                        |
|                                               |                                |                                                                                                                                               |
| --group_replication_lag_transactions_warning  | 100                            | Warning threshold for Group Replication Lag (queued transactions)                                                                             |
| --group_replication_lag_transactions_critical | 10000                          | Critical threshold for Group Replication Lag (queued transactions)                                                                            |
| --gtid_hole_enable                            | 0 (OFF)                        | Enable "GTID hole checking"                                                                                                                   |
| --history_list_enable                         | 0 (OFF)                        | Enable "History List Length checking"                                                                                                         |
| --history_list_warning                        | 100000                         | Warning threshold for trx_rseg_history_len                                                                                                    |
| --history_list_critical                       | 500000                         | Critical threshold for trx_rseg_history_len                                                                                                   |
| --long_query_enable                           | 1 (ON)                         | Enable "long-query" checking                                                                                                                  |
| --long_query_warning                          | 5                              | Warning threshold for "SHOW PROCESSLIST"'s "Time"(seconds)                                                                                    |
| --long_query_critical                         | 100                            | Critical threshold for "SHOW PROCESSLIST"'s "Time"(seconds)                                                                                   |
| --long_query_exclude_host                     | "" (Empty)                     | Specify to ignore values for "SHOW PROCESSLIST"'s "Host". When first-match them, doesn't raise WARNING or CRITICAL(always OK)                 |
| --long_query_exclude_user                     | "" (Empty)                     | Specify to ignore values for "SHOW PROCESSLIST"'s "User". When first-match them, doesn't raise WARNING or CRITICAL(always OK)                 |
| --long_query_exclude_query                    | "" (Empty)                     | Specify to ignore values for "SHOW PROCESSLIST"'s "Info"(SQL statement) When first-match them, doesn't raise WARNING or CRITICAL(always OK)   |
| --long_query_min_warning_thread               | 1                              | Don't return NAGIOS_WARNING when threads which is over long-query-warning                                                                     |
| are less than long-query-min-warning-thread   |                                |                                                                                                                                               |
| --long_query_min_critical_thread              | 1                              | Don't return NAGIOS_WARNING when threads which is over long-query-warning are less than long-query-min-warning-thread                         |
| --role                                        | auto                           | Specify the combination of What "checkings" have to be checked                                                                                |
| --slave_status_enable                         | 1 (ON)                         | Enable "SHOW SLAVE STATUS checking"                                                                                                           |
| --slave_status_warning                        | 5                              | Warning threshold for "Seconds_Behind_Master"(seconds)                                                                                        |
| --slave_status_critical                       | 30                             | Critical threshold for "Seconds_Behind_Master"(seconds)                                                                                       |
| --uptime_enable                               | 1 (ON)                         | Enable "uptime checking"                                                                                                                      |
| --uptime_warning                              | 300                            | Warning threshold for Uptime(seconds)                                                                                                         |
| --uptime_critical                             | 300                            | Critical threshold for Uptime(seconds)                                                                                                        |





### Checkings

- auto_increment checking
  - Calculate and alert auto_increment usage by [Ytkit::MySQLServer::select_autoinc_usage](https://github.com/yoku0825/ytkit/blob/master/lib/Ytkit/MySQLServer.pm)

```
### Example
CRITICAL on localhost.localdomain: table d1.t1 uses auto_increment column num 95.00%(2040109466/2147483648)
```

- connection count checking
  - Calculate `Threads_connected / Max_connections` and alert.

```
### Example
WARNING on localhost.localdomain: Caution for too many connections: "93.38(141/151)"   (master)
```

- deadlock detection checking
  - Calculate `NOW() - time of LATEST DETECTED DEADLOCK` and alert.

```
### Example
WARNING on localhost.localdomain: LATEST DETECTED DEADLOCK has occurred at Mon Jun 30 15:59:50 2025 (master)
```

- open fds checking (mikasafabric only)
  - Count Open File Descriptors by [mikasafabric manage openfds](https://github.com/gmo-media/mikasafabric/commit/7425fd962885384c9b4e0a245b1063a9bd28ff1d)

- Group Replication lag checkings
  - `queued transactions` means `performance_schema.replication_group_member_stats.count_transactions_remote_in_applier_queue` exposed by [Ytkit::MySQLServer::replication_group_member_stats](https://github.com/yoku0825/ytkit/blob/master/lib/Ytkit/MySQLServer.pm)
  - `seconds` mean `performance_schema.replication_applier_status_by_worker.TIMESTAMPDIFF(SECOND, applying_transaction_original_commit_timestamp, NOW(6))` exporsed by [Ytkit::MySQLServer::replication_applier_status](https://github.com/yoku0825/ytkit/blob/master/lib/Ytkit/MySQLServer.pm)

```
### Example
WARNING on node2: 3144 transactions are queued in Group Replication.  (group_replication-SECONDARY)
```

- GTID hole checking
  - Check `GTID is completely consecutive or not` 
    - This check always fails when Group Replication Multi-Primary mode.
    - And sometimes false-passive failing under Multi-Thread Applier
  - This check should be deprecated

- History List Length checking
  - Check `trx_rseg_history_len` from `information_schema.innodb_metrics` exporsed by [Ytkit::MySQLServer::history_list_length](https://github.com/yoku0825/ytkit/blob/master/lib/Ytkit/MySQLServer.pm)

```
### Example
WARNING on localhost.localdomain: trx_rseg_history_len is 131072 (master)
```

- long-query checking
  - Check based on `SHOW PROCESSLIST` 's `Time` column
  - If `User` is included in `--long_query_exclude_user`, ignore.
  - If `Host` is included in `--long_query_exclude_host`, ignore.
  - If `Query` like `--long_query_exclude_query`, ignore.
  - If `Time` is less than `--long_query_warning`, ignore.
  - If `Time` is grater equal than `--long_query_warning` or `--long_query_critial`, count-up queries.
  - If counted-uped queries are greater than `--long_query_min_warning_thread` or `--long_query_min_critical_thread`, alerting.

- SHOW SLAVE STATUS checking
  - Alert when I/O Thread or SQL Thread are not running.
  - Alert when Seconds_Behind_Master is greater than `--slave_status_warning` or `--slave_status_critical` .

- Uptime checking
  - Alert when `Uptime` is less than `--uptime_warning` or `--uptime_critical`


## yt-wait-replication

- Wait for `Seconds_Behind_Master < --seconds-behind-master` during `--timeout` secs.

```
$ yt-wait-replication -h 172.17.0.1 -u user_name -p'password' -P 3306 --seconds-behind-master=5 --timeout=3600
```

## yt-collect

- Getting statistics and write some formats.

```
$ yt-collect -h 172.17.0.1 -u user_name -p'password' -P 3306 --iteration=60 --interval=60 --table_size-enable=1 --output=sql
```

## yt-repl-topology

- Display topology of Asynchronous replication

  - Search replica and source recursively.

```
$ yt-repl-topology -h127.0.0.1 -uroot -p'passwd'
Base_source:3306 => Replica1:3306
Base_source:3306 => Replica2:3306
Base_source:3306 => Intermidiate:3306
Circular:3306 => Base_source:3306
Intermidiate:3306 => Cascade_Replica1:3306
Intermidiate:3306 => Cascade_Replica2:3306
Intermidiate:3306 => Cascade_Replica3:3306
```

# Installation

## Install by rpm

- Download from [Releases](https://github.com/yoku0825/ytkit/releases) page.
  - rpm will be provided only when tag is updated.

```
$ sudo yum install -y https://github.com/yoku0825/ytkit/releases/download/0.0.10/ytkit-0.0.10-1.noarch.rpm
```

## Install as is

- Clone this repository and setup modules from cpanfile.

```
$ git clone https://github.com/yoku0825/ytkit.git
$ cd ytkit
$ cpanm --installdeps .
$ sudo make install
```

## Using without installation

- Clone this repository and setup modules from cpanfile, run script under bin directory.

```
$ git clone https://github.com/yoku0825/ytkit.git
$ cd ytkit
$ cpanm --installdeps .
```

## Install as fatpacked script

- Clone this repository and use `make fatinstall`

```
$ git clone https://github.com/yoku0825/ytkit.git
$ cd ytkit
$ make fatpack
$ sudo make fatinstall
```

# License

- GPLv2.
