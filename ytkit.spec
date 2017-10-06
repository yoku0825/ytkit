Name:		ytkit
Version:	0.0.3
Release:	1
Summary:	ytkit is Yoku-san no Tool KIT scripts.

#Group:		
License:	GPLv2
URL:		https://github.com/yoku0825/ytkit/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
Source0:	%{name}-%{version}.tar.gz

Requires:	perl perl-DBD-MySQL
AutoReq:        no
BuildArch:      noarch
BuildRequires:  make perl perl-Test-Harness
#BuildRequires:	perl(App::FatPacker::Simple)
#BuildRequires: perl(App::cpanminus)

%define _rpmfilename %{name}-%{version}-%{release}.noarch.rpm

%description
ytkit is Yoku-san no Tool KIT for MySQL.

%prep
%setup -q

%build
%{__make} fatpack

%install
%define BINDIR %{buildroot}/usr/local/bin
%{__rm} -rf %{buildroot}
%{__mkdir_p} %{BINDIR}
%{__cp} fatpack/* %{BINDIR}

%check
%{__make} test

%files
%defattr(-, root, root, -)
/usr/local/bin

%changelog

