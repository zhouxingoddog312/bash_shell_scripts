#!/bin/bash
#dependence sed mp3info iconv
SOURCE_DIR=~/transfer
TARGET_DIR=~/cricetinae
SUB_CATEGORY=(music)

declare -A RELATION_LIST
RELATION_LIST=
(
	["mp3"]=mp3_handle
	["gba"]=generate_handle
)
source ./music.sh
#接受目标文件夹的绝对路径
function literate()
{
	for file in $(ls $1)
	do
		file=$1"/"$file
		if [ -d $file ]
		then
			literate $file
		else
			for suffix in $(cut -d , -f 1 $RELATION_LIST)
			do
				if [ ${file##*.} = $suffix ]
				then
					local func=$(sed -n /$suffix/p $RELATION_LIST|cut -d, -f2)
					$func $file
				fi
			done
		fi
	done
}
if ! [ -d $SOURCE_DIR ]
then
	exit 1
fi
literate $SOURCE_DIR
