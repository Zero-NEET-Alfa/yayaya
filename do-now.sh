#!/usr/bin/env bash
dpkg --add-architecture i386
apt-get update -y
apt-get -y install flex bison ncurses-dev texinfo gcc gperf patch libtool automake g++ libncurses5-dev gawk expat libexpat1-dev python-all-dev binutils-dev libgcc1:i386 bc libgnutls28-dev libcap-dev autoconf autoconf-archive libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev autopoint gettext liblzma-dev libssl-dev libz-dev

# CurrentMainPath="$(pwd)"
rm -rf .git
git clone "https://${GIT_SECRET}@github.com/ZyCromerZ/gdrive_uploader" gdrive_uploader
chmod +x ./gdrive_uploader/run.sh

./build -a arm -s gnu -v 11 -p gz
FILE="$(pwd)/arm-linux-gnueabi-11.x-gnu-$(date +%Y%m%d).tar.gz"
cd gdrive_uploader
. run.sh "$FILE" "gcc-drive" "ALL-COMPILED-GCC"
cd ..

rm -rf *