#! /bin/bash
branch="20201215/main"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="x01bd"
ExFolder="Neutrino"
spectrumFile=""
TypeBuild="MAIN-Neutrino-BRANCH"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"

CompileKernel

PullPTags

CompileKernel

FixPieWifi

CompileKernel