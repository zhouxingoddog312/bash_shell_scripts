#!/bin/bash


ROM_URLS="https://www.oldmanemu.net/%e6%8e%8c%e6%9c%ba%e6%b8%b8%e6%88%8f/3ds/3ds%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e6%8e%8c%e6%9c%ba%e6%b8%b8%e6%88%8f/nds/nds%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e6%8e%8c%e6%9c%ba%e6%b8%b8%e6%88%8f/psp/psp%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e6%8e%8c%e6%9c%ba%e6%b8%b8%e6%88%8f/gba/gba%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e6%8e%8c%e6%9c%ba%e6%b8%b8%e6%88%8f/gb-gbc/gbc%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e6%8e%8c%e6%9c%ba%e6%b8%b8%e6%88%8f/gb-gbc/gb%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/ps3/ps3%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/ps2/ps2%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/ps1/ps1%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/dc/dc%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/n64/n64%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/sfc/sfc%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/md/md%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/fc/fc%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86 https://www.oldmanemu.net/%e5%ae%b6%e6%9c%ba%e6%b8%b8%e6%88%8f/xbox360/xbox360%e4%b8%ad%e6%96%87%e6%b8%b8%e6%88%8f%e5%85%a8%e9%9b%86"
#rom清单来源https://www.oldmanemu.net/，种类有3ds、nds、gba、gbc、gb、psp、ps3、ps2、ps1、dc、n64、sfc、md、fc、xbox360


for rom_url in $ROM_URLS
do
	curl -O $rom_url -s
	tmp_file=${rom_url##*/}
	tar_list=${tmp_file%%%*}".list.new"
	sed '{1,/[^文][完游][整戏]清单/d;/下载地址/,$d;s/<[^<>]*>//g;s/&#8211;/-/g;s/&nbsp;/ /g;s/&amp;/\&/g;/^ *$/d}' $tmp_file|sed '$a\\n解压密码oldmanemu.net'|sed -n 'w '"$tar_list"''
	rm $tmp_file
done
