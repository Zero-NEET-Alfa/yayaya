#! /bin/bash
branch="20201215/Neutrino-X"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial' 'full'

Author="ZyCromerZ"
FolderUp="xobod-neutrino"
ExFolder="X"
spectrumFile="f.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"


CompileKernel

PullPTags

CompileKernel

FixPieWifi

CompileKernel


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"