#! /bin/bash
branch="20201215/Neutrino-X"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="xobod-neutrino-x-r"
doSFUp="$FolderUp"
PostLinkNow="Y"
spectrumFile="f.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"


# ExFolder="X-R"
CompileKernel
CompileKernel "65"
CompileKernel "68"

PullPTags

# ExFolder="X-Q"
FolderUp="xobod-neutrino-x-q"
doSFUp="$FolderUp"
CompileKernel
CompileKernel "65"
CompileKernel "68"

FixPieWifi

# ExFolder="X-P"
FolderUp="xobod-neutrino-x-p"
doSFUp="$FolderUp"
CompileKernel
CompileKernel "65"
CompileKernel "68"


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"