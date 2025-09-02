# nickle is a submodule with no tags
%global commit1 0ac7f5dbf659caa8d1d45cb57e942f2bc565da1e

Name:           zypak
Version:        2024.01.17
Release:        %autorelease
Summary:        Run Chromium-based binaries in a sandboxed flatpak environment

License:        BSD-3-Clause
URL:            https://github.com/refi64/zypak
Source:         %{url}/archive/v%{version}/%{name}-%{version}.tar.gz
Source:         https://github.com/refi64/nickle/archive/%{commit1}/nickle-%{commit1}.tar.gz
# fix build with GCC 15
Patch:          https://github.com/flathub/org.electronjs.Electron2.BaseApp/blob/branch/25.08/patches/zypak/fdsdk2508.patch

BuildRequires:  gcc-c++
BuildRequires:  make
BuildRequires:  pkgconfig(libsystemd)
BuildRequires:  pkgconfig(dbus-1)

%description
Allows you to run Chromium based applications that require a sandbox in a Flatpak
environment, by using LD_PRELOAD magic and a redirection system that redirects
Chromium's sandbox to use the Flatpak sandbox. Zypak is actively used by the
majority of the Electron and Chrome-based Flatpaks on Flathub.


%prep
%autosetup -a 1 -p1
rmdir nickle && mv nickle-%{commit1} nickle
sed -i -e 's|FLATPAK_DEST)/lib|&64|' Makefile
sed -i -e 's|/lib"|/lib64"|' zypak-wrapper.sh


%build
%make_build


%install
mkdir -p %{buildroot}%{_bindir} %{buildroot}%{_libdir}
%make_install FLATPAK_DEST=%{buildroot}%{_prefix}
ln -sf zypak-wrapper.sh %{buildroot}%{_bindir}/zypak-wrapper


%files
%license LICENSE
%doc README.md
%{_bindir}/zypak-helper
%{_bindir}/zypak-sandbox
%{_bindir}/zypak-wrapper
%{_bindir}/zypak-wrapper.sh
%{_libdir}/libzypak-preload-*.so


%changelog
%autochangelog
