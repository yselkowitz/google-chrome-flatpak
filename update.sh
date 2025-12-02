#! /bin/sh

set -eu

v=$1
url=https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-${v}-1.x86_64.rpm
f=${url##*/}

[ -f $f ] || wget $url
sha256=$(sha256sum $f | cut -d' ' -f1)
size=$(du -sb $f | cut -f1)

URL="$url" SHA256="$sha256" SIZE="$size" \
yq -I 4 -i '
  .flatpak.extra-data[0].url = strenv(URL) |
  .flatpak.extra-data[0].sha256 = strenv(SHA256) |
  .flatpak.extra-data[0].size = env(SIZE)' \
  container.yaml

git commit -am $v
exec flatpak-module build-container-local --install
