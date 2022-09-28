#!/bin/bash
#设定主机的目标目录，主机的目标用户，主机
TargetUser="goddog312"
TargetHost="192.168.0.106"
RootDirectory="/share/family/game/"

#定义目录清单变量（数组），由于遍历目录清单的需要，需保存目录清单的数量。定义保存选定的目录的变量。
#定义选定的目录下rom清单的变量（数组），定义选定的rom。
#目录清单及rom清单的index将与dialog --menu获得的label对应
declare -a directory_list
declare -i directory_list_len
temp_directory=""
declare -a game_list
declare -i game_list_len
temp_game=""

#创建一个临时文件以保存目录、文件的选择
trans_file=$(mktemp -t transfer.XXXXXX)


#获取目标目录下子目录的清单
index=0
subentry=$(ssh $TargetUser@$TargetHost "ls $RootDirectory")
while read directory_list[$index]
do
	((index++))
done<<EOF
$subentry
EOF
#由于多执行了一次read，数组的最后一个元素必定为空，所以舍去
unset directory_list[$index]
directory_list_len=index
subentry=""

#生成label item的字符串，作为--menu的参数
index=0
for((index=0;index<$directory_list_len;index++))
do
	subentry=$subentry"$index ${directory_list[$index]} "
done
#将当前选定的子目录保存在变量中
dialog --menu 0 0 10 $subentry 2>$trans_file
temp_directory=$(cat $trans_file)


#获取选定目录下rom的清单
index=0
subentry=$(ssh $TargetUser@$TargetHost "ls $RootDirectory$temp_directory")
while read game_list[$index]
do
	((index++))
done<<EOF
$subentry
EOF
unset game_list[$index]
game_list_len=index
subentry=""
index=0
for((index=0;index<$game_list_len;index++))
do
	subentry=$subentry"$index ${game_list[$index]} "
done
dialog --menu 0 0 10 $subentry 2>$trans_file
temp_game=$(cat $trans_file)

#取回选定的rom
scp -r $TargetUser@$TargetHos:$RootDirectory$temp_directory/$temp_game ./
