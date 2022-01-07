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
	cpanm App::FatPacker::Simple
	cpanm --installdeps -lextlib .

.PHONY: install
install:
	cp bin/* $(INSTALL)/bin/
	cp -r lib/* $(INSTALL)/share/perl5/

.PHONY: test
test:
	prove

.PHONY: fatpack
fatpack: setup yt-alter-progress yt-binlog-groupby yt-collect yt-data-dumper yt-healthcheck yt-innostat yt-querystat yt-resource-collector yt-wait-replication yt-print-information yt-extract yt-rename-database yt-config

fatinstall:
	cp fatpack/* $(INSTALL)/bin

.PHONY: rpmbuild rpm
rpm: rpmbuild
rpmbuild:
	bash build.sh

define fatpack
	rm -rf fatlib
	mkdir fatlib
	cp $(filter %.pm,$^) fatlib/
	fatpack-simple bin/$@ -o fatpack/$@ -d fatlib
	rm -r fatlib
endef

MANDATORY_PACKAGE=lib/Ytkit/Config.pm lib/Ytkit/MySQLServer.pm lib/Ytkit/Config/File.pm lib/Ytkit/Config/Option.pm lib/Ytkit/IO.pm

yt-alter-progress: bin/yt-alter-progress lib/Ytkit/AlterProgress.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-binlog-groupby: bin/yt-binlog-groupby lib/Ytkit/BinlogGroupby.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-collect: bin/yt-collect lib/Ytkit/Collect.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-data-dumper: bin/yt-data-dumper $(MANDATORY_PACKAGE)
	$(fatpack)

yt-healthcheck: bin/yt-healthcheck lib/Ytkit/HealthCheck.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-innostat: bin/yt-innostat lib/Ytkit/Collect.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-querystat: bin/yt-querystat lib/Ytkit/Collect.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-resource-collector: bin/yt-resource-collector lib/Ytkit/Collect.pm lib/Ytkit/ResourceCollector.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-wait-replication: bin/yt-wait-replication lib/Ytkit/WaitReplication.pm lib/Ytkit/HealthCheck.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-print-information: bin/yt-print-information $(MANDATORY_PACKAGE)
	$(fatpack)

yt-extract: bin/yt-extract lib/Ytkit/Extract.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-rename-database: bin/yt-rename-database lib/Ytkit/RenameDatabase.pm $(MANDATORY_PACKAGE)
	$(fatpack)

yt-config: bin/yt-config lib/Ytkit/Config/CLI.pm $(MANDATORY_PACKAGE)
	$(fatpack)
