#! /bin/bash
branch="lineage-17.1-R-wifitags"
BuilderKernel="clang"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

Author="ZyCromerZ"
FolderUp="keqing-drive"
spectrumFile="None"
TypeBuild="R-WIFI"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"


ExFolder="STOCK-Q"
KernelFor="Q"
CompileKernel
# CompileKernel "65"
# CompileKernel "68"

# PullPTags

# ExFolder="STOCK-Q"
# CompileKernel
# CompileKernel "65"
# CompileKernel "68"

# FixPieWifi

# ExFolder="STOCK-P"
# CompileKernel
# CompileKernel "65"
# CompileKernel "68"


tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"