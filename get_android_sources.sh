#! /bin/sh

# This source is part of the
#      _____  ___   ____
#  __ / / _ \/ _ | / __/___  _______ _
# / // / , _/ __ |/ _/_/ _ \/ __/ _ `/
# \___/_/|_/_/ |_/_/ (_)___/_/  \_, /
#                              /___/
# repository.
#
# Copyright 2011 Benoit 'BoD' Lubek (BoD@JRAF.org).  All Rights Reserved.

# get_android_sources.sh
#
# v1.00
#
# A script to help downloading the Android sources and copy them to your sdk 
# directory, so you can see them in Eclipse.
# This script uses the excellent project 'browse-androidsdk-sources-in-eclipse'
# at http://code.google.com/p/browse-androidsdk-sources-in-eclipse/.
# Please see the issue http://code.google.com/p/android/issues/detail?id=979
# for an explanation of why all this is needed.
# Get the lastest version of this script here: https://github.com/BoD/get_android_sources


echo
echo
echo '0/ Checking preconditions and setting variables'
echo
hash curl 2>&- || { echo >&2 "curl is missing.  If you are on Ubuntu, try 'sudo apt-get curl'.  Aborting."; exit 1; }
hash python 2>&- || { echo >&2 "python is missing.  If you are on Ubuntu, try 'sudo apt-get python'.  Aborting."; exit 1; }
echo

tag=
while [ -z $tag ]
do
    echo -n "Tag to get (list available at http://android.git.kernel.org/?p=platform/frameworks/base.git;a=tags - for instance 'android-2.3.3_r1.1'): "
    read tag
done

echo
sdkdir=
while [ -z $sdkdir ]
do
    echo -n "Target directory (for instance '/home/bod/android-sdk-linux_86/platforms/android-9'): "
    read sdkdir
done

echo
echo
echo '1/ Downloading repo and copy_sources.py scripts'
echo
if [ -d "bin" ]; then
	echo 'bin directory already exists: skipping download'
else
	mkdir bin
	curl https://android.git.kernel.org/repo > bin/repo
	chmod a+x bin/repo
	curl http://browse-androidsdk-sources-in-eclipse.googlecode.com/svn/trunk/copy_sources.py > bin/copy_sources.py
	chmod a+x bin/copy_sources.py
fi

echo
echo
echo '2/ Initializing repo'
echo

if [ -d "WORKING_DIRECTORY" ]; then
	echo 'WORKING_DIRECTORY directory already exists: switching branch'
else
	mkdir WORKING_DIRECTORY
fi

cd WORKING_DIRECTORY
../bin/repo init -u git://android.git.kernel.org/platform/manifest.git -b $tag

echo
echo
echo '3/ Downloading the sources (this can take a while)'
echo
../bin/repo sync


echo
echo
echo '4/ Executing copy_sources.py'
echo
cd ..
python bin/copy_sources.py WORKING_DIRECTORY $sdkdir

echo
echo
echo 'And voila!'
echo

