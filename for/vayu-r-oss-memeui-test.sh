#! /bin/bash
KernelBranch="20210529/neutrino-lk"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[TEST]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
# CloneGCCOld && CloneGugelClang
# CompileClangKernel && CleanOut
CloneProtonClang
CompileProtonClangKernel && CleanOut
# CloneCompiledGccTwelve
CloneCompiledGccEleven
# CloneSdClang
# CompileClangKernel && CleanOut
CloneDTCClang
CompileClangKernel && CleanOut
DEFFCONFIG="vayu_gcc_defconfig"
CompileGccKernel