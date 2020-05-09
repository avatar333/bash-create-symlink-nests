#!/usr/bin/env bash
#title           :create-symlink-nests-loop.sh
#description     :A script to scrape directories and create symlinks to the contents in directory that Plex will be pointed to
#author		 :Kevin Pillay
#date            :20200509
#version         :1.0
#usage		 :bash create-symlink-nests-loop.sh
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


MYSRCDIR=$1
TARGDIR=$2

if [[ $# -lt 1 ]]
then
	printf "\nNo parameters supplied\nUsage: $(basename $0) <path to dir that contains directories/files> <path to dir that will host the symbolic links>\n\n"
	exit 0
fi

# Change the separator value to cater for paths with spaces
OIFS="$IFS"
IFS=$'\n'

# Check if the directory exists at the target and is a symlink
function exists_as_symlink()
{
	ADIR=$1
	if [[ -L ${TARGDIR}/$ADIR ]]
	then
		echo 1
	else
		echo 0
	fi
}

# Traverse mount points and create symlinks in target paths
function scrape_dir()
{
	TARG=$TARGDIR

	printf "\n ${BLDWHT}TARGET : $TARG${TXTRST}\n"

	for SRCDIR in $(ls -1d $MYSRCDIR/*)
	do
		if [[ $(exists_as_symlink $(basename $SRCDIR)) -eq 0 ]]
		then
			printf "${BLDGRN}ln -sf \"$SRCDIR\" \"$TARG/$(basename $SRCDIR)\"${TXTRST}\n"
			printf "ln -sf \"$SRCDIR\" \"$TARG/$(basename $SRCDIR)\"\n" | /bin/bash
		else
			printf "Symlink already exists: $(ls -d $TARG/$(basename $SRCDIR))\n"
		fi
	done
}

########
# MAIN #
########

scrape_dir

# Set separator back to default
IFS="$OIFS"

