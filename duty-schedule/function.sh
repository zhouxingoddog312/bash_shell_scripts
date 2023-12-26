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
#工作日对应结果为0,休息日对应结果为1,节假日对应的结果为2
function gen_calendar()
{
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
	fi
	wait $COPROC_PID
}
#生成值班人员清单
function gen_stafflist()
{
	local ret_str
	local entry
	if [ -f $STAFF_LIST ]
	then
		ret_str=$(zenity --text-info --width=$WIDTH --height=$HEIGHT --title="是否使用此值班人员清单(不要修改此内容)" --filename="$STAFF_LIST" --ok-label "使用" --cancel-label "不使用" --editable)
		if [ $? -eq 0 ]
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
	zenity --info --width=$WIDTH --height=$HEIGHT --title="生成值班人员清单" --text="请按提示完成值班人员清单" --timeout=10
	ret_str=$(zenity --forms --width=$WIDTH --height=$HEIGHT --title="生成值班人员清单" --add-calendar="选择轮班开始第一天的日期" --add-entry="第一个值班人员姓名" --add-entry="第二个值班人员姓名" --add-entry="第三个值班人员姓名" --separator="|" --forms-date-format="%Y%m%d")
	while [ $? -ne 0 ]
	do
		ret_str=$(zenity --forms --width=$WIDTH --height=$HEIGHT --title="生成值班人员清单" --add-calendar="选择轮班开始第一天的日期" --add-entry="第一个值班人员姓名" --add-entry="第二个值班人员姓名" --add-entry="第三个值班人员姓名" --separator="|" --forms-date-format="%Y%m%d")
	done
	OLDIFS=$IFS
	IFS='|'
	for entry in $ret_str
	do
		echo $entry>>$STAFF_LIST
	done
	IFS=$OLDIFS
}
#依据节假日清单、值班人员清单、年份和排班策略生成该年度排班表
#接受参数：年份、排班策略序号
function gen_schedule()
{
	gen_stafflist
	gen_calendar $1
	eval "method_"$2 $1
}
#排班策略接受参数：年份
function method_1()
{

}
function method_2()
{

}



#主界面选项：打印年度排班表、年度值班时长统计
#获取要打印的年份和排班策略
#function interface
#{
	
#}
