#!/usr/bin/env bash
#title           :clean_symlinks.sh
#description     :A script to remove broken symlinks
#author		 :Kevin Pillay
#date            :20180907
#version         :1.0
#usage		 :bash clean_symlinks.sh
#notes           :
#bash_version    :GNU bash, version 4.4.19(1)-release (x86_64-redhat-linux-gnu)
#==============================================================================

# Change the separator value to cater for paths with spaces
OIFS="$IFS"
IFS=$'\n'

function clean()
{
	MYPATH=$1
	for SYM in $(ls -1 $MYPATH)
	do
		printf "PATH: $MYPATH/$SYM\n"
		RESULT=$(/bin/readlink -q ${MYPATH}/${SYM})
		printf "Actuall:"
		/bin/readlink -q ${MYPATH}/${SYM}
		printf "RESULT : ${RESULT}\n"

#		if [[ -n "$RESULT" ]]
		if [[ -n "$RESULT" ]]
		then
			printf "Broken symlink: $(ls -l $MYPATH/$SYM)\n"
			#printf "rm -f \"$MYPATH/$SYM\"\n" | /bin/bash
		fi
	printf "\n"
	done
}

clean /dockers/plex/tvseries

# Set separator back to default
IFS="$OIFS"

