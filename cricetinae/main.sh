#!/bin/bash
#dependence ffprobe iconv
SOURCE_DIR=~/transfer
TARGET_DIR=~/cricetinae
SUB_CATEGORY=(music game)

declare -A RELATION_LIST
declare -A UNCOMPRESS_LIST
declare -A HANDLE_LIST
UNCOMPRESS_LIST=\
(
	["zip"]=zip_handle
	["rar"]=rar_handle
	["7z"]=p7z_handle
)
HANDLE_LIST=\
(
	["mp3"]=mp3_handle
	["gba"]=generate_handle
	["nds"]=generate_handle
	["psp"]=generate_handle
)
source ./music.sh
source ./uncmp.sh
source ./game.sh
function literate()
{
	#应该用循环代替递归
	#在这里，如果$1是相对路径，需要将其转换为绝对路径
	if [ "`ls -A $1`" ]
	#防止处理空目录
	then
		for file in $(ls $1)
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
if ! [ -d $TARGET_DIR ]
then
	mkdir -p $TARGET_DIR
fi
#RELATION_LIST=UNCOMPRESS_LIST
for keys in ${!UNCOMPRESS_LIST[*]}
do
	RELATION_LIST[$keys]=${UNCOMPRESS_LIST[$keys]}
done
literate $SOURCE_DIR&>>$TARGET_DIR/uncompress.log

#RELATION_LIST=HANDLE_LIST
unset RELATION_LIST
declare -A RELATION_LIST
for keys in ${!HANDLE_LIST[*]}
do
	RELATION_LIST[$keys]=${HANDLE_LIST[$keys]}
done
literate $SOURCE_DIR
