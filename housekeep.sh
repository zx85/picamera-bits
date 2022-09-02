#!/usr/bin/bash

log () {
  logname="/var/log/scripts/$(basename $0 | sed 's/sh$/log/g')"
  thistime="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "${thistime} - $0 - $1" | tee -a $logname
}

srcdir="/media/cam"
destdir="/media/data/temp/pizero"

log "Copying $(find ${srcdir}  -type f -mmin +1 -name "*.jpg" | wc -l) files from ${srcdir} to ${destdir}."
filelist=$(find ${srcdir} -type f -mmin +1 -name "*.jpg")
log "going through filelist, which looks like this:"
log "$(echo ${filelist})"
for eachfile in ${filelist} ; do
# check the destination directory exists
   destsubdir="${destdir}/$(echo ${eachfile} | awk -F\/ '{print substr($NF,1,10)}')"
   mkdir -p $destsubdir
# rotate the pic
  log "Rotating ${eachfile} and removing if successful."
  convert "$eachfile" -rotate 90  -gravity South -pointsize 30 -fill white -annotate +300+0 "$(basename ${eachfile} | awk '{print substr($0,1,13)":"substr($0,15,2)}')" "${destsubdir}/$(basename "$eachfile")"  && rm ${eachfile} || mv ${eachfile} "${destsubdir}/$(basename "$eachfile").DUFF"
done
