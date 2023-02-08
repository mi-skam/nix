#!/bin/sh

## TODO: needs to be reworked for WSL!

if [ "$#" -eq 0 ]
then
        echo "usage: language [name] [path]"
        exit 1
fi

cat > /tmp/paste_upload <<EOF
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
</head>
<body>
        <link rel="stylesheet" href="default.min.css">
        <script src="highlight.min.js"></script>
        <script>hljs.initHighlightingOnLoad();</script>

        <pre><code class="$1">
EOF

# ugly but it works
cat /tmp/paste_upload | tr -d '\n' > /tmp/paste_upload_tmp
mv /tmp/paste_upload_tmp /tmp/paste_upload

if [ -f "$3" ]
then
    cat "$3" | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g' >> /tmp/paste_upload
else
    xclip -o | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g' >> /tmp/paste_upload
fi


cat >> /tmp/paste_upload <<EOF


</code></pre> </body> </html>
EOF


if [ -n "$2" ]
then
    NAME="$2"
else
    NAME=temp
fi

FILE=$(date +%s)_${1}_${NAME}.html

scp /tmp/paste_upload perso.pw:/var/www/htdocs/solene/prog/${FILE}

echo -n "https://perso.pw/prog/${FILE}" | xclip -selection clipboard
notify-send -u low "https://perso.pw/prog/${FILE}"