#!/bin/bash

# 
# Completion for mvn and mvnDebug

_mvn(){

	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local prev="${COMP_WORDS[COMP_CWORD-1]}"
	local opts="clean install package test jetty:run site:site"

	case "${prev}" in
		clean)
			COMPREPLY=( $(compgen -f ${cur}) )
			return 0
			;;
		install)
			;;
	esac

	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )

}

complete -F _mvn mvn
complete -F _mvn mvnDebug
