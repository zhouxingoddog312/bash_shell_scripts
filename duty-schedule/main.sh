#!/bin/bash
#depend on sed,curl,jq,zenity
#环境变量
WORK_DIR="$HOME/duty-schedule"
SOURCE_DIR="$WORK_DIR/src"
DB_DIR="$SOURCE_DIR/database"
DB_PRE_CAL="$DB_DIR/cal."
DB_PRE_SCHE="$DB_DIR/sche."
STAFF_LIST="$SOURCE_DIR/staff.lst"

declare -i TOTAL_STAFF=3
declare -i WIDTH=800
declare -i HEIGHT=600


source "./function.sh"

help
version

install_sed
install_jq
install_zenity
install_curl

gen_wkdir
gen_schedule 2024 1
summarize 2023 1
