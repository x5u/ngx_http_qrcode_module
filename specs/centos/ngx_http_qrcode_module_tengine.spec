%define     oname   ngx_http_qrcode_module
Name:		ngx_http_qrcode_module
Version:	1.0.2
Release:	4%{?dist}
Summary:    ngx_http_qrcode_module is a an addon for Nginx to generate and serve QR code.(nginx qrcode module)

Group:	    Development/Libraries
License:	GPL
URL:        https://github.com/nginx-lover/ngx_http_qrcode_module
Source0:    ngx_http_qrcode_module-%{version}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires:  tengine-devel tengine gd-devel qrencode-devel
Requires:   tengine qrencode gd

%description
ngx_http_qrcode_module is a an addon for Nginx to generate and serve QR code.(nginx qrcode module)

%prep
%setup -q -n %{oname}

%build

%install
rm -rf %{buildroot}
mkdir -p $RPM_BUILD_ROOT/opt/tengine/modules/
/opt/tengine/sbin/dso_tool --add-module=%{_builddir}/%{oname} --dst=$RPM_BUILD_ROOT/opt/tengine/modules/

%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
/opt/tengine/modules/ngx_http_qrcode_module.so
%doc


%changelog
* Wed Jun 10 2016 detailyang <detailyang@gmail.com> - 1.0.2-4
- [Fix] use true color only need

* Wed Jun 10 2016 detailyang <detailyang@gmail.com> - 1.0.1-3
- [Feature] use true color

* Wed Jun 08 2016 detailyang <detailyang@gmail.com> - 1.0.0-2
- [Feature] add center picture
