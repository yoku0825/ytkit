Name:		ytkit
Version:	0.0.1
Release:	3
Summary:	ytkit is Yoku-san no Tool KIT scripts.

#Group:		
License:	GPLv2
URL:		https://github.com/yoku0825/ytkit/releases/tag/%{version}/
Source0:	ytkit-%{version}.tar.gz

Requires:	perl
AutoReq:        no
BuildArch:      noarch
BuildRequires:  make perl perl-Test-Harness
#BuildRequires:	perl(App::FatPacker::Simple)
#BuildRequires: perl(App::cpanminus)

%define _rpmfilename %{name}-%{version}.noarch.rpm

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

