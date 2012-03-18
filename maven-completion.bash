#!/bin/bash

# 
# Completion for mvn and mvnDebug

_mvn(){
	# if pom.xml file exist in directory
	if [ -f pom.xml ]; then
		COMPREPLY=()
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local prev="${COMP_WORDS[COMP_CWORD-1]}"
		local opts="clean install package test site:site javadoc"

		local jetty_plugin_enable=`grep -i -c maven-jetty-plugin pom.xml`

		if [ ${jetty_plugin_enable} == 1 ]; then
			opts="${opts} jetty:run"
		fi


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

	else
		# if pom.xml file isn't exist in directory
		COMPREPLY=()
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local prev="${COMP_WORDS[COMP_CWORD-1]}"
		local opts="-v --version"

		if [[ "${cur}" == -* ]]	; then
			COMPREPLY=( $( compgen -W '-v --version' -- "${cur}" ))
		fi


	fi

	return 0
} &&

complete -F _mvn mvn
complete -F _mvn mvnDebug
