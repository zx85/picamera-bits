#!/bin/bash

log () {
  logname="/var/log/scripts/$(basename $0 | sed 's/sh$/log/g')"
  thistime="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "${thistime} - $0 - $1" | tee -a $logname
}


startpic=1
startvid=0001
srcdir=/media/dave/temp/pizero
destdir=/media/dave/temp/pizero-pics
destfile=${destdir}/housevideo.avi

if [ ! -d ${srcdir} ] ; then
   echo "${srcdir} isn't there - you might want to run this from pinfinity"
   exit 0
fi 

mkdir -p ${destdir}

pic=${startpic}

# Do the serial business
#totalpics=$(find ${srcdir} -name "2022*.jpg" | wc -l)
totalpics=$( find ${srcdir} -type f -regex '.*-1[1-9][0-9][0-9][0-9][0-9]\.jpg' | wc -l)
log "$totalpics pics to serialise"
for eachpic in $(find ${srcdir} -type f -regex '.*-1[1-9][0-9][0-9][0-9][0-9]\.jpg' | sort) ; do
   pic=$(( $pic + 1 ))
   picname=$(printf "%04d\n" $pic)
   log "$pic/$totalpics - copying $eachpic to ${destdir}/v1_$picname.jpg"
   cp $eachpic ${destdir}/v1_$picname.jpg
done

# Now make the vid
log "Making the video ${destfile}"
ffmpeg -y -f image2 -framerate 25 -pattern_type sequence -r 15  -start_number ${startvid} -i ${destdir}/v1_%04d.jpg ${destfile}
