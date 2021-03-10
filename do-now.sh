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

GCCType="arm-linux-gnueabi"
if [[ -d "${GCCType}" ]] && [[ -e "${GCCType}/bin/${GCCType}-gcc" ]];then
    GCCVer="$(./${GCCType}/bin/${GCCType}-gcc --version | head -n 1)"
    GCCLink="https://gcc-drive.zyc-files.workers.dev/0:/${GCCType}-11.x-gnu-$(date +%Y%m%d).tar.gz"
    curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001150624898" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="New Toolchain Already Builded boy%0ADate : <code>$(date +"%Y-%m-%d")</code>%0A<code> --- Detail Info About it --- </code>%0AGCC version : <code>${GCCVer}</code>%0ABINUTILS version : <code>$(cat ".BINUTILS.versionNya")</code>%0AGMP version : <code>$(cat ".GMP.versionNya")</code>%0AMPFR version : <code>$(cat ".MPFR.versionNya")</code>%0AMPC version : <code>$(cat ".MPC.versionNya")</code>%0AISL version : <code>$(cat ".ISL.versionNya")</code>%0AGCLIB version : <code>$(cat ".GCLIB.versionNya")</code>%0A%0ALink downloads : <code>${GCCLink}</code>%0A%0A-- uWu --"
fi

rm -rf *