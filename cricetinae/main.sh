#!/bin/bash
#dependence sed mp3info
SOURCE_DIR=~/transfer
TARGET_DIR=~/cricetinae
SUB_CATEGORY=(music)
RELATION_LIST=list

source ./music.sh
local identifiable=0
if ! [ -d $SOURCE_DIR ]
then
	exit 1
fi
for files in $(ls -R|sed /:$/d)
do
	for suffix in $(cut -d , -f 1 $RELATION_LIST)
	do
		if [ ${file##*.} = $suffix ]
		then
			identifiable=1
			local func=$(sed -n /$suffix/p|cut -d, -f2)
		fi
	done
	if [ $identifiable -eq 1 ]
	then
		$func $files
	fi
done
