#! /bin/bash
branch="eleven"
# branch="20201215/Neutrino-X"
BuilderKernel="00000"

if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] ;then
    exit;
fi
. main-surya.sh 'initial'

Author="ZyCromerZ"
FolderUp="x01bd"
ExFolder="Surya"
spectrumFile="None"
# spectrumFile="f.rc"
TypeBuild="JUST-TEST-BUILD"
TypeBuildTag="WhoKnows"
getInfo ">> Building kernel . . . . <<"

CompileKernel