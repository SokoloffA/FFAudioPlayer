#!/bin/bash

set -euo pipefail


FRAMEWORK_NAME=FFAudioPlayer
XCFRAMEWORK_DIR="./${FRAMEWORK_NAME}.xcframework"
CERT_IDENTITY="Developer ID Application: Alex Sokolov (635H9TYSZJ)"

#######################################

SCRIPT_DIR=`pwd`
PROC_NUM=`nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2`
ARCHITECTURES="arm64 x86_64"
ORIG_PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}"

export PROC_NUM=${PROC_NUM}
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin

function lazy_configure() {
    local re="$@"
    if grep -q -- "$re" "config.log"; then
        echo "Skip ./configure"
    else
        echo "Run ./configure $@"
        ./configure "$@"
    fi
}

export -f lazy_configure

function extaract_sources() {
    local project=$1

    if [ -d "${SCRIPT_DIR}/${project}/sources" ]; then
        echo "Syncing sources ........................."
        local in_dir="${SCRIPT_DIR}/${project}/sources"
        local out_dir="${BUILD_DIR}/sources"
        rsync -ra "${in_dir}/" "${out_dir}/"
        echo "Sources successfully synced ............."
        return 0
    fi

    if [ ! -d "sources" ]; then
        echo "Extractiong sources ....................."
        tar=`find ${SCRIPT_DIR}/${project} -type file -name "*.tar.gz" -or -name "*.tar.xz" -or -name "*.tar.bz2"`
        mkdir -p "sources"
        echo "    Extracting: ${tar}"
        tar -xf "${tar}" --strip-components=1 -C "sources"


        pushd "sources" 2>&1> /dev/null
        for f in `find -s "${SCRIPT_DIR}/${project}" -type file -name "*.patch"`; do
            echo "    Patching:   ${f}"
            patch -p1 --forward --silent --input "${f}"
        done
        popd 2>&1> /dev/null

        echo "Sources successfully extracted .........."
        return 0
    fi
}


function build() {
    local project=$1

    for arch in ${ARCHITECTURES}; do
        export BUILD_DIR="${SCRIPT_DIR}/.build/${project}/${arch}"
        export ARCH=${arch}
        export ROOT_DIR="${SCRIPT_DIR}/.build/${arch}_root"
        export PATH="${ROOT_DIR}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"
        export PKG_CONFIG_PATH="${ROOT_DIR}/lib/pkgconfig:${ORIG_PKG_CONFIG_PATH}"
        export CONF_DIR="${SCRIPT_DIR}/${project}"

        echo "*****************************************"
        echo "** ${project}"

        mkdir -p "${BUILD_DIR}"
        pushd "${BUILD_DIR}" 2>&1> /dev/null

        extaract_sources "${project}"

        pushd "sources" 2>&1> /dev/null

        echo "Building for ${arch} ........................"
        arch -${ARCH} /bin/bash "${SCRIPT_DIR}/${project}/build.sh" 2>&1 | tee ${BUILD_DIR}/build.log
        echo "Successfully built for ${arch} .............."

        popd 2>&1> /dev/null
        popd 2>&1> /dev/null
    done
}


function build_universal_framework() {
    local arm_dir="arm64_root"
    local x86_dir="x86_64_root"
    local out_dir="${FRAMEWORK_NAME}.framework"
    local a_dir="${out_dir}/Versions/A"

    rm -rf "${out_dir}"
    mkdir -p "${a_dir}"

    mkdir -p "${a_dir}/Headers"
    cp -a "${arm_dir}/include/FFAudioPlayer.h" "${a_dir}/Headers/${FRAMEWORK_NAME}.h"

    echo "Creating module.modulemap .................."
    mkdir -p ${a_dir}/Modules
    echo "framework module ${FRAMEWORK_NAME} {"          > "${a_dir}/Modules/module.modulemap"
    echo '    umbrella header "'${FRAMEWORK_NAME}.h'"'  >> "${a_dir}/Modules/module.modulemap"
    echo ''                                             >> "${a_dir}/Modules/module.modulemap"
    echo '    export *'                                 >> "${a_dir}/Modules/module.modulemap"
    echo '    module * { export * }'                    >> "${a_dir}/Modules/module.modulemap"
    echo '}'                                            >> "${a_dir}/Modules/module.modulemap"


    mkdir -p ${a_dir}/Resources
    cp -a "${SCRIPT_DIR}/Info.plist" "${a_dir}/Resources/Info.plist"

    echo "Processing libraries ......................."
    lipo "${arm_dir}/lib/${FRAMEWORK_NAME}" "${x86_dir}/lib/${FRAMEWORK_NAME}" -create -output "${a_dir}/${FRAMEWORK_NAME}"

    echo "Fixing @rpath ............................."
    local rpath=@rpath/${FRAMEWORK_NAME}.framework
    install_name_tool -id "${rpath}/${FRAMEWORK_NAME}" "${a_dir}/${FRAMEWORK_NAME}"

    install -l s A "${out_dir}/Versions/Current"
    for f in `ls "${a_dir}"`; do
        install -l s "Versions/Current/$f" "${out_dir}/"
    done
}


# ***************************
build pkgconf
build nasm
build ffmpeg
build ffaudioplayer

echo "*****************************************"
echo "* Building for universal framework..."
pushd "${SCRIPT_DIR}/.build" 2>&1> /dev/null
build_universal_framework
popd 2>&1> /dev/null


echo "*****************************************"
echo "* Building xcframework"
rm -rf "${XCFRAMEWORK_DIR}"
xcodebuild \
    -create-xcframework \
    -framework "${SCRIPT_DIR}/.build/${FRAMEWORK_NAME}.framework" \
    -output "${XCFRAMEWORK_DIR}"


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
