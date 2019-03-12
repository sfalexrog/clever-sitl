#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${SCRIPT_DIR}/px4

${SCRIPT_DIR}/px4/px4 ${SCRIPT_DIR}/px4 ${SCRIPT_DIR}/px4/configs/SITL/init/ekf2/clever_opt_flow

