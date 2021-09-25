#!/usr/bin/env bash
# shellcheck disable=SC1117
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2021 ZyCromerZ
#
dpkg --add-architecture i386
apt-get update -y
apt-get -y install flex bison ncurses-dev texinfo gcc gperf patch libtool automake g++ libncurses5-dev gawk expat libexpat1-dev python-all-dev binutils-dev libgcc1:i386 bc libgnutls28-dev libcap-dev autoconf autoconf-archive libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev autopoint gettext liblzma-dev libssl-dev libz-dev
BuildDate="$(date +%Y-%m-%d)"
git config --global user.email "neetroid97@gmail.com"
git config --global user.name "ZyCromerZ"
CURRENTMAINPATH="$(pwd)"
rm -rf .git
GCCType="${1}"
GCCVersion="${2}"
if [[ -z "${1}" ]] || [[ -z "${2}" ]] || [[ -z "${3}" ]];then
    echo "something is missing, fix it first"
    exit -1;
fi

./build -a "${3}" -s gnu -v ${GCCVersion} -p gz
FILE="$(pwd)/$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d).tar.gz"
# cd gdrive_uploader

if [[ -z "${4}" ]] || [[ "${4}" != "nozip" ]];then
    mkdir uhuyFiles
    cd uhuyFiles
    git init
    git checkout -b $GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)
    cp -af ../$GCCType/readme.md readme.md
    echo '' >> readme.md
    echo "link downloads: <a href='https://github.com/ZyCromerZ/compiled-gcc/releases/download/v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)/$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d).tar.gz'>here</a>" >> readme.md
    git add . && git commit -s -m "upload $GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)"
    git tag v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)
    git push -f https://${GIT_SECRET}@github.com/ZyCromerZ/compiled-gcc v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)
    git push -f https://${GIT_SECRET}@github.com/ZyCromerZ/compiled-gcc $GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)
    cd $CURRENTMAINPATH

    chmod +x github-release
    ./github-release release \
        --user ZyCromerZ \
        --repo compiled-gcc \
        --tag v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d) \
        --name "$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)" \
        --description "compiled date: ${BuildDate} "

    ./github-release upload \
        --user ZyCromerZ \
        --repo compiled-gcc \
        --tag v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d) \
        --name "$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d).tar.gz" \
        --file "$FILE"
fi

if [[ -d "${GCCType}" ]] && [[ -e "${GCCType}/bin/${GCCType}-gcc" ]];then
    GCCVer="$(./${GCCType}/bin/${GCCType}-gcc --version | head -n 1)"
    GCCLink="https://github.com/ZyCromerZ/compiled-gcc/releases/download/v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)/$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d).tar.gz"
    curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001150624898" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="New Toolchain Already Builded boy%0ADate : <code>$(date +"%Y-%m-%d")</code>%0A<code> --- Detail Info About it --- </code>%0AGCC version : <code>${GCCVer}</code>%0ABINUTILS version : <code>$(cat ".BINUTILS.versionNya")</code>%0AGMP version : <code>$(cat ".GMP.versionNya")</code>%0AMPFR version : <code>$(cat ".MPFR.versionNya")</code>%0AMPC version : <code>$(cat ".MPC.versionNya")</code>%0AISL version : <code>$(cat ".ISL.versionNya")</code>%0AGCLIB version : <code>$(cat ".GCLIB.versionNya")</code>%0A%0ALink downloads : <code>${GCCLink}</code>%0A%0A-- uWu --"
fi

if [[ -z "$GCC_HEAD_COMMIT" ]];then
    cd sources/gcc
    GCC_HEAD_COMMIT="$(git rev-parse HEAD)"
    cd $CURRENTMAINPATH
fi 

git clone https://${GIT_SECRET}@github.com/ZyCromerZ/${GCCType} -b $GCCVersion $(pwd)/FromGithub && \
cp -af ${GCCType}/* $(pwd)/FromGithub && cd $(pwd)/FromGithub && \
git add . && git commit -s -m "Update to https://github.com/gcc-mirror/gcc/commit/${GCC_HEAD_COMMIT}

GCC VERSION: $( ../${GCCType}/bin/${GCCType}-gcc --version | head -n 1)
GCC COMMIT URL: https://github.com/gcc-mirror/gcc/commit/${GCC_HEAD_COMMIT}" && \
git push --all origin -f
cd $CURRENTMAINPATH

if [[ ! -z "${4}" ]] && [[ "${4}" == "nozip" ]];then
    if [[ -d "${GCCType}" ]] && [[ -e "${GCCType}/bin/${GCCType}-gcc" ]];then
        GCCVer="$(./${GCCType}/bin/${GCCType}-gcc --version | head -n 1)"
        GCCLink="https://github.com/ZyCromerZ/compiled-gcc/releases/download/v$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d)/$GCCType-${GCCVersion}.x-gnu-$(date +%Y%m%d).tar.gz"
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001150624898" \
            -d "disable_web_page_preview=true" \
            -d "parse_mode=html" \
            -d text="New Toolchain Already Builded boy%0ADate : <code>$(date +"%Y-%m-%d")</code>%0A<code> --- Detail Info About it --- </code>%0AGCC version : <code>${GCCVer}</code>%0ABINUTILS version : <code>$(cat ".BINUTILS.versionNya")</code>%0AGMP version : <code>$(cat ".GMP.versionNya")</code>%0AMPFR version : <code>$(cat ".MPFR.versionNya")</code>%0AMPC version : <code>$(cat ".MPC.versionNya")</code>%0AISL version : <code>$(cat ".ISL.versionNya")</code>%0AGCLIB version : <code>$(cat ".GCLIB.versionNya")</code>%0A%0AGCC Link : <code>https://github.com/ZyCromerZ/${GCCType}</code>%0A%0A-- uWu --"
    fi
fi

rm -rf *