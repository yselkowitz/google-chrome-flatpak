#!/bin/sh
bsdtar --strip-components=4 -xf *.rpm ./opt/google/chrome
rm -f *.rpm
ln -sfn google-chrome google-chrome-stable
sed -i -e '/^exec -a/s|\"\$0\"|& /app/bin/zypak-wrapper|' google-chrome
mkdir -p extensions config
for dir in native-messaging-hosts policies; do mkdir -p config/$dir; ln -s config/$dir $dir; done
ln -sf config/master_preferences .
