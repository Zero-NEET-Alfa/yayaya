#! /bin/bash
branch="20210304/q/main"
BuilderKernel="clang"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="keqing-drive"
spectrumFile="None"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"


ExFolder="STOCK-Q"
KernelFor="Q"
CompileKernel
# CompileKernel "65"
# CompileKernel "68"

PullPTags

# ExFolder="STOCK-Q"
TypeBuild="P-WIFI"
CompileKernel
# CompileKernel "65"
# CompileKernel "68"

# FixPieWifi

# ExFolder="STOCK-P"
# CompileKernel
# CompileKernel "65"
# CompileKernel "68"


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"