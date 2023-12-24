#!/bin/bash
#depend on sed,jq,zenity
#环境变量
WORK_DIR="$HOME/duty-shcedule"
SOURCE_DIR="$WORK_DIR/src"
DB_DIR="$SOURCE_DIR/database"
DB_PRE_CAL="$DB_DIR/cal."
DB_PRE_SCHE="$DB_DIR/sche."
STAFF_LIST="$SOURCE_DIR/staff.lst"

declare -i WIDTH=800
declare -i HEIGHT=600


source "./function.sh"

help
version

install_sed
install_jq
install_zenity

gen_wkdir
gen_calendar 2024
gen_stafflist
