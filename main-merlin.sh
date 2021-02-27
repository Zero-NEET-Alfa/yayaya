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
if [ ! -z "$CIRCLE_BRANCH" ] && [ "$CIRCLE_BRANCH" == 'master' ];then
    exit
fi
if [ ! -z "$DRONE_REPO_BRANCH" ] && [ "$DRONE_REPO_BRANCH" == 'master' ];then
    exit
fi
check=$(ls /usr/lib/x86_64-linux-gnu | grep libisl.so -m1)
if [ ! -z "$check" ]; then if [ "$check" != "libisl.so.15" ]; then cp -af /usr/lib/x86_64-linux-gnu/$check /usr/lib/x86_64-linux-gnu/libisl.so.15; fi; fi
check=$(ls /usr/lib/x86_64-linux-gnu | grep libz3.so -m1)
if [ ! -z "$check" ]; then if [ "$check" != "libz3.so.4.8" ]; then cp -af /usr/lib/x86_64-linux-gnu/$check /usr/lib/x86_64-linux-gnu/libz3.so.4.8; fi; fi


if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit
fi
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

kDL=$mainDir/kernel-downloader # if kDLi defined

useGdrive='Y'

if [ ! -z "$1" ] && [ "$1" == 'initial' ];then
    
    if [ ! -z "$2" ] && [ "$2" == 'full' ];then
        getInfo ">> cloning kernel full . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/lancelot_kernels -b "$branch" $kernelDir
    else
        getInfo ">> cloning kernel . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/lancelot_kernels -b "$branch" $kernelDir --depth=1 
    fi
    [ -z "$BuilderKernel" ] && BuilderKernel="clang"
    if [ "$BuilderKernel" == "clang" ];then
        getInfo ">> cloning clang 9.0.4-r353983d . . . <<"
        git clone https://github.com/ZyCromerZ/google-clang -b 9.0.4-r353983d $clangDir --depth=1
    fi
    if [ "$BuilderKernel" == "dtc" ];then
        getInfo ">> cloning DragonTC clang 8 . . . <<"
        git clone https://github.com/nibaji/DragonTC-8.0 -b master $clangDir --depth=1
    fi
    if [[ -z "$UseOldGcc" ]];then
        mkdir $gcc64Dir
        mkdir $gcc32Dir
        getInfo ">> get gcc 10.0.2 arm linaro . . . <<"
        wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
        tar -xf gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz -C $gcc32Dir
        gcc32Dir=$mainDir/gcc32/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf
        getInfo ">> get gcc 10.0.2 aarch64 linaro . . . <<"
        wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz
        tar -xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz -C $gcc64Dir
        gcc64Dir=$mainDir/gcc64/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf
        for64=aarch64-none-elf
        for32=arm-none-linux-gnueabihf
    else
        getInfo ">> cloning gcc 10.2.0 aarch64 . . . <<"
        git clone https://github.com/ZyCromerZ/aarch64-linux-android-4.9 $gcc64Dir --depth=1
        getInfo ">> cloning gcc 10.2.0 arm . . . <<"
        git clone https://github.com/ZyCromerZ/arm-linux-androideabi-4.9 $gcc32Dir --depth=1
        for64=aarch64-linux-android
        for32=arm-linux-androideabi
    fi
    getInfo ">> cloning Anykernel . . . <<"
    git clone https://github.com/ZyCromerZ/AnyKernel3 -b master-merlin $AnykernelDir --depth=1
    getInfo ">> cloning Spectrum . . . <<"
    git clone https://github.com/ZyCromerZ/Spectrum -b master $SpectrumDir --depth=1
    if [ "$useGdrive" == "Y" ];then
        getInfo ">> cloning Gdrive Uploader . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/gdrive_uploader -b master $GdriveDir --depth=1 
    fi
    
    DEVICE="Redmi Note 9"
    CODENAME="Merlin"
    SaveChatID="-1001301538740"
    ARCH="arm64"
    TypeBuild="Stable"
    DEFFCONFIG="merlin_defconfig"
    GetBD=$(date +"%m%d")
    GetCBD=$(date +"%Y-%m-%d")
    TotalCores=$(nproc --all)
    TypeBuildTag="AOSP-CFW"
    FullLto="Nope"
    FolderUp="begonia"
    ExFolder=""
    export KBUILD_BUILD_USER="ZyCromerZ"
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
    GetKernelName="$(cat "./arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/"//g' | sed 's/CONFIG_LOCALVERSION=//g')"
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
        . run.sh "$KernelFiles" "$FolderUp" "$GetCBD" "$ExFolder"
        cd $currentFolder

        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG"
        fi
        if [ ! -z "$kDLi" ];then
            git clone https://$GIT_SECRETB@github.com/$GIT_USERNAME/kernel-download-generator "$kDL"
            cd "$kDL"
            chmod +x update.sh
            . update.sh "$kDLi"
            cd ..
            rm -rf "$kDL"
        fi
    else
        curl --progress-bar -F document=@"$KernelFiles" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
        -F chat_id="$SaveChatID"  \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="$MSG"
    fi
    # remove files after build done
    rm -rf $KernelFiles
}

CompileKernel(){
    cd $kernelDir
    export KBUILD_COMPILER_STRING
    if [ "$BuilderKernel" == "gcc" ];then
        MAKE+=(
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=$for64- \
            CROSS_COMPILE_ARM32=$for32-
        )
    else
        if [ "$FullLto" == "YES" ];then
            MAKE+=(
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    LD_LIBRARY_PATH="$clangDir/lib64:${LD_LIBRARY_PATH}" \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    AS=llvm-as \
                    NM=llvm-nm \
                    STRIP=llvm-strip \
                    OBJDUMP=llvm-objdump \
                    OBJSIZE=llvm-size \
                    READELF=llvm-readelf \
                    HOSTCC=clang \
                    HOSTCXX=clang++ \
                    HOSTAR=llvm-ar \
                    HOSTLD=ld.lld \
                    LD=ld.lld \
                    CLANG_TRIPLE=aarch64-linux-gnu-
            )
        else
            MAKE+=(
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    LD_LIBRARY_PATH="$clangDir/lib64:${LD_LIBRARY_PATH}" \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    CLANG_TRIPLE=aarch64-linux-gnu-
            )
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
    if [ "$BuilderKernel" == "gcc" ];then
        MSG="<b>🔨 New Kernel On The Way</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Branch: $branch</b>%0A<b>Build Date: $GetCBD </b>%0A<b>Build Number: $CIRCLE_BUILD_NUM </b>%0A<b>Build Link Progress:</b><a href='$CIRCLE_BUILD_URL'> Check Here </a>%0A<b>Host Core Count : $TotalCores cores </b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Id: $HeadCommitId </b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Builder Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild"
    else
        MSG="<b>🔨 New Kernel On The Way</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Branch: $branch</b>%0A<b>Build Date: $GetCBD </b>%0A<b>Build Number: $CIRCLE_BUILD_NUM </b>%0A<b>Build Link Progress:</b><a href='$CIRCLE_BUILD_URL'> Check Here </a>%0A<b>Host Core Count : $TotalCores cores </b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Id: $HeadCommitId </b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Builder Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $ClangType </code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild"
    fi
    if [ ! -z "$1" ];then
        tg_send_info "$MSG" "$1"
    else
        tg_send_info "$MSG" 
    fi

    git fetch origin 45bb0478d445 --depth=2
    git cherry-pick 45bb0478d445

    make -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    if [ "$BuilderKernel" == "gcc" ];then
        make -j${TotalCores}  O=out \
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=$for64- \
            CROSS_COMPILE_ARM32=$for32-
    else
        if [ "$FullLto" == "YES" ];then
            make -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="$clangDir/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                AS=llvm-as \
                NM=llvm-nm \
                STRIP=llvm-strip \
                OBJDUMP=llvm-objdump \
                OBJSIZE=llvm-size \
                READELF=llvm-readelf \
                HOSTCC=clang \
                HOSTCXX=clang++ \
                HOSTAR=llvm-ar \
                HOSTLD=ld.lld \
                LD=ld.lld \
                CLANG_TRIPLE=aarch64-linux-gnu-
        else
            make -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="$clangDir/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu-
        fi
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [ -f $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb ];then
        cp -af $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb $AnykernelDir
        KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
        [[ "$BuilderKernel" == "gcc" ]] && TypeBuilder="GCC"
        [[ "$BuilderKernel" == "clang" ]] && TypeBuilder="Clang"
        [[ "$BuilderKernel" == "dtc" ]] && TypeBuilder="DTC"
        if [ $TypeBuild == "Stable" ];then
            # ZipName="[$GetBD][$TypeBuilder][$TypeBuildTag][$CODENAME]$KVer-$KName-$HeadCommitId.zip"
            ZipName="[$TypeBuilder][$TypeBuildTag][$CODENAME]$KVer-$KName-$HeadCommitId.zip"
        else
            # ZipName="[$GetBD][$TypeBuilder][$TypeBuildTag][$TypeBuild][$CODENAME]$KVer-$KName-$HeadCommitId.zip"
            ZipName="[$TypeBuilder][$TypeBuildTag][$TypeBuild][$CODENAME]$KVer-$KName-$HeadCommitId.zip"
        fi
        # RealZipName="[$GetBD]$KVer-$HeadCommitId.zip"
        RealZipName="$ZipName"
        if [ ! -z "$1" ];then
            MakeZip "$1"
        else
            MakeZip
        fi
    else
        MSG="<b>❌ Build failed</b>%0ABranch : <b>$branch</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
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
    cp -af anykernel-real.sh anykernel.sh && sed -i "s/kernel.string=.*/kernel.string=$KName-$HeadCommitId by ZyCromerZ/g" anykernel.sh

    zip -r9 "$RealZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip
    if [ ! -z "$1" ];then
        tg_send_files "$1"
    else
        tg_send_files
    fi

}

pullLmk(){
    cd $kernelDir
    git reset --hard $HeadCommitId
    git pull --no-commit origin 20210228/main-ALMK
    git commit -s -m 'Pull branch 20210228/main-ALMK'
    TypeBuild="ALMK"
}
pullSlmk(){
    cd $kernelDir
    git reset --hard $HeadCommitId
    git pull --no-commit origin 20210228/main-SLMK
    git commit -s -m 'Pull branch 20210228/main-SLMK'
    TypeBuild="SLMK"
}

changeGcc()
{
    cd $kernelDir
    git reset --hard $HeadCommitId
    rm -rf out
    # if [ "$BuilderKernel" == "gcc" ];then
    #     cuR=aarch64-none-elf
    # else
    #     cuR=aarch64-linux-gnu
    # fi
    # if [ "$cuR" != "$for64" ];then
    #     rm -rf $gcc32Dir $gcc64Dir
    #     if [ "$BuilderKernel" != "gcc" ];then
    #         getInfo ">> cloning gcc 10.2.0 aarch64 . . . <<"
    #         git clone https://github.com/ZyCromerZ/aarch64-linux-gnu-1 -b stable-gcc $gcc64Dir --depth=1
    #         getInfo ">> cloning gcc 10.2.0 arm . . . <<"
    #         git clone https://github.com/ZyCromerZ/arm-linux-gnueabi -b stable-gcc $gcc32Dir --depth=1
    #         for64=aarch64-linux-gnu
    #         for32=arm-linux-gnueabi
    #     else
    #         mkdir $gcc64Dir
    #         mkdir $gcc32Dir
    #         getInfo ">> get gcc 10.0.2 arm linaro . . . <<"
    #         wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
    #         tar -xf gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz -C $gcc32Dir
    #         gcc32Dir=$mainDir/gcc32/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf
    #         getInfo ">> get gcc 10.0.2 aarch64 linaro . . . <<"
    #         wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz
    #         tar -xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz -C $gcc64Dir
    #         gcc64Dir=$mainDir/gcc64/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf
    #         for64=aarch64-none-elf
    #         for32=arm-none-linux-gnueabihf
    #     fi
    # fi
}

changeClang()
{
    cd $clangDir
    if [ "$BuilderKernel" == "clang" ];then
        git fetch https://github.com/ZyCromerZ/google-clang 9.0.4-r353983d --depth=1
        git checkout FETCH_HEAD
    fi
    if [ "$BuilderKernel" == "dtc" ];then
        git fetch  https://github.com/nibaji/DragonTC-8.0 master --depth=1
        git checkout FETCH_HEAD
    fi
    
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
}
ChangeBranch()
{
    cd $kernelDir
    git reset --hard
    git fetch origin "$branch"
    git checkout FETCH_HEAD
    git branch -D "$branch"
    git checkout -b "$branch"
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
}
getInfo 'include main.sh success'