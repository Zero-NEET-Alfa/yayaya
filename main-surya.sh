#! /bin/bash

 # Script For Building Android Kernel
 #
 # Copyright (c) 2020 Zero-NEET-Alfa <danidaboy54@gmail.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #      http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #

# Function to show an informational message
# need to defined
# - branch
# - spectrumFile
# Then call CompileKernel and done

getInfo() {
    echo -e "\e[1;32m$*\e[0m"
}

getInfoErr() {
    echo -e "\e[1;41m$*\e[0m"
}

mainDir=$PWD

kernelDir=$mainDir/kernel

clangDir=$mainDir/clang

gcc64Dir=$mainDir/gcc64

gcc32Dir=$mainDir/gcc32

AnykernelDir=$mainDir/Anykernel3

SpectrumDir=$mainDir/Spectrum

GdriveDir=$mainDir/Gdrive-Uploader

useGdrive='Y'

Author="Zero-NEET-Alfa"

if [ ! -z "$1" ] && [ "$1" == 'initial' ];then
    allFromClang='N'
    if [ ! -z "$2" ] && [ "$2" == 'full' ];then
        getInfo ">> cloning kernel full . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/kernel_xiaomi_surya -b "$branch" $kernelDir
    else
        getInfo ">> cloning kernel . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/kernel_xiaomi_surya -b "$branch" $kernelDir --depth=1 
    fi
    [ -z "$BuilderKernel" ] && BuilderKernel="clang"
    if [ "$BuilderKernel" == "clang" ];then
        getInfo ">> cloning stormbreaker clang 11 . . . <<"
        git clone https://github.com/stormbreaker-project/stormbreaker-clang -b 11.x $clangDir --depth=1
        allFromClang='N'
        SimpleClang="Y"
    fi
    if [ "$BuilderKernel" == "dtc" ];then
        getInfo ">> cloning DragonTC clang 10 . . . <<"
        git clone https://github.com/NusantaraDevs/DragonTC -b 10.0 $clangDir --depth=1
    fi
    if [ "$allFromClang" == "N" ];then
        getInfo ">> cloning gcc64 . . . <<"
        git clone https://github.com/ZyCromerZ/aarch64-linux-android-4.9/ -b android-10.0.0_r47 $gcc64Dir --depth=1
        getInfo ">> cloning gcc32 . . . <<"
        git clone https://github.com/ZyCromerZ/arm-linux-androideabi-4.9/ -b android-10.0.0_r47 $gcc32Dir --depth=1
        for64=aarch64-linux-android
        for32=arm-linux-androideabi
    else
        gcc64Dir=$clangDir
        gcc32Dir=$clangDir
        for64=aarch64-linux-gnu
        for32=arm-linux-gnueabi
    fi

    getInfo ">> cloning Anykernel . . . <<"
    git clone https://github.com/ZyCromerZ/AnyKernel3 -b master $AnykernelDir --depth=1
    getInfo ">> cloning Spectrum . . . <<"
    git clone https://github.com/ZyCromerZ/Spectrum -b master $SpectrumDir --depth=1
    if [ "$useGdrive" == "Y" ];then
        getInfo ">> cloning Gdrive Uploader . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/gdrive_uploader -b master $GdriveDir --depth=1 
    fi
    
    DEVICE="IDK"
    CODENAME="Surya"
    SaveChatID="-1001150624898"
    ARCH="arm64"
    TypeBuild="Stable"
    DEFFCONFIG="surya_defconfig"
    GetBD=$(date +"%m%d")
    GetCBD=$(date +"%Y-%m-%d")
    TotalCores=$(nproc --all)
    TypeBuildTag="AOSP"
    KernelFor='R'
    SendInfo='belum'
    RefreshRate="60"
    SetTag="LA.UM.8.2.r1"
    SetLastTag="sdm660.0"
    SetTagR="LA.UM.9.2.r1"
    SetLastTagR="SDMxx0.0"
    FolderUp="xobod-private"
    ExFolder=""
    export KBUILD_BUILD_HOST="Circleci-server"
    if [ "$BuilderKernel" == "gcc" ];then
        ClangType="$($gcc64Dir/bin/$for64-gcc --version | head -n 1)"
    else
        ClangType="$($clangDir/bin/clang --version | head -n 1)"
    fi
    KBUILD_COMPILER_STRING="$ClangType"
    if [ -e $gcc64Dir/bin/$for64-gcc ];then
        gcc64Type="$($gcc64Dir/bin/$for64-gcc --version | head -n 1)"
    else
        cd $gcc64Dir
        gcc64Type=$(git log --pretty=format:'%h: %s' -n1)
        cd $mainDir
    fi
    if [ -e $gcc32Dir/bin/$for32-gcc ];then
        gcc32Type="$($gcc32Dir/bin/$for32-gcc --version | head -n 1)"
    else
        cd $gcc32Dir
        gcc32Type=$(git log --pretty=format:'%h: %s' -n1)
        cd $mainDir
    fi
    cd $kernelDir
    KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
    THeadCommitId=$(git log --pretty=format:'%h' -n1)
    THeadCommitMsg=$(git log --pretty=format:'%s' -n1)
    cd $mainDir
fi

tg_send_info(){
    if [ ! -z "$2" ];then
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$2" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    else
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001150624898" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    fi
}

tg_send_files(){
    KernelFiles="$(pwd)/$RealZipName"
	MD5CHECK=$(md5sum "$KernelFiles" | cut -d' ' -f1)
    MSG="✅ <b>Build Success</b> 
- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s) </code> 

<b>MD5 Checksum</b>
- <code>$MD5CHECK</code>

<b>Zip Name</b> 
- <code>$ZipName</code>"


    if [ "$useGdrive" == "Y" ];then
        currentFolder="$(pwd)"
        cd $GdriveDir
        chmod +x run.sh
        . run.sh "$KernelFiles" "$FolderUp" "$(date +"%m-%d-%Y")" "$ExFolder"
        cd $currentFolder
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG"
        fi
    else
        curl --progress-bar -F document=@"$KernelFiles" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
        -F chat_id="$SaveChatID"  \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="$MSG"
    fi

    # remove files after build done
    rm -rf $KernelFiles $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb
}

CompileKernel(){
    cd $kernelDir
    export KBUILD_BUILD_USER="$Author"
    export KBUILD_COMPILER_STRING
    if [ "$BuilderKernel" == "gcc" ];then
        MAKE+=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                CROSS_COMPILE=aarch64-linux-android- \
                CROSS_COMPILE_ARM32=arm-linux-androideabi-
        )
    else
        if [ "$allFromClang" == "Y" ];then
            MAKE+=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$clangDir/bin:${PATH} \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                AR=llvm-ar \
                NM=llvm-nm \
                OBJCOPY=llvm-objcopy \
                OBJDUMP=llvm-objdump \
                STRIP=llvm-strip \
                CLANG_TRIPLE=aarch64-linux-gnu-
            )
        else
            if [ "$SimpleClang" == "Y" ];then
                MAKE+=(
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    AR=llvm-ar \
                    NM=llvm-nm \
                    OBJCOPY=llvm-objcopy \
                    OBJDUMP=llvm-objdump \
                    STRIP=llvm-strip \
                    CLANG_TRIPLE=aarch64-linux-gnu-
                )
            else
                MAKE+=(
                        ARCH=$ARCH \
                        SUBARCH=$ARCH \
                        PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                        CC=clang \
                        CROSS_COMPILE=$for64- \
                        CROSS_COMPILE_ARM32=$for32- \
                        AR=llvm-ar \
                        AS=llvm-as \
                        NM=llvm-nm \
                        STRIP=llvm-strip \
                        OBJCOPY=llvm-objcopy \
                        OBJDUMP=llvm-objdump \
                        OBJSIZE=llvm-size \
                        READELF=llvm-readelf \
                        HOSTCC=clang \
                        HOSTCXX=clang++ \
                        HOSTAR=llvm-ar \
                        CLANG_TRIPLE=aarch64-linux-gnu-
                )
            fi
        fi
    fi
    # rm -rf out # always remove out directory :V
    BUILD_START=$(date +"%s")
     if [ ! -z "$DRONE_BUILD_NUMBER" ];then
        CIRCLE_BUILD_NUM="$DRONE_BUILD_NUMBER"
        CIRCLE_BUILD_URL="https://cloud.drone.io/Zero-NEET-Alfa/yayaya/$DRONE_BUILD_NUMBER/1/2"
        doOsdnUp=""
        doSFUp=""
    fi
    if [ "$SendInfo" != 'sudah' ];then
        if [ "$BuilderKernel" == "gcc" ];then
            MSG="<b>🔨 New Kernel On The Way</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Branch: $branch</b>%0A<b>Build Date: $GetCBD </b>%0A<b>Build Number: $CIRCLE_BUILD_NUM </b>%0A<b>Build Link Progress:</b><a href='$CIRCLE_BUILD_URL'> Check Here </a>%0A<b>Host Core Count : $TotalCores cores </b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Id: $THeadCommitId </b>%0A<b>Last Commit-Message: $THeadCommitMsg </b>%0A<b>Builder Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild"
        else
            MSG="<b>🔨 New Kernel On The Way</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Branch: $branch</b>%0A<b>Build Date: $GetCBD </b>%0A<b>Build Number: $CIRCLE_BUILD_NUM </b>%0A<b>Build Link Progress:</b><a href='$CIRCLE_BUILD_URL'> Check Here </a>%0A<b>Host Core Count : $TotalCores cores </b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Id: $THeadCommitId </b>%0A<b>Last Commit-Message: $THeadCommitMsg </b>%0A<b>Builder Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $ClangType </code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild"
        fi
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG" 
        fi
        SendInfo='sudah'
    fi
    git reset --hard $HeadCommitId
    if [ ! -z "$1" ] && [ $1 != "60" ];then
        update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X01BD/dsi-panel-hx83112a-1080p-video-tm.dtsi" && \
        update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X01BD/dsi-panel-nt36672ah-1080p-video-kd.dtsi"
        RefreshRate="$1"
    fi
    LastHeadCommitId=$(git log --pretty=format:'%h' -n1)
    TAGKENEL="$(git log | grep "${SetTag}" | head -n 1 | awk -F '\\'${SetLastTag}'' '{print $1"'${SetLastTag}'"}' | awk -F '\\'${SetTag}'' '{print "'${SetTag}'"$2}')"
    if [ ! -z "$TAGKENEL" ];then
        export KBUILD_BUILD_HOST="Circleci-server-$TAGKENEL"
    fi
    TAGKENELR="$(git log | grep "${SetTagR}" | head -n 1 | awk -F '\\'${SetLastTagR}'' '{print $1"'${SetLastTagR}'"}' | awk -F '\\'${SetTagR}'' '{print "'${SetTagR}'"$2}')"
    if [ ! -z "$TAGKENELR" ];then
        export KBUILD_BUILD_HOST="Circleci-server-$TAGKENELR"
    fi
    make -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    if [ "$BuilderKernel" == "gcc" ];then
        make -j${TotalCores}  O=out \
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=aarch64-linux-android- \
            CROSS_COMPILE_ARM32=arm-linux-androideabi-
    else
        if [ "$allFromClang" == "Y" ];then
            make -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$clangDir/bin:${PATH} \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                AR=llvm-ar \
                NM=llvm-nm \
                OBJCOPY=llvm-objcopy \
                OBJDUMP=llvm-objdump \
                STRIP=llvm-strip \
                CLANG_TRIPLE=aarch64-linux-gnu-
        else
            if [ "$SimpleClang" == "Y" ];then
                make -j${TotalCores}  O=out \
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    AR=llvm-ar \
                    NM=llvm-nm \
                    OBJCOPY=llvm-objcopy \
                    OBJDUMP=llvm-objdump \
                    STRIP=llvm-strip \
                    CLANG_TRIPLE=aarch64-linux-gnu-
            else
                make -j${TotalCores}  O=out \
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    AR=llvm-ar \
                    AS=llvm-as \
                    NM=llvm-nm \
                    STRIP=llvm-strip \
                    OBJCOPY=llvm-objcopy \
                    OBJDUMP=llvm-objdump \
                    OBJSIZE=llvm-size \
                    READELF=llvm-readelf \
                    HOSTCC=clang \
                    HOSTCXX=clang++ \
                    HOSTAR=llvm-ar \
                    CLANG_TRIPLE=aarch64-linux-gnu-
            fi
        fi
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [ -f $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb ];then
        cp -af $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb $AnykernelDir
        KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
        [[ "$BuilderKernel" == "gcc" ]] && TypeBuilder="GCC"
        [[ "$BuilderKernel" == "clang" ]] && TypeBuilder="Stormbreaker"
        [[ "$BuilderKernel" == "dtc" ]] && TypeBuilder="DTC"
        if [ $TypeBuild == "Stable" ];then
            ZipName="[$GetBD][$TypeBuilder][${RefreshRate}Hz][$KernelFor][$CODENAME]$KVer-$KName-$LastHeadCommitId.zip"
        else
            ZipName="[$GetBD][$TypeBuilder][${RefreshRate}Hz][$KernelFor][$TypeBuild][$CODENAME]$KVer-$KName-$LastHeadCommitId.zip"
        fi
        # RealZipName="[$GetBD]$KVer-$HeadCommitId.zip"
        RealZipName="$ZipName"
        if [ ! -z "$2" ];then
            MakeZip "$2"
        else
            MakeZip
        fi
    else
        MSG="<b>❌ Build failed</b>%0Abranch : $branch%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        if [ ! -z "$2" ];then
            tg_send_info "$MSG" "$2"
        else
            tg_send_info "$MSG" 
        fi
        exit -1
    fi
}


MakeZip(){
    cd $AnykernelDir
    if [ ! -z "$spectrumFile" ];then
        cp -af $SpectrumDir/$spectrumFile init.spectrum.rc && sed -i "s/persist.spectrum.kernel.*/persist.spectrum.kernel $KName/g" init.spectrum.rc
    fi
    cp -af anykernel-real.sh anykernel.sh && sed -i "s/kernel.string=.*/kernel.string=$KName-$HeadCommitId by $Author/g" anykernel.sh

    zip -r9 "$RealZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip
    if [ ! -z "$1" ];then
        tg_send_files "$1"
    else
        tg_send_files
    fi

}

FixPieWifi()
{
    cd $kernelDir
    git reset  --hard $HeadCommitId
    rm -rf out
    git revert bbed6c7c6fe2779f9c5fc80124e13411277d4ca1 --no-commit
    git commit -s -m "Fix wifi broken for Android 9"
    KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
    KernelFor='P'
    RefreshRate="60"
    rm -rf out
    cd $mainDir
}


initial-qcacld(){
    git fetch https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/$1 $2
    git merge -s ours --no-commit --allow-unrelated-histories FETCH_HEAD
    git read-tree --prefix=drivers/staging/$1 -u FETCH_HEAD
    git commit -s -m "Merge $2 to drivers/staging/$1"
}

PullPTags()
{
    cd $kernelDir
    git reset --hard $HeadCommitId
    rm -rf out drivers/staging/qcacld-3.0 drivers/staging/fw-api drivers/staging/qca-wifi-host-cmn
    git add .
    git commit -s -m "Remove Q WLAN DRIVERS"
    initial-qcacld qcacld-3.0 LA.UM.7.2.r1-09600-sdm660.0 && \
    initial-qcacld fw-api LA.UM.7.2.r1-09600-sdm660.0 && \
    initial-qcacld qca-wifi-host-cmn LA.UM.7.2.r1-09600-sdm660.0
    git fetch origin 24e21b45cf7a9eb57540e7c7caf19168aa6cf5ac --depth=14
    git cherry-pick 88961ef633c361984df1d29bb4897d06968215ee..f3856fb685d3a4107148a6459e2b2592d1efeb57
    KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
    KernelFor='Q'
    RefreshRate="60"
    rm -rf out
    cd $mainDir
}

update_file() {
    if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ];then
        GetValue="$(cat $3 | grep "$1")"
        GetPath=${3/"."/""}
        ValOri="$(echo "$GetValue" | awk -F '\\=' '{print $2}')"
        UpdateTo="$(echo "$2" | awk -F '\\=' '{print $2}')"
        [ "$ValOri" != "$UpdateTo" ] && \
        sed -i "s/$1.*/$2/g" "$3"
        [ ! -z "$(git status | grep "modified" )" ] && \
        git add "$3" && \
        git commit -s -m "$GetPath: '$GetValue' update to '$2'"
    fi
}

getInfo 'include main.sh success'