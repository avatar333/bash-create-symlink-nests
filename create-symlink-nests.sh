#!/usr/bin/env bash
#title           :create-symlink-nests.sh
#description     :A script to scrape mount points and create symlink nests
#author		 :Kevin Pillay
#date            :20180627
#version         :0.1    
#usage		 :bash create-symlink-nests.sh
#notes           :
#bash_version    :GNU bash, version 4.4.19(1)-release (x86_64-redhat-linux-gnu)
#==============================================================================

# VAR / CONST
PREFIX=/mnt
PLEX_MOVIES=${PREFIX}/dockers/downloads/plex/movies
PLEX_TVSERIES=${PREFIX}/dockers/downloads/plex/tvseries
MNT_SCRAPE_PREFIX=src

SRCPREFIX=/tmp/src

OIFS="$IFS"
IFS=$'\n'

function exists_as_symlink()
{
	ADIR=$1
	if [[ -L ${PLEX_MOVIES}/$(basename $ADIR) ]]
	then
		echo 1
	else
		echo 0
	fi
}


function scrape_mount_points()
{
	for SRCDIR in $(ls -1d $SRCPREFIX/src_*/*)
	do
		if [[ $(exists_as_symlink $SRCDIR) -eq 0 ]]
		then
			printf "ln -sf \"$SRCDIR\" \"$PLEX_MOVIES/$(basename $SRCDIR)\"\n"
			printf "ln -sf \"$SRCDIR\" \"$PLEX_MOVIES/$(basename $SRCDIR)\"\n" | /bin/bash
		else
			printf "Symlink already exists: $(ls -d $PLEX_MOVIES/$(basename $SRCDIR))\n"
		fi
	done
}

scrape_mount_points

IFS="$OIFS"
