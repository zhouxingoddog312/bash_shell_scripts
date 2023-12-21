#帮助信息
function help()
{
	cat <<EOF
---------------------------------------------------------------------------------------------
Usage:
---------------------------------------------------------------------------------------------

EOF
}
#版本信息
function version()
{
	cat <<EOF
---------------------------------------------------------------------------------------------
Name: 
Version: 0.01
Author: goddog312
contact:1820034020@qq.com
---------------------------------------------------------------------------------------------
EOF
}
#install dependencies
#install sed
function install_sed()
{
	if command -v sed &>/dev/null
	then
		echo "sed工具已安装。"
	else
		echo "脚本需要sed工具。"
		if command -v apt &>/dev/null
		then
			sudo apt update
			sudo apt install -y sed
		elif command -v dnf &>/dev/null
		then
			sudo dnf install -y sed
		elif command -v yum &>/dev/null
		then
			sudo yum install -y sed
		else
			echo "请手动安装sed工具。"
			exit 1
		fi
		echo "sed工具已安装。"
	fi
}
#install jq
function install_jq()
{
	if command -v jq &>/dev/null
	then
		echo "jq工具已安装。"
	else
		echo "脚本需要jq工具。"
#判断包管理器
		if command -v apt &>/dev/null
		then
#使用apt(Debian/Ubuntu)
			sudo apt update
			sudo apt install -y jq
		elif command -v dnf &>/dev/null
		then
#使用dnf(Fedora)
			sudo dnf install -y jq
		elif command -v yum &>/dev/null
		then
#使用yum(CentOS/Red Hat)
			sudo yum install -y jq
		else
			echo "请手动安装jq工具。"
			exit 1
		fi
		echo "jq工具已安装。"
	fi
}
#install zenity
function install_zenity()
{
	if command -v zenity &>/dev/null
	then
		echo "zenity工具已安装。"
	else
		echo "脚本需要zenity工具。"
#判断包管理器
		if command -v apt &>/dev/null
		then
#使用apt(Debian/Ubuntu)
			sudo apt update
			sudo apt install -y zenity
		elif command -v dnf &>/dev/null
		then
#使用dnf(Fedora)
			sudo dnf install -y zenity
		elif command -v yum &>/dev/null
		then
#使用yum(CentOS/Red Hat)
			sudo yum install -y zenity
		else
			echo "请手动安装zenity工具。"
			exit 1
		fi
		echo "zenity工具已安装。"
	fi
}
#如果不存在工作目录就创建工作目录。
function gen_wkdir()
{
	if [ ! -d $WORK_DIR ] || [ ! -d $SOURCE_DIR ] || [ ! -d $DB_DIR ]
	then
		mkdir -p $DB_DIR
	fi
}
#接受一个年份的参数生成一个含有该年份所有日期的节假日标记的对照表
function gen_calendar()
{
	local ret_str
	local year
	local calendar=$DB_PRE_CAL$1
#如果该年度的节假日表不存在就生成一个
	if [ ! -e $calendar ]
	then
		ret_str=$(curl -sX GET "https://tool.bitefu.net/jiari/?d=$1")
		year=$(echo $ret_str|eval jq .'\"$1\"')
		if [ ! "$year" = "false" ] && [ ! "$year" = "null" ]
		then
			echo $year
		fi
	fi
}
#ret_str=$(curl -sX GET "https://tool.bitefu.net/jiari/?d=$1"|eval jq '.\"$1\"')
#str=$(cat text|eval jq '.\"$s\"'|sed 'y/{}:/()=/'|sed -e 's/"/["/1' -e 's/"/"]/2' -e 's/ //g' -e 's/,/ /')
#year=2023
#for((i=0;i<=364;i++))
#do
#    # 格式化日期  
#	date_format="%Y%m%d %A"  
#	day=$(date -d "$year-01-01 + $i day" +"$date_format")
#	dat=${day:0:8}
#	echo $dat
#	#val=$(curl -X GET "https://tool.bitefu.net/jiari/?d=$dat")
#	echo $day$val
#done
#curl -X GET "https://tool.bitefu.net/jiari/?d=20230931"
