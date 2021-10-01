function mp3_handle()
{
	local artist=`mp3info -p %t "$1"`
	local sor=$SOURCE_DIR/$1
	local target=$TARGET_DIR/${SUB_CATEGORY[0]}/$artist
	if ! [ -d $target ]
	then
		mkdir -p $target
	fi
	mv $sor $target
}
