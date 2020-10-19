Name:		ytkit
Version:	0.4.0
Release:	6
Summary:	ytkit is Yoku-san no Tool KIT scripts.

#Group:		
License:	GPLv2
URL:		https://github.com/yoku0825/ytkit/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
Source0:	%{name}-%{version}.tar.gz

Requires:	perl 
Requires:       perl(DBD::mysql) perl(Time::Piece) perl(Carp) perl(JSON) perl(Term::ReadKey) perl(Data::Dumper)
AutoReq:        no
BuildArch:      noarch
BuildRequires:  make perl
BuildRequires:  perl(Test::Harness) perl(Test::MockTime) perl(Clone)

%define _rpmfilename %{name}-%{version}-%{release}.noarch.rpm

%description
ytkit is Yoku-san no Tool KIT for MySQL.

%prep
%setup -q

%build

%install
%define BINDIR %{buildroot}/usr/local/bin
%define LIBDIR %{buildroot}/%{perl_sitelib}
%{__rm} -rf %{buildroot}
%{__mkdir_p} %{BINDIR}
%{__cp} bin/* %{BINDIR}
%{__mkdir_p} %{LIBDIR}
%{__cp} -r lib/* %{LIBDIR}

%check
%{__make} test

%files
%defattr(-, root, root, -)
/usr/local/bin
%{perl_sitelib}

%changelog

