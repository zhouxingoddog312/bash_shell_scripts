function zip_handle()
{
	unzip -d $SOURCE_DIR "$1"&&rm -rf "$1"
}
function rar_handle()
{
	cd $SOURCE_DIR;unrar e -p- "$1"&&rm -rf "$1"
	cd -
}
function p7z_handle()
{
	7za e -y -o$SOURCE_DIR "$1"&&rm -rf "$1"
}
