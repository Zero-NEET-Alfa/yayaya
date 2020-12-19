#! /bin/bash
branch="20201208/BN-X"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main.sh 'initial'

ExFolder="X"
spectrumFile="f.rc"
TypeBuild="Stable"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"

CompileKernel
CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

FixPieWifi

CompileKernel
CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"