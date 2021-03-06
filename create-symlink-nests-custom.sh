#!/usr/bin/env bash
#title           :create-symlink-nests-custom.sh
#description     :A script to create custom Plex symlinks
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
        printf "\nNo parameters supplied\n"
	printf "USAGE: $(basename $0) <full path to source directory>\n\n"
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

########
# MAIN #
########
SRC_DIR=$1
DOCKER_PLEX_DIRNAME=$2

if [[ $(exists_as_symlink ${PLEX_ROOT_PATH}/$(basename $SRC_DIR)) -eq 0 ]]
then
        printf "Creating symlink ${BLDGRN}${PLEX_ROOT_PATH}/${DOCKER_PLEX_DIRNAME} -> $SRC_DIR ${TXTRST}\n"
        printf "ln -sf \"$SRC_DIR\" \"${PLEX_ROOT_PATH}\n"
        printf "ln -sf \"$SRC_DIR\" \"${PLEX_ROOT_PATH}\n" | /bin/bash

else
	printf "Symlink ${BLDGRN}${PLEX_ROOT_PATH}/${DOCKER_PLEX_DIRNAME}${TXTRST} already exists\n"
	exit 0
fi



# Set separator back to default
IFS="$OIFS"
