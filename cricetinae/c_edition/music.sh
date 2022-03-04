function mp3_handle()
{
	local artist=`ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$1"`
	#提取艺术家名字是否有更好的方法，需解决ID3V1和ID3V2不同的问题，还有gb2312到UTF-8转换的问题
	local sor="$1"
	local target=$TARGET_DIR/${SUB_CATEGORY[0]}/$artist
	if ! [ -d $target ]
	then
		mkdir -p $target
	fi
	mv "$sor" "$target"
}
