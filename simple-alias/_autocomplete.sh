#!/bin/bash
MAIN_OPT="-a -l -c -r -h -v -e [NAME]"
function _cmd_spal(){
	COMPREPLY=()
	local cur=${COMP_WORDS[COMP_CWORD]}
	local option="$MAIN_OPT"
	COMPREPLY=($(compgen -W "${option}" -- "${cur}"))
}
function _cmd_-e(){
	COMPREPLY=([NAME])
}
function _cmd_-a(){
	COMPREPLY=("[NAME] [COMMAND]")
}
function _cmd_-r(){
	COMPREPLY=([NAME])
}

function _cmd_hub(){
	case $COMP_CWORD in
	0)
		;;
	1)
		eval _cmd_${COMP_WORDS[0]}
		;;
	2)
		eval _cmd_${COMP_WORDS[1]}
		;;
	esac
}
complete -F _cmd_hub spal
