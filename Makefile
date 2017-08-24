INSTALL = /usr/local

all: 
	@echo "make all is not supported."
	@echo "make fatpack && make fatinstall for fatpacked scripts and"
	@echo "just make install for raw bin/ and lib/ scripts."

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

fatpack: setup yt-binlog-groupby 

fatinstall:
	cp fatpack/* $(INSTALL)/bin

yt-binlog-groupby: bin/yt-binlog-groupby lib/Ytkit/BinlogGroupby.pm
	fatpack-simple bin/$@ -o fatpack/$@
