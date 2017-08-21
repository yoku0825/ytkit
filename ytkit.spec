Name:		ytkit
Version:	0.0.1
Release:	1%{?dist}
Summary:	ytkit is Yoku-san no Tool KIT scripts.

#Group:		
License:	GPLv2
URL:		https://github.com/yoku0825/ytkit
Source0:	ytkit-%{version}.tar.gz

Requires:	perl
AutoReq:        no
BuildArch:      noarch
#BuildRequires:	App::FatPacker::Simple App::cpanminus

%description
ytkit is Yoku-san no Tool KIT for MySQL.

%prep
%setup -q

%build
prove
%{__make} clean
%{__make} all

%install
%define BINDIR %{buildroot}/usr/local/bin
rm -rf %{buildroot}
mkdir -p %{BINDIR}
cp fatpack/* %{BINDIR}

%files
%defattr(-, root, root, -)
/usr/local/bin

%changelog

