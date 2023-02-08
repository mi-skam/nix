#!/bin/sh

## Requires BurnToast to be installed and imported
## Install-Module -Name BurntToast

FILE="$1"


if [ -z "$1" ]
then
        echo "usage: [file]"
        exit 1
fi
                
                
MD5=$(md5sum -b "$1" | awk '{ print $1 }')
NAME=${MD5}.${FILE##*.}

scp -P 22022 "${FILE}" maksim@pub.miskam.xyz:/webroot/pub.miskam.xyz/f/"${NAME}"

URL="https://pub.miskam.xyz/f/${NAME}"
echo -n "$URL" | clip.exe

wsl-notify "$URL" 