#! /bin/bash
branch="lineage-18.1-mod"
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


ExFolder="STOCK-R"
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