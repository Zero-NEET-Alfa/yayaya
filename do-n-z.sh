#! /bin/bash
branch="20201215/Neutrino-Z"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="xobod-neutrino-z-r"
doSFUp="$FolderUp"
PostLinkNow="Y"
spectrumFile="ul.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"

# ExFolder="Z-R"
CompileKernel
CompileKernel "65"
CompileKernel "68"

PullPTags

# ExFolder="Z-Q"
FolderUp="xobod-neutrino-z-q"
doSFUp="$FolderUp"
CompileKernel
CompileKernel "65"
CompileKernel "68"

FixPieWifi

# ExFolder="Z-P"
FolderUp="xobod-neutrino-z-p"
doSFUp="$FolderUp"
CompileKernel
CompileKernel "65"
CompileKernel "68"


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"