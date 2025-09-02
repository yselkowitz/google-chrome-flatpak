#! /bin/bash

set -e

pushd rpms/zypak
spectool -g zypak.spec
popd

exec flatpak-module build-rpms-local ./rpms/google-chrome-flatpak-config/ ./rpms/zypak/
