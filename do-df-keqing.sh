#! /bin/bash
branch="20201110/df-keqing"
BuilderKernel="clang"

. main.sh 'initial'
export KBUILD_BUILD_VERSION=7

spectrumFile="bego-on-p.rc"
TypeBuild="Stable"
FolderUp="begonia-cfw-df"
doOsdnUp=$FolderUp
doSFUp=$FolderUp

TypeBuildTag="AOSP-CFW"
getInfo ">> Building kernel . . . . <<"

CompileKernel

BuilderKernel="dtc"
changeGcc
changeClang

CompileKernel

BuilderKernel="gcc"
changeGcc
changeClang

CompileKernel

branch="20210205/df-keqing"
BuilderKernel="clang"
FolderUp="begonia-memeui-df"
doOsdnUp=$FolderUp
doSFUp=$FolderUp
ChangeBranch

CompileKernel

BuilderKernel="dtc"
changeGcc
changeClang

CompileKernel

BuilderKernel="gcc"
changeGcc
changeClang

CompileKernel
