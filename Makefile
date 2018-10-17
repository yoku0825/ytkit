INSTALL = /usr/local

all: 
	@echo "make all is not supported."
	@echo "make fatpack && make fatinstall for fatpacked scripts and"
	@echo "make install for raw bin/ and lib/ scripts."

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

.PHONY: fatpack
fatpack: setup yt-binlog-groupby yt-healthcheck yt-wait-replication yt-collect yt-alter-progress

fatinstall:
	cp fatpack/* $(INSTALL)/bin

.PHONY: rpmbuild rpm
rpm: rpmbuild
rpmbuild:
	bash build.sh

MANDATORY_PACKAGE=lib/Ytkit/Config.pm lib/Ytkit/MySQLServer.pm

yt-binlog-groupby: bin/yt-binlog-groupby lib/Ytkit/BinlogGroupby.pm $(MANDATORY_PACKAGE)
	fatpack-simple bin/$@ -o fatpack/$@

yt-healthcheck: bin/yt-healthcheck lib/Ytkit/HealthCheck.pm $(MANDATORY_PACKAGE)
	fatpack-simple bin/$@ -o fatpack/$@

yt-wait-replication: bin/yt-wait-replication lib/Ytkit/WaitReplication.pm lib/Ytkit/HealthCheck.pm $(MANDATORY_PACKAGE)
	fatpack-simple bin/$@ -o fatpack/$@

yt-collect: bin/yt-collect lib/Ytkit/Collect.pm $(MANDATORY_PACKAGE)
	fatpack-simple bin/$@ -o fatpack/$@

yt-alter-progress: bin/yt-alter-progress lib/Ytkit/AlterProgress.pm $(MANDATORY_PACKAGE)
	fatpack-simple bin/$@ -o fatpack/$@
