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
$ yt-healthcheck -h 172.17.0.1 -u user_name -p password -P 3306
```

# Installation

- Clone this repository and setup modules from cpanfile.

```
$ git clone https://github.com/yoku0825/ytkit.git
$ cd ytkit
$ cpanm --installdeps .
$ make fatpack
$ sudo make fatinstall
```

# License

- GPLv2.
