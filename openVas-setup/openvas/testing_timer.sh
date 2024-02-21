#!/bin/bash

if [ ! -e timestamp ]; then
    d=$(date +%s)
    echo $d > timestamp
else
    d=$(cat timestamp)
fi

echo $d

dd=$(($d + 5))
echo $dd

e=$(date +%s)
if [ $e -gt $dd ]; then
    # do flip
    echo flipping
    echo $e > timestamp
fi

