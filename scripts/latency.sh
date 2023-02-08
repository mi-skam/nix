#!/bin/sh

dig cloud.miskam.xyz @9.9.9.9  +timeout=1 | tee /tmp/latencecheck

if [ $? -eq 0 ]
then
        time=$(awk '/Query time/{
                if($4 < 60) { print "_";}
                if($4 >= 60 && $4 <= 150) { print "-"; }
                if($4 > 150) { print "¯"; }
        }' /tmp/latencecheck)
        echo $time | tee /tmp/latenceresult
else
        echo "N" | tee /tmp/latenceresult
    exit 1
fi