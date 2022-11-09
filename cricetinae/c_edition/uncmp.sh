function zip_handle()
{
	unzip -n -O GBK "$1"&&rm -rf "$1"
}
function rar_handle()
{
	unrar e -p- -o- "$1"&&rm -rf "$1"
}
function p7z_handle()
{
	7za e -y -scsUTF-8 "$1"&&rm -rf "$1"
}
