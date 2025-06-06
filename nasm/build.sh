#!/bin/bash

set -euo pipefail

[ -f ${ROOT_DIR}/bin/nasm ] && exit

CONFIGURE_FLAGS+=" --prefix=${ROOT_DIR}"
CONFIGURE_FLAGS+=" --quiet"

lazy_configure ${CONFIGURE_FLAGS}
make -j ${PROC_NUM}
make install
