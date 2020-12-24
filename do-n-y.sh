#! /bin/bash
branch="20201215/Neutrino-Y"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="xobod-neutrino"
spectrumFile="vipn.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"
DoSplitDate='Y'

ExFolder="Y-R"
CompileKernel
CompileKernel "65"
CompileKernel "68"

PullPTags

ExFolder="Y-Q"
CompileKernel
CompileKernel "65"
CompileKernel "68"

FixPieWifi

ExFolder="Y-P"
CompileKernel
CompileKernel "65"
CompileKernel "68"

tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"