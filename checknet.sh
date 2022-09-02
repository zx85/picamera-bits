#!/usr/bin/bash

log () {
  logname="/var/log/scripts/$(basename $0 | sed 's/sh$/log/g')"
  thistime="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "${thistime} - $0 - $1" | tee -a $logname
}

timeoutfile=/tmp/timeout
pingip="192.168.75.1"
maxfail=4

touch ${timeoutfile}

log "Checking ${pingip}"
ping -q -w 10 "${pingip}" >/dev/null 
if [ $? -eq 0 ] ; then
   log "All good - blanking out the timeout"
   echo > /tmp/timeout
else
   curtimeout="0$(cat ${timeoutfile})"
   newtimeout=$(( ${curtimeout} + 1 ))
   log "Timed out - attempt ${newtimeout} of ${maxfail}"
   echo $newtimeout > ${timeoutfile}
   if [ $newtimeout -gt ${maxfail} ] ; then
       log "Too many failures, so rebooting."
       sudo reboot
   fi
fi

