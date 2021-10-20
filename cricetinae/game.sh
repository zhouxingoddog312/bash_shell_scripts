function generate_handle()
{
	local suff=${1##*.}
	local target=$TARGET_DIR/${SUB_CATEGORY[1]}/$suff
	if ! [ -d $target ]
	then
		mkdir -p $target
	fi
	mv "$1" "$target"
}
