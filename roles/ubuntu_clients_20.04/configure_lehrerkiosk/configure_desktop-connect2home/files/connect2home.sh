#!/bin/bash
#
#
USERNAME=$(zenity --entry --title="Mit persönlichem Ordner verbinden" --text="Geben Sie den Benutzernamen für das Schulnetz ein:" )
#echo $USERNAME  
# 
PASSWORD=$(zenity --entry --title="Passwort" --hide-text --text="Geben Sie das Passwort ein:" )
#
#
#
gio mount "smb://samba/$USERNAME" <<EOF
$USERNAME
BORG-IBK.LOCAL
$PASSWORD
EOF
#
sleep 1
#
nautilus smb://samba/$USERNAME &
 
