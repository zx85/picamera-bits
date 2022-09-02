#!/usr/bin/env bash
suntimedir="/home/${USER}/picamera-bits/tmp"

daytime () {
  isdaytime=0
  if [ -d ${suntimedir} ] ; then
    if [ -f ${suntimedir}/sunrise.txt ] && [ -f ${suntimedir}/sunset.txt ] ; then
      suntime=$(date +%s)
      sunrise=$(cat ${suntimedir}/sunrise.txt)
      sunset=$(cat ${suntimedir}/sunset.txt)
      if [ ${suntime} -gt ${sunrise} ] && [ ${suntime} -lt ${sunset} ] ; then
          isdaytime=1
      fi
    else
      log "Missing sunrise.txt or sunset.txt in ${suntimedir} - please run suntime.sh"
      exit 1
    fi
  else
      log "Missing suntimedir - please run suntime.sh"   
      exit 1
  fi
  return ${isdaytime}
}

log () {
  logname="/var/log/scripts/$(basename $0 | sed 's/sh$/log/g')"
  thistime="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "${thistime} - $0 - $1" | tee -a $logname
}

srcdir="/media/cam"
filename="${srcdir}/$(date +%Y-%m-%d-%H%M%S).jpg"

daytime
if [ $? -eq 1 ] ; then
  log "Daytime - taking the picture ${filename}"
#  libcamera-jpeg --height=972 --width=1296 -o ${filename}
else
  log "Not daytime, so not bothering."
fi

