#!/bin/bash
#
# 
# installiert den Standarddesktop
# für Ubuntu 14.04
# 
# Borg Innsbruck
# 
##
## Teil 2 Installationen ohne apt-get
##
#
#
## Mediathekview
wget  --no-check-certificate https://sourceforge.net/projects/zdfmediathk/files/latest/download?source=files -O MediathekView.zip
#
if [ -d /opt/mediathekview ]; then
    rm -rf /opt/mediathekview
fi  
mkdir /opt/mediathekview
chmod 755 /opt/mediathekview/
mv /root/MediathekView.zip /opt/mediathekview/
cd /opt/mediathekview/
unzip MediathekView.zip
#
#
#
echo "[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name[de_AT]=Mediathek
Exec=/opt/mediathekview/MediathekView__Linux.sh
Name=Mediathek
Icon=/usr/share/icons/hicolor/scalable/apps/gtkpod.svg
Categories=GTK;AudioVideo;Video;
" 																											> /usr/share/applications/mediathekview.desktop
#
#



