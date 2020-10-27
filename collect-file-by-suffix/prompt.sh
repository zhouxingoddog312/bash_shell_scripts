#!/usr/bin/env bash
function _cmd_cfbs(){
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local option="-c -n -m -v -h"
	COMPREPLY=($(compgen -W "${option}" --  ${cur}))
}

#complete -F _cmd_cfbs ./cfbs.sh
complete -F _cmd_cfbs cfbs.sh
