#!/bin/bash
#
#
USERNAME=$(zenity --entry --title="Mit persönlichem Ordner verbinden" --text="Geben Sie den Benutzernamen für das Schulnetz ein:" )
#echo $USERNAME  
# 
nautilus -n --no-desktop "smb://borg-ibk.local;$USERNAME@borgserver://$USERNAME" 
