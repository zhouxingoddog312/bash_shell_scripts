#! /bin/bash
#depend on sed,7z,tofrodos,imagemagick
CUR_DIR=`pwd`
SOURCE_DIR=$CUR_DIR/"source"
TRANSF_DIR=$CUR_DIR/"transf"
TARGET_DIR=$CUR_DIR/"target"
LOG=$CUR_DIR/"logfile"
METADATA_TITLE=$SOURCE_DIR/"metadata_title"
METADATA_LAUNCH=$SOURCE_DIR/"metadata_launch"
METADATA_GAMES=$SOURCE_DIR/"metadata_games"
declare -A games_roms
declare -A games_medias
declare -A games_descriptions
source ./functions
version
help
haswkdir
#check_source
generate_database $METADATA_GAMES
