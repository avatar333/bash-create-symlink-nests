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
SRCPREFIX=/mnt

# Text color variables
TXTUND=$(tput sgr 0 1)          # Underline
TXTBLD=$(tput bold)             # Bold
BLDRED=${TXTBLD}$(tput setaf 1) # red
BLDGRN=${TXTBLD}$(tput setaf 2) # green
BLDYEL=${TXTBLD}$(tput setaf 3) # yellow
BLDBLU=${TXTBLD}$(tput setaf 4) # blue
BLDWHT=${TXTBLD}$(tput setaf 7) # white
TXTRST=$(tput sgr0)             # Reset

if [[ $# -lt 1 ]]
then
        printf "\nNo parameters supplied\nValid options: movies|tvseries|anime|doccies|anime_movies|all\n\n"
        exit 0
fi

# Change the separator value to cater for paths with spaces
OIFS="$IFS"
IFS=$'\n'

# Check if the directory exists at the target
function directory_exists()
{
	DIRECTORY=$1
	if [[ -d ${DIRECTORY} ]]
	then
		echo 1
	else
		echo 0
	fi
}

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
	SRCPATH=$2
	if [[ $TYPE = "movies" ]]
	then
		TARG=$PLEX_MOVIES
	elif [[ $TYPE = "tvseries" ]]
	then
		TARG=$PLEX_TVSERIES
	fi

	printf "TARG : $TARG\n"

	TARG=/dockers/plex/Kishan_movies
	SRCPATH=/mnt/src_media01-1TB/media-kishan/Movies

	for SRCDIR in $(ls -1d ${SRCPATH}/*)
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
DOCKER_PLEX_DIRNAME=$1
SRC_DIR=$2

if [[ $(directory_exists $DOCKER_PLEX_DIRNAME) -eq 0 ]]
then
	printf "Directory ${BLDYEL}${DOCKER_PLEX_DIRNAME}${TXTRST} does not exist, creating...\n"
	printf "mkdir -p $DOCKER_PLEX_DIRNAME\n"
else
	printf "Directory ${BLDGRN}${DOCKER_PLEX_DIRNAME}${TXTRST} does exist\n"
fi

# Set separator back to default
IFS="$OIFS"
