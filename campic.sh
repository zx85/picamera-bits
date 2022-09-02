#!/usr/bin/bash


log () {
  logname="/var/log/scripts/$(basename $0 | sed 's/sh$/log/g')"
  thistime="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "${thistime} - $0 - $1" | tee -a $logname
}

srcdir="/media/cam"
filename="${srcdir}/$(date +%Y-%m-%d-%H%M%S).jpg"

log "Taking the picture ${filename}"
libcamera-jpeg --height=972 --width=1296 -o ${filename}

