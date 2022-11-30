#!/bin/bash
source ./config

if ! [ -d $PRE_DIR ]
then
	mkdir $PRE_DIR
fi


for rom_url in $ROM_URLS
do
	curl -O $rom_url -s --output-dir $PRE_DIR
	tmp_file=$PRE_DIR${rom_url##*/}
	tar_dir=${tmp_file%%%*}
	tar_list=${tar_dir%%%*}"/list.new"
	if ! [ -d $tar_dir ]
	then
		mkdir -p $tar_dir
	fi
	sed '{1,/[^文][完游][整戏]清单/d;/下载地址/,$d;s/<[^<>]*>//g;s/&#8211;/-/g;s/&nbsp;/ /g;s/&amp;/\&/g;/^ *$/d}' $tmp_file|sed '$a\\n解压密码oldmanemu.net'|sed -n 'w '"$tar_list"''
	rm $tmp_file
done
