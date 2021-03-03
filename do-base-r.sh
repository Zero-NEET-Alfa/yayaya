#! /bin/bash
branch="base-R"
BuilderKernel="clang"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial' 'full'

Author="ZyCromerZ"
FolderUp="keqing-drive"
spectrumFile="None"
TypeBuild="Stable"
TypeBuildTag="R-WIFI"
getInfo ">> Building kernel . . . . <<"


KernelFor="R"
CompileKernel
cd $kernelDir
git reset --hard HEAD~1
TypeBuildTag="P-WIFI"
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