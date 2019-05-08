#!/bin/bash
#
guestdir=`find /tmp -name 'guest*' -type d`
#
if [ -f $guestdir/.config/monitors.xml ] ; then 
     echo "yes"
   else 
     echo "keine monitors.xml gefunden"
     exit 0
fi
#
cp $guestdir/.config/monitors.xml /home2/guest-prefs/.config/
#

