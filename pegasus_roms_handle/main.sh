#! /bin/bash
#depend on sed,7z
CUR_DIR=`pwd`
SOURCE_DIR=$CUR_DIR/"source"
TRANSF_DIR=$CUR_DIR/"transf"
TARGET_DIR=$CUR_DIR/"target"
METADATA_TITLE=$SOURCE_DIR/"metadata_title"
METADATA_LAUNCH=$SOURCE_DIR/"metadata_launch"
METADATA_GAMES=$SOURCE_DIR/"metadata_games"
ROMS_LIST=$SOURCE_DIR/"roms_list"
declare -A game_roms
declare -A game_medias
source ./functions
version
help
haswkdir
#check_source
generate_database $METADATA_GAMES
