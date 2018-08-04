#!/usr/bin/env bash
#title           :create-symlink-nests.sh
#description     :A script to scrape mount points and create symlink nests
#author		 :Kevin Pillay
#date            :20180627
#version         :1.0
#usage		 :bash create-symlink-nests.sh
#notes           :
#bash_version    :GNU bash, version 4.4.19(1)-release (x86_64-redhat-linux-gnu)
#==============================================================================

# VAR / CONST
PREFIX=/dockers
PLEX_ROOT_PATH=${PREFIX}/plex
PLEX_MOVIES=${PLEX_ROOT_PATH}/movies
PLEX_TVSERIES=${PLEX_ROOT_PATH}/tvseries
SRCPREFIX=/mnt/src

# Change the separator value to cater for paths with spaces
OIFS="$IFS"
IFS=$'\n'

# Check if the directory exists at the target and is a symlink
function exists_as_symlink()
{
	ADIR=$1
	TTYPE=$2
	if [[ -L ${PLEX_ROOT_PATH}/${TTYPE}/$(basename $ADIR) ]]
	then
		echo 1
	else
		echo 0
	fi
}

# Traverse mount points and create symlinks in target paths
function scrape_mount_points()
{
	TYPE=$1
	if [[ $TYPE = "movies" ]]
	then
		TARG=$PLEX_MOVIES
	elif [[ $TYPE = "tvseries" ]]
	then
		TARG=$PLEX_TVSERIES
	fi

	printf "TARG : $TARG\n"

	for SRCDIR in $(ls -1d $SRCPREFIX/src_*/${TYPE}/*)
	do
		if [[ $(exists_as_symlink $SRCDIR $TYPE) -eq 0 ]]
		then
			printf "ln -sf \"$SRCDIR\" \"$TARG/$(basename $SRCDIR)\"\n"
			printf "ln -sf \"$SRCDIR\" \"$TARG/$(basename $SRCDIR)\"\n" | /bin/bash
		else
			printf "Symlink already exists: $(ls -d $TARG/$(basename $SRCDIR))\n"
		fi
	done
}

########
# MAIN #
########
scrape_mount_points movies
scrape_mount_points tvseries

# Set separator back to default
IFS="$OIFS"
