#! /bin/bash
#depend on sed,7z,unix2dos,zenity
CUR_DIR=`pwd`
SOURCE_DIR=$CUR_DIR/"source"
TRANSF_DIR=$CUR_DIR/"transf"
TARGET_DIR=$CUR_DIR/"target"
LOG=$CUR_DIR/"logfile"
ROMS_SUB_DIRNAME=""
METADATA_TITLE=$TRANSF_DIR/"metadata_title"
METADATA_LAUNCH=$TRANSF_DIR/"metadata_launch"
METADATA_GAMES=$TRANSF_DIR/"metadata_games"

exec 4>&2
exec 2>"$LOG"

declare -i WIDTH=$[ COLUMNS * 3 ]
declare -i HEIGHT=$[ LINES * 3 ]
declare -A games_roms
declare -A games_medias
declare -A games_descriptions
declare -a games_selected
source ./functions
version
help
haswkdir
check_source
generate_database $METADATA_GAMES
select_result
check_target
move_files

exec 2>&4
