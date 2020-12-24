#! /bin/bash
branch="20201215/Neutrino-Z"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="xobod-neutrino"
spectrumFile="ul.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"
DoSplitDate='Y'

ExFolder="Z-R"
CompileKernel
CompileKernel "65"
CompileKernel "68"

PullPTags

ExFolder="Z-Q"
CompileKernel
CompileKernel "65"
CompileKernel "68"

FixPieWifi

ExFolder="Z-P"
CompileKernel
CompileKernel "65"
CompileKernel "68"


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"