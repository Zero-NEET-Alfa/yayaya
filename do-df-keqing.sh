#! /bin/bash
branch="20210205/df-keqing"
BuilderKernel="clang"

. main.sh 'initial'
export KBUILD_BUILD_VERSION=7

spectrumFile="bego-on-p.rc"
TypeBuild="Stable"
FolderUp="begonia-cfw-df"
PostLinkNow="Y"
doSFUp=$FolderUp
ExFolder="Keqing"

# TypeBuildTag="AOSP-CFW"
# getInfo ">> Building kernel . . . . <<"

# CompileKernel

# BuilderKernel="dtc"
# changeGcc
# changeClang

# CompileKernel

# BuilderKernel="gcc"
# changeGcc
# changeClang

# CompileKernel

branch="20210205/df-keqing"
BuilderKernel="clang"
FolderUp="begonia-memeui-df"
UsePrivateSF="Y"
doSFUp=$FolderUp
ChangeBranch
TypeBuildTag="AOSP-RIPCFW"
changeGcc
changeClang


CompileKernel

BuilderKernel="dtc"
changeGcc
changeClang

CompileKernel

BuilderKernel="gcc"
changeGcc
changeClang

CompileKernel
