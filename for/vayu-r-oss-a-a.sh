#! /bin/bash
KernelBranch="20210824/neutrino-flamescion"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[Stable][A][MPDCL]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneZyCFoutTeenClang
# DisableMsmP
CompileClangKernelLLVM && CleanOut
TypeBuildTag="[Stable][B][MPDCL]"
CompileClangKernelB && CleanOut
[[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
git fetch origin f5d32ddaa1dd328d8d4d399786c56058bb85c487 --depth=1
git reset --hard f5d32ddaa1dd328d8d4d399786c56058bb85c487
TypeBuildTag="[Stable][A][MPDCL][OLD]"
CompileClangKernelLLVM && CleanOut
[[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
git fetch origin f5d32ddaa1dd328d8d4d399786c56058bb85c487 --depth=1
git reset --hard f5d32ddaa1dd328d8d4d399786c56058bb85c487
TypeBuildTag="[Stable][B][MPDCL][OLD]"
CompileClangKernelB && CleanOut