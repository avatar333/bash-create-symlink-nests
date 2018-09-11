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
PLEX_ANIME=${PLEX_ROOT_PATH}/anime
PLEX_DOCCIES=${PLEX_ROOT_PATH}/doccies
PLEX_ANIME_MOVIES=${PLEX_ROOT_PATH}/anime_movies
SRCPREFIX=/mnt

WHATTYPE=$1

if [[ $# -lt 1 ]]
then
	printf "\nNo parameters supplied\nValid options: movies|tvseries|anime|doccies|anime_movies\n\n"
	exit 0
fi

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
#	if [[ $TYPE = "movies" ]]
#	then
#		TARG=$PLEX_MOVIES
#	elif [[ $TYPE = "tvseries" ]]
#	then
#		TARG=$PLEX_TVSERIES
#	elif [[ $TYPE = "anime" ]]
#	then
#		TARG=$PLEX_ANIME
#	elif [[ $TYPE = "doccies" ]]
#	then
#		TARG=$PLEX_DOCCIES
#	fi

	TARG=${PLEX_ROOT_PATH}/${TYPE}	

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

case $WHATTYPE in
	movies)
	  scrape_mount_points movies
	;;
	tvseries)
	  scrape_mount_points tvseries
	;;
	anime)
	  scrape_mount_points anime
	;;
	doccies)
	  scrape_mount_points doccies
	;;
	anime_movies)
	  scrape_mount_points anime_movies
	;;
	all)
	  for IS in movies tvseries anime doccies anime_movies
	  do
		  scrape_mount_points $IS
	  done
	;;
esac

# Set separator back to default
IFS="$OIFS"

