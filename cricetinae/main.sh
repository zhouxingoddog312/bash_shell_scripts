#!/bin/bash
#dependence ffprobe iconv
SOURCE_DIR=~/transfer
TARGET_DIR=~/cricetinae
SUB_CATEGORY=(music)

declare -A RELATION_LIST
RELATION_LIST=\
(
	["mp3"]=mp3_handle
	["gba"]=generate_handle
)
source ./music.sh
function literate()
{
	#在这里，如果$1是相对路径，需要将其转换为绝对路径
	for file in "$(ls $1)"
	do
		#在这里需要解决，如果文件或目录名的编码是gb2312，则将其转换为UTF-8
		file=$1"/""$file"
		if [ -d "$file" ]
		then
			literate "$file"
		else
			if ! [ -z ${RELATION_LIST["${file##*.}"]} ]
			then
				local func=${RELATION_LIST["${file##*.}"]}
				$func "$file"
			fi
		fi
	done
}
if ! [ -d $SOURCE_DIR ]
then
	exit 1
fi
literate $SOURCE_DIR
