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
wget -q https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/clang-r428724.tar.gz -O "clang.tar.gz"
tar -xf clang.tar.gz -C $KERNEL
cd $KERNEL
# git remote add myrepo https://${GIT_SECRET}@github.com/ZyCromerZ/vayu
###
git init
git checkout -b 13.0.1-r428724
git add . && git commit -s -m "13.0.1-master-clang-r428724"
git remote add myrepo https://${GIT_SECRET}@github.com/ZyCromerZ/google-clang
# git push -f myrepo --all
git push -f myrepo 13.0.1-r428724
cd ..
rm -rf $KERNEL

rm -rf *