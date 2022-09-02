#!/usr/bin/env bash
datadir=/home/${USER}/picamera-bits/tmp
mkdir -p $datadir
thisjson=$(curl -s "https://api.sunrise-sunset.org/json?lat=52.249&long=0.739&formatted=0")
date +%s -d $(echo ${thisjson} | jq '.results.sunrise' | sed 's/"//g') > $datadir/sunrise.txt
date +%s -d $(echo ${thisjson} | jq '.results.sunset' | sed 's/"//g') > $datadir/sunset.txt

