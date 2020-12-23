#! /bin/bash
branch="20201215/Neutrino-Z"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial' 'full'

Author="ZyCromerZ"
FolderUp="xobod-neutrino"
ExFolder="Z"
spectrumFile="ul.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"

CompileKernel

PullPTags

CompileKernel

FixPieWifi

CompileKernel


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"