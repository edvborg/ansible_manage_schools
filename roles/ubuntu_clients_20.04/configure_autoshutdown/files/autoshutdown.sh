#!/bin/bash
# automatisches Herunterfahren

user=$(who -H | grep -v 'root\|NAME' | awk '{print $1}')
homedir=$(getent passwd | grep $user | awk -F: '{print $6}')

## R.L. 1.4.2020 eingefügt:
if [ -z $user ] ; then /sbin/shutdown -h now ; fi

export XAUTHORITY=$homedir/.Xauthority
export DISPLAY=:0

zenity --question --timeout 120 --text='Der PC fährt in 2 Minuten herunter. Was wollen Sie tun?' --title='Auto shutdown' --ok-label='weiter arbeiten' --cancel-label='jetzt herunterfahren' --width=200 --height=100
res=$?

case $res in
 1|5)
	 /sbin/shutdown -h now
   ;;
  *)
	zenity --info --width=200 --text "Bitte am Ende den PC herunterfahren!"
   ;;
esac

exit 0

# Bei Klick auf 'herunterfahren' (res=1) oder ohne Klick (res=5) wird der PC heruntergefahren.
# Bei Klick auf 'weiterarbeiten' (res=0) geschieht nichts.
# ACHTUNG! Cancel- und Ok-Button wurden vertauscht, damit der Default-Knopf (Druck auf Enter-Taste) 'weiterarbeiten' ist.
 



