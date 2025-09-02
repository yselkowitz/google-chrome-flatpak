%global app_id  com.google.Chrome

Name:           google-chrome-flatpak-config
Version:        0
Release:        %autorelease
Summary:        Metadata for google-chrome flatpak

License:        Proprietary
URL:            https://www.google.com/chrome/
Source:         apply_extra.sh
Source:         chrome.sh
Source:         %{app_id}.desktop
Source:         %{app_id}.svg
Source:         %{app_id}.metainfo.xml

BuildArch:      noarch

BuildRequires:  desktop-file-utils
BuildRequires:  libappstream-glib

%description
%{summary}

%prep

%build

%install
install -D -m0755 %{S:0} %{buildroot}%{_bindir}/apply_extra
install -D -m0755 %{S:1} %{buildroot}%{_bindir}/chrome
install -D -m0644 %{S:2} %{buildroot}%{_datadir}/applications/%{app_id}.desktop
install -D -m0644 %{S:3} %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/%{app_id}.svg
install -D -m0644 %{S:4} %{buildroot}%{_metainfodir}/%{app_id}.metainfo.xml

%check
desktop-file-validate %{buildroot}%{_datadir}/applications/%{app_id}.desktop
appstream-util validate-relax --nonet %{buildroot}%{_metainfodir}/%{app_id}.metainfo.xml

%files
%{_bindir}/apply_extra
%{_bindir}/chrome
%{_datadir}/applications/%{app_id}.desktop
%{_datadir}/icons/hicolor/scalable/apps/%{app_id}.svg
%{_metainfodir}/%{app_id}.metainfo.xml

%changelog
%autochangelog
