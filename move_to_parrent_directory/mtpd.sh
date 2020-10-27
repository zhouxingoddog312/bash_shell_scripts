#!/bin/bash
function version(){
	cat << EOF
--------------------------------------------
Name: mtpd - move to parrent directory
Version: 1.00
Author: goddog312
--------------------------------------------
EOF
exit 0
}

function error(){
	echo "Usage: mtpd [OPTIONS] [DIRECTORY]"
	exit 1
}

#The follow function accept two options,if there have two or more same names of directory in the hierarchy,-l for the long path, and -s for the short
function newpath(){
	if [ $# -eq 2 ]
	then
		local options=$1
		local target="$2"
	else
		local options="-l"
		local target="$1"
	fi
	local oldpath=$(pwd)
	List=$(echo $oldpath|gawk 'BEGIN{RS="/"}{print $1}'|sed -n '/.*'$target'.*/p')
	case "$options" in
	-l)
		target=$(echo $List|gawk '{print $NF}')
		oldpath=${oldpath%$target*}
		oldpath=$oldpath$target
		;;
	-s)
		target=$(echo $List|gawk '{print $1}')
		oldpath=${oldpath%%$target*}
		oldpath=$oldpath$target
		;;
	esac
	echo $oldpath
	unset op
	unset options
	unset target
	unset oldpath
	unset List
}
while getopts :lsv opt
do
	case "$opt" in
	v)
		version
		;;
	l|s)
		option="-"$opt
		;;
	*)
		error
		;;
	esac
done
shift $[ $OPTIND-1 ]
if [ $# -ne 1 ]
then
	error
fi
specified_directory=$1
specified_directory=$(newpath $option $specified_directory)
echo "$specified_directory"
cd "$specified_directory"
unset OPTIND
unset opt
unset option
unset specified_directory
