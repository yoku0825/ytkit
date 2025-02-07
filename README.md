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
