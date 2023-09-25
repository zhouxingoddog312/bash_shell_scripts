#! /bin/bash
#depend on sed,7z,tofrodos,imagemagick,zenity
CUR_DIR=`pwd`
SOURCE_DIR=$CUR_DIR/"source"
TRANSF_DIR=$CUR_DIR/"transf"
TARGET_DIR=$CUR_DIR/"target"
TARGET_ROM=""
TARGET_MEDIA=""
LOG=$CUR_DIR/"logfile"
METADATA_TITLE=$TRANSF_DIR/"metadata_title"
METADATA_LAUNCH=$TRANSF_DIR/"metadata_launch"
METADATA_GAMES=$TRANSF_DIR/"metadata_games"
declare -A games_roms
declare -A games_medias
declare -A games_descriptions
source ./functions
version
help
haswkdir
#check_source
generate_database $METADATA_GAMES
#################测试
#str=$(select_interface)
#OLDIFS=$IFS
#IFS='|'
#declare -a array
#read -ra array <<<"$str"
#echo ${array[@]}
###################
