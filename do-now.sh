#!/usr/bin/env bash
dpkg --add-architecture i386
apt-get update -y
apt-get -y install flex bison ncurses-dev texinfo gcc gperf patch libtool automake g++ libncurses5-dev gawk expat libexpat1-dev python-all-dev binutils-dev libgcc1:i386 bc libgnutls28-dev libcap-dev autoconf autoconf-archive libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev autopoint gettext liblzma-dev libssl-dev libz-dev

# CurrentMainPath="$(pwd)"
rm -rf .git
git clone "https://${GIT_SECRETB}@github.com/ZyCromerZ/gdrive_uploader" gdrive_uploader
chmod +x ./gdrive_uploader/run.sh

# ./build -a arm64 -s gnu -v 10 -p gz
# ./gdrive_uploader/run.sh "$(pwd)/${PACKAGE}" "keqing-drive" "ALL-COMPILED-GCC"

./build -a arm -s gnu -v 10 -p gz
./gdrive_uploader/run.sh "$(pwd)/${PACKAGE}" "keqing-drive" "ALL-COMPILED-GCC"

rm -rf *