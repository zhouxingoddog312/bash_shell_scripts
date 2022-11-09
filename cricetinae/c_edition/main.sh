#!/bin/bash

TARGET_DIR=~/cricetinae
SUB_CATEGORY=(music game)
DATE=$(date +%Y.%m.%d-%H:%M)
exec 8>&1
exec 9>&2


if ! [ -d $TARGET_DIR ]
then
	mkdir -p $TARGET_DIR/log
fi

exec 1>"$TARGET_DIR""/log/""routinelog"."$DATE"
exec 2>"$TARGET_DIR""/log/""errorlog"."$DATE"

declare -A RELATION_LIST
declare -A UNCOMPRESS_LIST
declare -A HANDLE_LIST
#解压缩函数
UNCOMPRESS_LIST=\
(
	["zip"]=zip_handle
	["rar"]=rar_handle
	["7z"]=p7z_handle
)
#类型文件归档函数
HANDLE_LIST=\
(
	["mp3"]=mp3_handle
	["flac"]=mp3_handle
	["mpga"]=mp3_handle
	["gba"]=generate_handle
	["gb"]=generate_handle
	["gbc"]=generate_handle
	["nds"]=generate_handle
)
source ./music.sh
source ./uncmp.sh
source ./game.sh
#此函数遍历目标目录，并用RELATION_LIST中对应的函数处理文件
function traverse()
{
	if [ -d $1 ]
	then
		pushd -n $1
	fi
	while popd
	do
		OLDIFS=$IFS
		IFS=$'\n'
		for file in $(ls)
		do
			file="$PWD""/""$file"
			if [ -d "$file" ]
			then
				pushd -n "$file"
			elif ! [ -z ${RELATION_LIST["${file##*.}"]} ]
			then
				local func=${RELATION_LIST["${file##*.}"]}
				$func "$file"
			fi
		done
		IFS=$OLDIFS
	done
}
#赋予解压函数
for keys in ${!UNCOMPRESS_LIST[*]}
do
	RELATION_LIST[$keys]=${UNCOMPRESS_LIST[$keys]}
done
#解压缩所有文件
#注意，只解压一遍，所以压缩包内还是压缩文件的只处理了一次。对于有密码的压缩文件，解压失败
traverse $1
#赋予类型文件处理函数
unset RELATION_LIST
declare -A RELATION_LIST
for keys in ${!HANDLE_LIST[*]}
do
	RELATION_LIST[$keys]=${HANDLE_LIST[$keys]}
done

#按类型归档
traverse $1


exec 1>&8
exec 2>&9
