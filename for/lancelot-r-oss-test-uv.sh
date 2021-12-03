#! /bin/bash
KernelBranch="base-r-oss-custom-release-uv"

IncludeFiles "${MainPath}/device/lancelot-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[STABLE][Stock][950Mhz]"

CloneKernel
CloneZyCFoutTeenClang
# CompileClangKernelB
# pullBranch "base-r-oss-custom-release-ALMK" "[STABLE][ALMK][950Mhz]"
# CompileClangKernelB
CloneCompiledGccEleven
pullBranch "base-r-oss-custom-release-SLMK" "[STABLE][SLMK][950Mhz]"
CompileClangKernelB



# cleanup stuff after done
cd "${MainPath}"
rm -rf *
