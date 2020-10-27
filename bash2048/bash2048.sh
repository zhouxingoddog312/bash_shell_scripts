#!/bin/bash


#help information
function help(){
	cat <<EOF
--------------------------------------------------------------------------------------------------
Usage: $1 [-b INTEGER] [-t INTEGER] [-l FILE] [-r] [-h] [-v]

	-b INTEGER	--	specify game board size (sizes 3-9 allowed)
	-t INTEGER	--	specify target score to win (needs to be power of 2)
	-l FILE		--	logged debug information to specified file
	-r		--	reload the previous game
	-h		--	help information
	-v		--	version information
---------------------------------------------------------------------------------------------------
EOF
}

#version information
function version(){
	cat <<EOF
----------------------------------------------------------------------------------------------------
Name: bash2048
Version: 1.00
Author: goddog312
----------------------------------------------------------------------------------------------------
EOF
}
###########################
#some important variables##
###########################
declare -ia board		#this array keep all values for each piece on the board
declare -i pieces=0		#number of pieces present on board
declare -i score=0		#store the current score
declare -i flag_skip		#flag that prevents doing more than one operation on single field in one step
declare -i moves		#store number of possible moves to determine are you lost the game or not
declare ESC=$'\e'		#escape byte
declare header="Bash 2048 v1.0"	#print on the top of screen

#start time of the program
declare -i start_time=$(date +%s)


#############################################
#default config, some can modify by options##
#############################################
declare -i board_size=4
declare -i target=2048
declare -i reload_flag=0
declare config_dir="$HOME/.bash2048"


################################
##temp variables for once game##
################################
declare last_added		#the piece latest generated
declare first_round		#the piece that generate in the first round
declare -i index_max=$[$board_size-1]
declare -i fields_total=$[$board_size*$board_size]

########################
#for colorizing number##
########################
declare -a colors
colors[2]=32		#green text
colors[4]=34		#blue text
colors[8]=33		#yellow text
colors[16]=36		#cyan text
colors[32]=35		#purple text

colors[64]="1;47;32"	#white background green text
colors[128]="1;47;34"	#white background bule text
colors[256]="1;47;33"	#white background yellow text
colors[512]="1;47;36"	#white background cyan text
colors[1024]="1;47;35"	#white background purple text
colors[2048]="1;41;32"	#red background green text


trap "end_game 0 1" INT	#handle INT signal

#print current status of the game, the last added piece are red text
function print_board(){
	clear
	printf "**************************************************************\n"
	printf "***********************$header*************************\n"
	printf "*$ESC[1;5;33mpieces=%-11d   target=%-11d   score=%-12d$ESC[0m*\n" $pieces $target $score
	printf "**************************************************************\n"
	echo
	printf "/------"
	for((row=1;row<=index_max;row++))
	do
		printf "+------"
	done
	printf '\\\n'
	for((row=0;row<=index_max;row++))
	do
		printf "|"
		for((line=0;line<=index_max;line++))
		do
			if let ${board[$row*$board_size+$line]}
			then
				if let '(last_added==(row*board_size+line))|(first_round==(row*board_size+line))'
				then
					printf "$ESC[1;33m %4d $ESC[0m|" ${board[$row*$board_size+$line]}
				else
					printf "$ESC[${colors[${board[$row*$board_size+$line]}]}m %4d $ESC[0m|" ${board[$row*$board_size+$line]}
				fi
			else
				printf "      |"
			fi
		done
		if ((row!=index_max))
		then
			printf "\n|------"
			for((r=1;r<=index_max;r++))
			do
				printf "+------"
			done
			printf "|\n"
		fi
	done
	printf '\n\\------'
	for((row=1;row<=index_max;row++))
	do
		printf "+------"
	done
	printf "/\n"
}

#generate new piece on board
#generate a pos
#generate a value in board[pos]
#update last_added
#update pieces
function generate_piece(){
	while true
	do
		((pos=RANDOM%fields_total))
		let ${board[$pos]} ||{ let value=RANDOM%10?2:4;board[$pos]=$value;last_added=$pos;break;}
	done
	((pieces++))
}

#perform push operation between two pieces
#variables:
#		$1:push position, for horizontal push is column,for vertical is row
#		$2:recipient piece, this will store result if moving or join
#		$3:originator piece, after moving or join this piece will left empty
#		$4:direction of push, can be either "up" , "donw" , "left" or "right"
#		$5:if anything was passed, do not perform the push, but only update number of valid moves. Used for function check_moves
#		$board:the status of the game board
#		$change:indicates if the board was changed this round
#		$flag_skip:indicates the recipient piece cannot be modified further
function push_pieces(){
	case $4 in
	"up")
		let "first=$2*$board_size+$1"
		let "second=($2+$3)*$board_size+$1"
		;;
	"down")
		let "first=($index_max-$2)*$board_size+$1"
		let "second=($index_max-$2-$3)*$board_size+$1"
		;;
	"left")
		let "first=$1*$board_size+$2"
		let "second=$1*$board_size+$2+$3"
		;;
	"right")
		let "first=$1*$board_size+($index_max-$2)"
		let "second=($1*$board_size)+($index_max-$2-$3)"
		;;
	esac
	if ((board[$first]))
	then
		if ((board[$second]))
		then
			let flag_skip=1
		fi
		if ((board[$first]==board[$second]))
		then
			if [ -z $5 ]
			then
				let board[$first]*=2
				if ((board[$first]==target))
				then
					end_game 1
				fi
				let board[$second]=0
				let pieces-=1
				let change=1
				let score+=${board[$first]}
			else
				let moves++
			fi
		fi
	else
		if ((board[$second]))
		then
			if [ -z $5 ]
			then
				let board[$first]=${board[$second]}
				let board[$second]=0
				let change=1
			else
				let moves++
			fi
		fi
	fi
}

function apply_push(){
	for((i=0;i<=index_max;i++))
	do
		for((j=0;j<=index_max;j++))
		do
			let flag_skip=0
			let increment_max=index_max-j
			for((k=1;k<=increment_max;k++))
			do
				if ((flag_skip))
				then
					break
				fi
				push_pieces $i $j $k $1 $2
			done
		done
	done
}
function check_moves(){
	let moves=0
	apply_push "up" fake
	apply_push "down" fake
	apply_push "left" fake
	apply_push "right" fake
}
function key_react(){
	let change=0
	read -d '' -sn 1
	if [ "$REPLY" = "$ESC" ]
	then
		read -d '' -sn 1
		if [ "$REPLY" = "[" ]
		then
			read -d '' -sn 1
			case $REPLY in
			A)
				apply_push up;;
			B)
				apply_push down;;
			C)
				apply_push right;;
			D)
				apply_push left;;
			esac
		fi
	else
		case $REPLY in
		k)
			apply_push up;;
		j)
			apply_push down;;
		h)
			apply_push left;;
		l)
			apply_push right;;

		w)
			apply_push up;;
		s)
			apply_push down;;
		a)
			apply_push left;;
		d)
			apply_push right;;
		esac
	fi
}

function save_game(){
	rm -rf "$config_dir"
	mkdir -p "$config_dir"
	echo "${board[*]}">"$config_dir/board"
	echo "$board_size">"$config_dir/board_size"
	echo "$pieces">"$config_dir/pieces"
	echo "$target">"$config_dir/target"
	echo "$score">"$config_dir/score"
	echo "$first_round">"$config_dir/first_round"
}

function reload_game(){
	if [ ! -d "$config_dir" ]
	then
		return
	else
		board=(`cat "$config_dir/board"`)
		board_size=`cat "$config_dir/board_size"`
		pieces=`cat "$config_dir/pieces"`
		target=`cat "$config_dir/target"`
		score=`cat "$config_dir/score"`
		first_round=`cat "$config_dir/first_round"`
		let fields_total=board_size**2
		let index_max=board_size-1
	fi
}


#print game duration
#print total score
#print end or achieve information
#choose save game or not
function end_game(){
	stty echo
	end_time=`date +%s`
	let total_time=end_time-start_time
	duration=`date -u -d @${total_time} +%T`
	print_board
	printf "Your score: $score\n"
	printf "Your game lasted $duration.\n"
	if (($1))
	then
		printf "Congratulations you have achieved $target!\n"
		exit 0
	fi
	if [ ! -z $2 ]
	then
		read -n1 -p "Do you want to overwrite saved game?[Y|N]: "
		if [ "$REPLY" = "Y" ]||[ "$REPLY" = "y" ]
		then
			save_game
			printf "\nGame saved! Use -r option next to load this game.\n"
			exit 0
		else
			printf "\nGame not saved!\n"
			exit 0
		fi
	fi
	printf "\nYou have lost, better luck next time.\n"
	exit 0
}


#parse command line options
while getopts ":b:t:l:rhv" opt
do
	case $opt in
	b)
		let board_size="$OPTARG"
		let '(board_size>=3)&(board_size<=9)'||{ printf "Invalid board size, please choose size between 3 and 9\n";exit 1;}
		;;
	t)
		let target="$OPTARG"
		printf "obase=2;$target\n"|bc|grep  -e '^1[^1]*$'
		let $? && { printf "Invalid target, have to be power of two\n";exit 1;}
		;;
	l)
		echo "This function have not be implement."
		exit 0
		;;
	r)
		let reload_flag=1
		;;
	h)
		help $0
		exit 0
		;;
	v)
		version
		exit 0
		;;
	\?)
		printf "Invalid option -$opt, please $0 -h\n">&2
		exit 1
		;;
	:)	
		printf "Option -$opt requires an argument, please $0 -h\n">&2
		exit 1
		;;
	esac
done

let index_max=board_size-1
let fields_total=board_size**2

for((index=0;index<fields_total;index++))
do
	let board[$index]=0
done
generate_piece
let first_round=$last_added
generate_piece
if ((reload_flag))
then
	reload_game
fi

while true
do
	print_board
	key_react
	let change&&generate_piece
	let first_round=-1
	if ((pieces==fields_total))
	then
		check_moves
		if ((moves==0))
		then
			end_game 0
		fi
	fi
done
