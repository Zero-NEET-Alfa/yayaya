#! /bin/bash
branch="q-oss-upstream-mod-oc"
BuilderKernel="clang"

. main.sh 'initial'
export KBUILD_BUILD_VERSION=11

spectrumFile="none"
TypeBuild="Stable"
TypeBuildTag="AOSP-RIPCFW"
getInfo ">> Building kernel . . . . <<"
FolderUp="keqing-drive"

# kDLi='stock-clang'
CompileKernel

BuilderKernel="dtc"
changeGcc
changeClang

# kDLi='stock-dtc'
CompileKernel

BuilderKernel="gcc"
changeGcc
changeClang

# kDLi='stock-gcc'
CompileKernel