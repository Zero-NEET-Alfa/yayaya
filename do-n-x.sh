#! /bin/bash
branch="20201215/Neutrino-X"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="xobod-neutrino"
spectrumFile="f.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"
DoSplitDate='Y'


ExFolder="X-R"
CompileKernel
CompileKernel "65"
CompileKernel "68"

PullPTags

ExFolder="X-Q"
CompileKernel
CompileKernel "65"
CompileKernel "68"

FixPieWifi

ExFolder="X-P"
CompileKernel
CompileKernel "65"
CompileKernel "68"


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"