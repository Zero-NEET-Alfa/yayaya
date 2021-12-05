#!/usr/bin/env bash
KERNEL=$(pwd)/kernel-dir
if [ -z "${GIT_SECRET}" ];then
    exit
fi
addBranch()
{
    git fetch origin $1
    git checkout FETCH_HEAD && git checkout -b $1
}
# git clone https://${GIT_SECRET}@github.com/ZyCromerZ/vayu_kernel -b 20210812/main-prepare $KERNEL
mkdir $KERNEL
# wget -q https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/clang-r428724.tar.gz -O "clang.tar.gz"
wget -q https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/375eacfe6842c93c18805b275a9c66d35573694c.tar.gz -O "gcc.tar.gz"
tar -xf gcc.tar.gz -C $KERNEL
cd $KERNEL
# git remote add myrepo https://${GIT_SECRET}@github.com/ZyCromerZ/vayu
###
git init
git checkout -b android-12.0.0_r15
git add . && git commit -s -m "android-12.0.0_r15"
git remote add myrepo https://${GIT_SECRET}@github.com/ZyCromerZ/aarch64-linux-android-4.9
# git push -f myrepo --all
git push -f myrepo android-12.0.0_r15
cd ..
rm -rf $KERNEL
mkdir $KERNEL-32
wget -q https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+archive/95a6a75c79d90a5601c76fb46ba4c06da0188b3c.tar.gz -O "gcc32.tar.gz"
tar -xf gcc32.tar.gz -C $KERNEL-32
cd $KERNEL-32
git init
git checkout -b android-12.0.0_r15
git add . && git commit -s -m "android-12.0.0_r15"
git remote add myrepo https://${GIT_SECRET}@github.com/ZyCromerZ/arm-linux-androideabi-4.9
git push -f myrepo android-12.0.0_r15
cd ..
rm -rf $KERNEL-32

rm -rf *