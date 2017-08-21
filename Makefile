all: setup yt-binlog-groupby

clean:
	rm -rf extlib fatpack

setup: 
	mkdir -p extlib fatpack
	cpanm -f App::FatPacker::Simple
	cpanm --installdeps -lextlib .


yt-binlog-groupby: bin/yt-binlog-groupby lib/Ytkit/BinlogGroupby.pm
	fatpack-simple bin/yt-binlog-groupby -o fatpack/yt-binlog-groupby

install: all
	cp fatpack/* /usr/local/bin/

test:
	prove
