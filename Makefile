INSTALL = /usr/local

all: setup fatpack

.PHONY: clean
clean:
	rm -rf extlib fatpack

.PHONY: setup
setup: 
	mkdir -p extlib fatpack
	cpanm -f App::FatPacker::Simple
	cpanm --installdeps -lextlib .

.PHONY: install
install:
	cp bin/* $(INSTALL)/bin/
	cp lib/* $(INSTALL)/share/perl5/

.PHONY: test
test:
	prove

fatpack: yt-binlog-groupby

fatinstall:
	cp fatpack/* $(INSTALL)/bin

yt-binlog-groupby: bin/yt-binlog-groupby lib/Ytkit/BinlogGroupby.pm
	fatpack-simple bin/$@ -o fatpack/$@


