#!/bin/bash

# 
# Completion for mvn and mvnDebug
#
# Lifecycle default complete
# Options for mvn and mvnDebug
#
# Author: Francisco Collao
#

_mvn(){
	# if pom.xml file exist in directory
	if [ -f pom.xml ]; then
		COMPREPLY=()
		local cur="${COMP_WORDS[COMP_CWORD]}"
		local prev="${COMP_WORDS[COMP_CWORD-1]}"

		if [[ "${cur}" == *:* ]]; then

			case "${prev}" in
				jetty)
					local jetty_options="jetty:run jetty:war"
					COMPREPLY=($(compgen -S ' ' -W "${jetty_options}" -- "${cur}"))
					return 0
					;;
				javadoc)
					return 0
					;;
				release)
					return 0
					;;
			esac

		else
			local clean_lifecycle="pre-clean clean post-clean"

			local default_lifecycle="validate initialize generate-sources \
			process-sources generate-resources process-resources compile \
			process-classes generate-test-sources process-test-sources \
			generate-test-resources process-test-resources test-compile \
			process-test-classes test prepare-package package pre-integration-test \
			integration-test post-integration-test verify install deploy"
			
			local site_lifecycle="pre-site site post-site site-deploy"

			local plugins="jetty|javadoc|release"

			local replaced_plugins=`echo "${plugins}" | tr '|' '\n' | grep -e "^${cur}"`


			echo "CUR [${cur}]"

			if [[ ${cur} == "" ]]; then 
				COMPREPLY=( $(compgen -S ' ' -W "${clean_lifecycle} ${default_lifecycle} \
				${site_lifecycle} ${replaced_plugins}" -- "${cur}") )
			fi


			#if echo "${plugins}" | tr '|' '\n' | grep -q -e "^${cur}" ; then
			#	COMPREPLY=( $(compgen -S ':' -W "${replaced_plugins}" -- "${cur}" ) )
			#else
			#	COMPREPLY=( $(compgen -S ' ' -W "${clean_lifecycle} ${default_lifecycle} \
			#	${site_lifecycle} ${replaced_plugins}" -- "${cur}") )
			#fi

		fi

		if [[ "${cur}" == -D* ]] ; then
			local options="-DskipTests -Dmaven.test.skip=true"
			COMPREPLY=( $(compgen -S ' ' -W "${options}" -- "${cur}") )
		fi

		if [[ "${cur}" == -* ]] ; then
			local options="-am -amd -B -C -c -cpu -D -e -emp -ep -f -fae \
			-ff -fn -gs -h -l -N -npr -npu -nsu -o -P -pl -q -rf -s -T -t \
			-U -up -V -v -X"
			COMPREPLY=( $(compgen -S ' ' -W "${options}" -- "${cur}") )
		fi

		if [[ "${cur}" == --* ]] ; then
			local options="--version --update-plugins --update-snapshots --offline \
			--also-make --also-make-dependents --batch-mode --strict-checksums \
			--lax-checksums --check-plugin-updates --define --errors --encrypt-master-password \
			--encrypt-password --file --fail-at-end --fail-fast --fail-never \
			--global-settings --help --log-file --non-recursive --no-plugin-registry \
			--no-plugin-updates --no-snapshot-updates --no-snapshot-updates \
			--activate-profiles --projects --quiet --resume-from --settings \
			--threads --toolchains --show-version --debug"
			COMPREPLY=( $(compgen -S ' ' -W "${options}" -- "${cur}") )
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

#Detect maven-jetty-plugin in pom.xml file and add options to completion
detect_jetty_plugin(){
	local jetty_plugin_enable=`grep -i -c maven-jetty-plugin pom.xml`
	
	if [ ${jetty_plugin_enable} == 1 ]; then
		echo "jetty:run jetty:war"
	fi
}

complete -F _mvn mvn
complete -F _mvn mvnDebug
