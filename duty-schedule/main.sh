#!/bin/bash
#depend on sed,jq,zenity
#环境变量
WORK_DIR="$HOME/duty-shcedule"
SOURCE_DIR="$WORK_DIR/src"
DB_DIR="$SOURCE_DIR/database"
DB_PRE_CAL="$DB_DIR/cal."
DB_PRE_SCHE="$DB_DIR/sche."
source "./function.sh"
gen_calendar 2024
