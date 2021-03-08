#! /bin/bash
KernelBranch="20201110/qk-l"

IncludeFiles "${MainPath}/device/begonia-cfw.sh"
CustomUploader="Y"
UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
FolderUp="begonia-cfw-qk"
ExFolder="L"
TypeBuildTag="[CFW][Stock-LMK]"

# misc
spectrumFile="bego-on.rc"
doOsdnUp=$FolderUp
doSFUp=$FolderUp
PostLinkNow="Y"
KernelDownloader="Y"

CloneKernel
CloneGccten && CloneGugelClang
CompileClangKernel && pullALmk
CompileClangKernel && pullSlmk
CompileClangKernel && CleanOut

CloneOldDTCClang
TypeBuildTag="[CFW][Stock-LMK]"
CompileClangKernel && pullALmk
CompileClangKernel && pullSlmk
CompileClangKernel && CleanOut

TypeBuildTag="[CFW][Stock-LMK]"
CompileGccKernel && pullALmk
CompileGccKernel && pullSlmk
CompileGccKernel && CleanOut