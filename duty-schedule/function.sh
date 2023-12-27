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
#install curl
function install_curl()
{
	if command -v curl &>/dev/null
	then
		echo "curl工具已安装。"
	else
		echo "脚本需要curl工具。"
		if command -v apt &>/dev/null
		then
			sudo apt update
			sudo apt install -y curl
		elif command -v dnf &>/dev/null
		then
			sudo dnf install -y curl
		elif command -v yum &>/dev/null
		then
			sudo yum install -y curl
		else
			echo "请手动安装curl工具。"
			exit 1
		fi
		echo "curl工具已安装。"
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
#接受参数：年份
#接受一个年份的参数生成含有该年份所有日期的节假日标记的对照表
#工作日对应结果为0,休息日对应结果为1,节假日对应的结果为2
#应该递归生成该年份向前至轮班开始那一年的所有节假日对照表，因为要从轮班那一天开始推算排班
#此处应该保证调用此函数时，已生成值班人员清单
function gen_calendar()
{
	local init_date
	read init_date<$STAFF_LIST
	init_date=${init_date:0:4}
	if [ $1 -gt $init_date ]
	then
		local -i temp_year=$1
		gen_calendar $[ temp_year - 1 ]
	fi
	local flag
	local entry
	local date_format="%Y%m%d	%A"
	local day
	local calendar=$DB_PRE_CAL$1
#如果该年度的节假日表不存在就生成一个
	if [ ! -e $calendar ]
	then
		touch $calendar
#使用zenity显示数据生成进度
		coproc zenity --progress --width=$WIDTH --height=$HEIGHT --title="年度节假日数据生成中" --text="正在获取$1年度节假日数据" --percentage=0 --no-cancel --auto-close
#平年364，闰年365
		for((i=0;i<=364;i++))
		do
			entry=$(date -d "$1-01-01 + $i day" +"$date_format")
			day=${entry:0:8}
			flag=$(curl -sX GET "https://tool.bitefu.net/jiari/?d=$day")
#flag的结果只能是0,1,2
			if [ $flag -ne 0 ] && [ $flag -ne 1 ] && [ $flag -ne 2 ]
			then
				zenity --error --width=$WIDTH --height=$HEIGHT --title="数据获取失败" --text="获取年度节假日数据失败，请检查网络及相关情况并重新启动脚本。"
				exit 1
			fi
			entry=$entry"	$flag"
			echo $entry>>$calendar
#因为免费api限制一秒内最多访问两次
			if [ ! $((i%2)) -eq 0 ]
			then
				sleep 1
			fi
			echo $((i*100/364))
		done>& ${COPROC[1]}
		wait $COPROC_PID
	fi
}
#生成值班人员清单
function gen_stafflist()
{
	local init_date
	local ret_str
	local entry
	if [ -f $STAFF_LIST ]
	then
		ret_str=$(zenity --text-info --width=$WIDTH --height=$HEIGHT --title="是否使用此值班人员清单(不要修改此内容)" --filename="$STAFF_LIST" --ok-label "使用" --cancel-label "不使用" --editable)
#验证日期格式是否正确
		read init_date <<<"$ret_str"
#验证人员清单行数正确
		if [ $? -eq 0 ] && [ -n "`sed -n '/^[1-9][0-9][0-9][0-9][0-1][0-9][0-3][0-9]$/p' <<<"$init_date"`" ] && [ `wc -w <<<"$ret_str"` -eq $[ TOTAL_STAFF + 1 ] ]
		then
			cat /dev/null >$STAFF_LIST
			for entry in $ret_str
			do
				echo $entry>>$STAFF_LIST
			done
			return 0
		fi
	fi
	cat /dev/null >$STAFF_LIST
	zenity --info --width=$WIDTH --height=$HEIGHT --title="生成值班人员清单" --text="请按提示完成值班人员清单" --timeout=5
	ret_str=$(zenity --forms --width=$WIDTH --height=$HEIGHT --title="生成值班人员清单" --add-calendar="选择轮班开始第一天的日期" --add-entry="第一个值班人员姓名" --add-entry="第二个值班人员姓名" --add-entry="第三个值班人员姓名" --separator="|" --forms-date-format="%Y%m%d")
#验证日期格式是否正确
	read -d '|' init_date <<<"$ret_str"
	while [ $? -ne 0 ] || [ -z "`sed -n '/^[1-9][0-9][0-9][0-9][0-1][0-9][0-3][0-9]$/p' <<<"$init_date"`" ]
	do
		ret_str=$(zenity --forms --width=$WIDTH --height=$HEIGHT --title="生成值班人员清单" --add-calendar="选择轮班开始第一天的日期" --add-entry="第一个值班人员姓名" --add-entry="第二个值班人员姓名" --add-entry="第三个值班人员姓名" --separator="|" --forms-date-format="%Y%m%d")
#验证日期格式是否正确
		read -d '|' init_date <<<"$ret_str"
	done
	OLDIFS=$IFS
	IFS='|'
	for entry in $ret_str
	do
		echo $entry>>$STAFF_LIST
	done
	IFS=$OLDIFS
}
#排班策略接受参数：年份
#不区分工作日或者节假日，按固定轮次依次轮转
#应该递归生成该年份向前至轮班开始那一年的所有排班表
function method1()
{
	local cal="$DB_PRE_CAL$1"
#判断该年度排班表是否存在，如果存在则不做任何操作
	local schd="$DB_PRE_SCHE""$1""-1"
	if [ -f "$schd" ]
	then
		return 0
	fi
#递归的生成该年份向前至轮班开始那一年的排班表
	local init_year
	read init_year<$STAFF_LIST
	init_year=${init_year:0:4}
	if [ $1 -gt $init_year ]
	then
		local -i temp_year=$1
		method1 $[ temp_year - 1 ]
	fi
#利用值班人员清单获取轮班开始的日期和值班人员数组
	exec 6<&0
	exec 0<$STAFF_LIST
	local -a staff
	local -i init_date
	local str
	read init_date
	while read str
	do
		staff+=("$str")
	done
	exec 0<&6
#分为两种情况：
	local line
	local -i index=0
	if [ $1 -eq ${init_date:0:4} ]
	then
#轮班开始的那一年，日期从轮班开始的日期起算，数组的下标从0开始
		exec 5<&0
		exec 0<$cal
		exec 6>&1
		exec 1>$schd
		while read line
		do
			if [ "$init_date" = "`cut -d' ' -f1 <<<$line`" ]
			then
				line="$line""	"${staff[$index]}
				echo $line
				((index++))
				if [ $index -gt 2 ]
				then
					index=0
				fi
				while read line
				do
					line="$line""	"${staff[$index]}
					echo $line
					((index++))
					if [ $index -gt 2 ]
					then
						index=0
					fi
				done
			fi
		done
		exec 0<&5
		exec 1>&6
	else
#非轮班开始的那一年，日期从1月1日起算，数组下标由上一年的12月31日对应的值班人的下标加1开始
		local pre_year=$1
		pre_year=$[ pre_year - 1 ]
		local pre_schd="$DB_PRE_SCHE""$pre_year""-1"
		local last_one=$(tail -n1 $pre_schd|cut -d' ' -f4)
		case $last_one in
		${staff[0]})
			index=1;;
		${staff[1]})
			index=2;;
		${staff[2]})
			index=0;;
		esac
		exec 5<&0
		exec 0<$cal
		exec 6>&1
		exec 1>$schd
		while read line
		do
			line="$line""	"${staff[$index]}
			echo $line
			((index++))
			if [ $index -gt 2 ]
			then
				index=0
			fi
		done
		exec 0<&5
		exec 1>&6
	fi
}
#工作日为一个轮次，周末及节假日为一个轮次，分两个轮次依次轮转
#function method2()
#{

#}
#依据节假日清单、值班人员清单、年份和排班策略生成该年度排班表
#接受参数：年份、排班策略序号
function gen_schedule()
{
#现有策略2
#年份不能超过来年，因为无法获取来年过后的节假日对照表
	local -i up=$(date +%Y)
	up=$[ up + 1 ]
	if [ $1 -gt $up ] || [ $2 -lt 1 ] || [ $2 -gt 2 ]
	then
		zenity --error --width=$WIDTH --height=$HEIGHT --title="无效的数据获取" --text="获取年份或获取策略错误"
		exit 1
	fi
	gen_stafflist
#指定的年份不能小于轮班开始的那一年
	local init_date
	read init_date<$STAFF_LIST
	init_date=${init_date:0:4}
	if [ $1 -lt $init_date ]
	then
		zenity --error --width=$WIDTH --height=$HEIGHT --title="无效的数据获取" --text="不能获取还未开始轮班的年份"
		exit 1
	fi
#应该递归生成该年份向前至轮班开始那一年的所有节假日对照表，因为要从轮班那一天开始推算排班
	gen_calendar $1
	eval "method"$2 $1
}
#主界面选项：打印年度排班表、年度值班时长统计
#获取要打印的年份和排班策略
#function interface
#{
	
#}
