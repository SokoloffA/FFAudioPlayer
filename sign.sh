#!/bin/bash

set -euo pipefail


FRAMEWORK_NAME=FFAudioPlayer
XCFRAMEWORK_DIR="./${FRAMEWORK_NAME}.xcframework"
CERT_IDENTITY="Developer ID Application: Alex Sokolov (635H9TYSZJ)"

#######################################

SCRIPT_DIR=`pwd`
PROC_NUM=`nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2`
export PROC_NUM=${PROC_NUM}
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin


echo "*****************************************"
echo "* Signing .dylib files"
find "${XCFRAMEWORK_DIR}" -type file -name '*.dylib' -print0 | \
    xargs -0 -I % -P ${PROC_NUM} \
        codesign --force --sign "${CERT_IDENTITY}" %


echo "*****************************************"
echo "* Signing framework"
codesign --force --sign "${CERT_IDENTITY}" --deep "${XCFRAMEWORK_DIR}/macos-arm64_x86_64/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"
codesign --force --sign "${CERT_IDENTITY}" --deep "${XCFRAMEWORK_DIR}/macos-arm64_x86_64/${FRAMEWORK_NAME}.framework"
codesign --force --sign "${CERT_IDENTITY}" --deep "${XCFRAMEWORK_DIR}"


echo "*****************************************"
echo "* Verifining signinature"
codesign --all-architectures -v --strict --deep --verbose=1 "${XCFRAMEWORK_DIR}"
echo "Signinature is OK"
