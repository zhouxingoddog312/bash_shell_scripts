#!/bin/bash
function version(){
	cat <<EOF
-------------------------------------------------
Name: cfbs - collect-file-by-suffix
version: 1.00
Author: goddog312
-------------------------------------------------
EOF
exit 0
}

function help(){
	cat <<EOF
---------------------------------------------------------------
Usage: cfbs [OPTIONS] [DIRECTORY] [SUFFIX] [TARGET-DIRECTORY]

-c copy those files to the specified directory
-n don't collect, but just list the files
-m move those files to the specified directory
-v output version information and exit
-h output help information and exit
---------------------------------------------------------------
EOF
exit 0
}


#convert relative path to absolute path
function relativepathtoabsolutepath(){
	abs_path=$PWD/$1
	mkdir -p /tmp/$abs_path
	cd /tmp/$abs_path
	abs_path=$PWD
	cd -
	rm -r $abs_path
	echo ${abs_path:4}
}
######################################

#judge the path is relative or absolute
function judge(){
	PATHNAME=$1
	JUDGEMENT=$(echo "$2"|sed -n '/^\./p')
	if [ -z "$JUDGEMENT" ]
	then
		PATHNAME="$2"
	else
		PATHNAME=$(relativepathtoabsolutepath $2)
	fi
	echo $PATHNAME
}
####################################

echo
while getopts :chmnv opt
do
	case "$opt" in
	v)
		version
		;;
	h)
		help
		;;
	c)
		option=c
		;;
	m)
		option=m
		;;
	n)
		option=n
		;;
	*)
		echo "invalid option"
		exit 1
		;;
	esac
done
shift $[ $OPTIND-1 ]
DIR=$(judge DIR "$1")
SUF=$2
TARG=$(judge TARG "$3")




if [ ! -d $TARG ]
then
	mkdir -p $TARG
fi

SUF=$(echo $SUF|sed  's/,/ /g')
for FILE_TYPE in $SUF
do
	case $option in
	c)
		if [ ! -d $DIR ]
		then
			echo "Directory isn't exist."
			exit 1
		fi
		TEMPDIR=$(mktemp -d $TARG/$FILE_TYPE.XXX)
		find $DIR -name "*.$FILE_TYPE"|xargs -I {} cp {} $TEMPDIR 2>>/tmp/cfbs.log
		;;
	m)
		if [ ! -d $DIR ]
		then
			echo "Directory isn't exits."
			exit 1
		fi
		TEMPDIR=$(mktemp -d $TARG/$FILE_TYPE.XXX)
		find $DIR -name "*.$FILE_TYPE"|xargs -I {} mv {} $TEMPDIR 2>>/tmp/cfbs.log
		;;
	n)
		echo "The type of $FILE_TYPE files:"
		find $DIR -name "*.$FILE_TYPE"
		echo
		;;
	esac
done

