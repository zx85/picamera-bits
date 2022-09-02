#!/usr/bin/bash
suntimedir="/home/pi/picamera-bits/tmp"

daytime () {
  log "checking daytime"
  isdaytime=0
  if [ -d ${suntimedir} ] ; then
    if [ -f ${suntimedir}/sunrise.txt ] && [ -f ${suntimedir}/sunset.txt ] ; then
      thistime=$(date +%s) 
      sunrise=$(cat ${suntimedir}/sunrise.txt)
      sunset=$(cat ${suntimedir}/sunset.txt)
      log "thistime is ${thistime}"
      log "sunrise is ${sunrise}"
      log "sunset is ${sunset}"
#      if [ ${thistime} -gt ${sunrise} ] ; then 
#        log "it is after sunrise"
#        if [ ${thistime} -lt ${sunset} ] ; then
#          log "it is before sunset"
#          isdaytime=0
#        fi
#      fi
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

if daytime ; then
  log "Daytime - taking the picture ${filename}"
#  libcamera-jpeg --height=972 --width=1296 -o ${filename}
else
  log "Not daytime, so not bothering."
fi

