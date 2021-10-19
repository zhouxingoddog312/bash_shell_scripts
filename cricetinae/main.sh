#!/bin/bash
#dependence ffprobe iconv
SOURCE_DIR=~/transfer
TARGET_DIR=~/cricetinae
SUB_CATEGORY=(music game)

declare -A RELATION_LIST
RELATION_LIST=\
(
	["mp3"]=mp3_handle
	["gba"]=generate_handle
)
source ./music.sh
function literate()
{
	#应该用循环代替递归
	#在这里，如果$1是相对路径，需要将其转换为绝对路径
	if [ "`ls -A $1`" ]
	#防止处理空目录
	then
		for file in "$(ls $1)"
		do
			file=$1"/""$file"
			if [ -d "$file" ]
			#递归处理子目录
			then
				literate "$file"
			else
				if ! [ -z ${RELATION_LIST["${file##*.}"]} ]
				#判断在关系数组中是否有处理函数存在
				then
					local func=${RELATION_LIST["${file##*.}"]}
					$func "$file"
				fi
			fi
		done
	fi
}
if ! [ -d $SOURCE_DIR ]
then
	mkdir -p $SOURCE_DIR
	exit 1
fi
literate $SOURCE_DIR
