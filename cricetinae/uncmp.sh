function zip_handle()
{
	unzip "$1"&&rm -rf "$1"
}
function rar_handle()
{
	unrar e -p- -inul "$1"&&rm -rf "$1"
}
