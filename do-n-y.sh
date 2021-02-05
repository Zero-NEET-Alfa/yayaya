#! /bin/bash
branch="20201215/Neutrino-Y"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="xobod-neutrino-y-r"
doSFUp="$FolderUp"
PostLinkNow="Y"
spectrumFile="vipn.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"

# ExFolder="Y-R"
CompileKernel
CompileKernel "65"
CompileKernel "68"

PullPTags

# ExFolder="Y-Q"
FolderUp="xobod-neutrino-y-q"
doSFUp="$FolderUp"
CompileKernel
CompileKernel "65"
CompileKernel "68"

FixPieWifi

# ExFolder="Y-P"
FolderUp="xobod-neutrino-y-p"
doSFUp="$FolderUp"
CompileKernel
CompileKernel "65"
CompileKernel "68"

tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"