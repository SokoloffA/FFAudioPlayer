#!/bin/bash

set -euo pipefail


SRC=player.cpp
OUT="FFAudioPlayer"


function add_lib() {
    local name=$1
    if [[ -f "${ROOT_DIR}/lib/lib${name}.a" ]]; then
        LIBS+=" ${ROOT_DIR}/lib/lib${name}.a"
        extralibs=extralibs_${name}
        OPTS+=" ${!extralibs}"
    else
        echo "Skip ${name} library";
    fi
}

. "${ROOT_DIR}/share/ffmpeg/config.sh"

OPTS+=" -ld_classic"

add_lib avcodec
add_lib avdevice
add_lib avfilter
add_lib avformat
add_lib avutil
add_lib swresample
add_lib swscale

export CPLUS_INCLUDE_PATH="${ROOT_DIR}/include"

clang++ -c -fPIC -O2 "backend.cpp" -o "backend.o"
clang++ -c -fPIC -O2 "FFAudioPlayer.cpp" -o "FFAudioPlayer.o"
clang++ -dynamiclib \
    -o "${OUT}" \
    "backend.o" \
    "FFAudioPlayer.o" \
    ${LIBS} \
    ${OPTS} \
    -Wl,-all_load \
    -lz -lm -pthread

install "${OUT}" "${ROOT_DIR}/lib"
install -m 644 "FFAudioPlayer.h" "${ROOT_DIR}/include/FFAudioPlayer.h"
