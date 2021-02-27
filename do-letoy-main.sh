#! /bin/bash
branch="20210228/main"
BuilderKernel="clang"
# UseOldGcc="Y"
. main-letoy.sh 'initial' 
export KBUILD_BUILD_VERSION=99

spectrumFile="none"
TypeBuild="MAIN"
TypeBuildTag="NgeTeh"
getInfo ">> Building kernel . . . . <<"
FolderUp="keqing-drive"
# FolderUp="letoy-stock"
# doSFUp=$FolderUp
# doOsdnUp=$FolderUp
# PostLinkNow="Y"

# kDLi='stock-memeui-clang'
CompileKernel

# BuilderKernel="dtc"
# changeGcc
# changeClang

# # kDLi='stock-memeui-dtc'
# CompileKernel

# BuilderKernel="gcc"
# changeGcc
# changeClang

# # kDLi='stock-memeui-gcc'
# CompileKernel