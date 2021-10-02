function mp3_handle()
{
	local artist=`mp3info -p %a "$1"|iconv -f gb2312 -t UTF-8`
	local sor=$1
	local target=$TARGET_DIR/${SUB_CATEGORY[0]}/$artist
	if ! [ -d $target ]
	then
		mkdir -p $target
	fi
	mv $sor $target
}
