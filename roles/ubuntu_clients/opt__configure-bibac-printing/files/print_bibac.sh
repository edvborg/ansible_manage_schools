#!/bin/bash
# Dieses Skript konvertiert die Ausgabe von Bibac 
# und versendet eine pdf-Datei an den Drucker
#
# NOTWENDIG: unoconv
#         sudo apt-get install unoconv
#
#
#
# Wenn die PDF-Dateien über das Kontexmenü ausgewählt werden, ist das Argument $1 schon gesetzt
# Sonst mit dem File-Dialog auswählen:
#
# Eintrag für das Menü:
# (dann kann man print_bibac.sh im Kontextmenü auswählen!)
#
#
# rudi@X-200-Ladi:~$ cat /usr/share/applications/print_bibac.desktop 
# [Desktop Entry]
# Version=1.0
# Name=Bibac-Dokument_an Drucker senden
# Comment=Bibac-Dokument_an Drucker senden
# MimeType=application/pdf;application/vnd.fdf;application/vnd.adobe.pdx;application/vnd.adobe.xdp+xml;application/vnd.adobe.xfdf;
# Exec=/usr/local/bin/print_bibac.sh %F
# Type=Application
# Icon=/usr/local/share/uniflow/uniflow.png
# Categories=GTK;GNOME;Application;Office;Viewer;
#
#

#zenity --info  --timeout=1 --width=300 --title="Zum Kopierer senden" --text="Ein BIBAC Text-Datei wird zum Kopierer gesendet"

vorlage="/opt/print_bibac/vorlage.ott"

if [ -z "$1" ]; then
    cd $HOME/Schreibtisch/
    file=`zenity --width=1020 --title='Welche PDF-Datei soll gedruckt werden?' --file-selection --file-filter '*.txt' `
    #  
    ls -al $file	 

else
    file=$1
    ls -al $file	 
fi



#timestamp=$(date +%Y%m%d-%T)
#newfile=$file"."$timestamp
#cp $file $newfile

cat $file | sed 's/ *//g' |  awk ' BEGIN {FS="|"} { print $3 "\t" $4 "\t" $9 }' | sed -r '/^\s*$/d'  > file_temp
#cat file_temp


unoconv -t $vorlage -f pdf -o $file.pdf file_temp
# rm file_temp
 

