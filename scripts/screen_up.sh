#!/bin/sh

# TODO: needs to be reworked for WSL!

test -f /tmp/capture.png && rm /tmp/capture.png
scrot -s /tmp/capture.png
pngquant -f /tmp/capture.png
convert /tmp/capture-fs8.png /tmp/capture.jpg
FILE=$(ls -1Sr /tmp/capture* | head -n 1)
EXTENSION=${FILE##*.}

MD5=$(md5 -b "$FILE" | awk '{ print $4 }' | tr -d '/+=' )

ls -l $MD5

scp -P 22022 $FILE maksim@pub.miskam.xyz:/webroot/pub.miskam.xyz/i/${MD5}.${EXTENSION}

URL="https://pub.miskam.xyz/i/${MD5}.${EXTENSION}"
echo "$URL" | xclip -selection clipboard

notify-send -u low $URL