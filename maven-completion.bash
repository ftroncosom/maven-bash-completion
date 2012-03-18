#!/bin/bash

# 
# Completion for mvn and mvnDebug

_mvn(){

	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local prev="${COMP_WORDS[COMP_CWORD-1]}"
	local opts="clean install package test jetty:run site:site javadoc"

	case "${prev}" in
		clean)
			local clean_opts="install package deploy test compile test-compile"
			COMPREPLY=($(compgen -W "${clean_opts}"))
			return 0
			;;
		install)
			local install_opts="package deploy test -DskipTest=true"
			COMPREPLY=($(compgen -W "${install_opts}"))
			return 0
			;;
		deploy)
			local deploy_opts="-DskipTests=true"
			COMPREPLY=(${deploy_opts})
			return 0
			;;

		javadoc)
			local javadoc_opts="javadoc jar test-javadoc"
			COMPREPLY=($(compgen -W "${javadoc_opts}"))
			return 0
			;;
		*)
			COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
			return 0
			;;
	esac


	if [[ "${cur}" == -*  ]] ;then
		COMPREPLY=( $( compgen -W '-DskipTest=true' -- "${cur}") )
	fi

	return 0
} &&

complete -F _mvn mvn
complete -F _mvn mvnDebug
