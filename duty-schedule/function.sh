#接受一个年份的参数生成一个含有该年份所有日期的节假日标记的对照表
function gen_ori_calendar()
{
str=$(cat text|eval jq '.\"$s\"'|sed 'y/{}:/()=/'|sed -e 's/"/["/1' -e 's/"/"]/2' -e 's/ //g' -e 's/,/ /')
}
year=2023
for((i=0;i<=364;i++))
do
    # 格式化日期  
	date_format="%Y%m%d %A"  
	day=$(date -d "$year-01-01 + $i day" +"$date_format")
	dat=${day:0:8}
	echo $dat
	#val=$(curl -X GET "https://tool.bitefu.net/jiari/?d=$dat")
	echo $day$val
done
curl -X GET "https://tool.bitefu.net/jiari/?d=20230931"
