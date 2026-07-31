#! /bin/sh

set -eu

b=44


cat > container.yaml <<_EOF
platforms:
    only:
        - x86_64
flatpak:
    id: com.google.Chrome
    branch: stable
    runtime-name: flatpak-runtime
    runtime-version: f44
    name: google-chrome
    tags: [proprietary]
    packages:
        #- dconf
        - google-chrome-flatpak-config
        - zypak
    command: chrome
    extra-data:
_EOF

v=$1

for arch in x86_64; do
  url=https://dl.google.com/linux/chrome/rpm/stable/${arch}/google-chrome-stable-${v}-1.${arch}.rpm
  f=${url##*/}
  [ -f ${f} ] || curl -LO ${url}
  sha256=$(sha256sum $f | awk '{print $1}')
  size=$(du -b $f | awk '{print $1}')

cat >> container.yaml <<_EOF
        - filename: ${f}
          url: ${url}
          sha256: ${sha256}
          size: ${size}
          only-arches:
              - ${arch}
_EOF
done

cat >> container.yaml <<_EOF
    finish-args: |-
        --device=all
        --share=ipc
        --share=network
        --socket=cups
        --socket=pcsc
        --socket=pulseaudio
        --socket=x11
        --socket=wayland
        --require-version=1.8.2
        --system-talk-name=org.bluez
        --system-talk-name=org.freedesktop.Avahi
        --system-talk-name=org.freedesktop.UPower
        --talk-name=org.cinnamon.ScreenSaver
        --talk-name=org.freedesktop.FileManager1
        --talk-name=org.freedesktop.Notifications
        --talk-name=org.freedesktop.ScreenSaver
        --talk-name=org.freedesktop.secrets
        --talk-name=org.gnome.ScreenSaver
        --talk-name=org.gnome.SessionManager
        --talk-name=org.kde.StatusNotifierWatcher
        --talk-name=org.kde.kwalletd5
        --talk-name=org.kde.kwalletd6
        --talk-name=org.mate.ScreenSaver
        --talk-name=org.xfce.ScreenSaver
        --own-name=org.mpris.MediaPlayer2.chromium.*
        --filesystem=/run/.heim_org.h5l.kcm-socket
        --filesystem=host-etc
        --filesystem=xdg-run/pipewire-0:ro
        --filesystem=xdg-documents
        --filesystem=xdg-download
        --filesystem=xdg-music
        --filesystem=xdg-videos
        --filesystem=xdg-pictures
        --filesystem=~/.config/kioslaverc
    #        --env=GTK_PATH=/app/lib64/gtkmodules
    #        --filesystem=xdg-run/dconf
    #        --filesystem=~/.config/dconf:ro
    #        --talk-name=ca.desrt.dconf
    #        --env=DCONF_USER_CONFIG_DIR=.config/dconf
    #        --env=GIO_EXTRA_MODULES=/app/lib64/gio/modules
    #        --env=GSETTINGS_BACKEND=dconf
_EOF

git commit -am $v
exec flatpak-module build-container-local --install
