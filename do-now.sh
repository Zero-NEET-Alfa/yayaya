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
git clone https://${GIT_SECRET}@github.com/ZyCromerZ/vayu_kernel -b 20210812/main-prepare $KERNEL
cd $KERNEL
git remote add myrepo https://${GIT_SECRET}@github.com/ZyCromerZ/vayu

git push -f myrepo --all
cd ..
rm -rf $KERNEL

rm -rf *