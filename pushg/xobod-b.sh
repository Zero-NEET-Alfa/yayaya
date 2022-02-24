#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="x01bd-main-q x01bd-main-q2 x01bd-main-q3 x01bd-main-q4 x01bd-main-p3 x01bd-main-p4"
SetBranch="xobod-builder-b"
. pushg/vayu.sh $GetRepo $GetBranch