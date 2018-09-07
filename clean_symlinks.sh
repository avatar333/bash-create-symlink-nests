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

function clean()
{
	MYPATH=$1
	for SYM in $($MYPATH)
	do
		OUTPUT=$(readlink $MYPATH/$SYM)
		if [[ -n $OUTPUT ]]
		then
			printf "Broken symlink: $(ls -l $MYPATH/$SYM)\n"
			printf "rm -f $MYPATH/$SYM\n"
		fi
	done
}

clean /dockers/plex/tvseries
