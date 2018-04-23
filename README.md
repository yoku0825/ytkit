# ytkit

- This is Yoku-san no Tool KIT scripts.

## yt-binlog-groupby

- mysqlbinlog summerize tool.

```
$ mysqlbinlog -vv /path/to/binlog | yt-binlog-groupby --cell=10m --group-by=time,table
binlog entries between 170720 15:10 and 170817 17:40
170720 15:10    d1.t1   2
170720 15:20    d1.t1   1
170724 14:20    mysqlslap.t1    644
170724 14:50    t1      644
170724 15:40    t1      644
170724 20:00    d1.t1   2
170724 20:00    t2      1
170814 18:20    d1.t1   1
```

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
