#!/bin/bash

set -euo pipefail

FRAMEWORK_NAME=FFAudioPlayer

OUT_DIR=.build/tests
cmake -B${OUT_DIR} tests
make -C${OUT_DIR}
ln -sf ../../${FRAMEWORK_NAME}.xcframework ${OUT_DIR}

passed=0
failed=0
n=0

function test() {
    n=$(($n+1))

    if ${OUT_DIR}/FFAudioPlayer_Test $@; then
        passed=$(($passed+1))
    else
        failed=$(($failed+1))
    fi
}


########################

test http://sc2.radiocaroline.net:8040/
test http://www.rcgoldserver.com:8253
test http://stream.radioparadise.com/flac --skip-metadata
test http://sc3.radiocaroline.net:8030
test https://c22.radioboss.fm:8144/GamePlay
test https://mediaserviceslive.akamaized.net/hls/live/2038308/triplejnsw/index.m3u8 --skip-metadata

echo ""
echo "*********************************"
echo "Totals: ${passed} passed, ${failed} failed"
echo "*********************************"
exit $failed