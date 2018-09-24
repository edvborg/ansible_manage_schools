#! /bin/bash
#
# Dieses Skript verbindet über smb/cifs Protokoll mit dem persönlichen Ordner eines Benutzers
#
#
# BORG IBK 
# Ladinig Rudi 04 05 2015
#
#
MYDOMAIN="BORG-IBK.LOCAL"
#
MYSMBSERVER="videos"
# 
#
INST_DIR="/usr/local/bin"
#
SCRIPTNAME="connect2videos-as-admin.sh"
#
DESKTOPFILE="connect2videos-as-admin.desktop"
#
# 
#
##################################################################################
##
apt-get install -y cifs-utils
#
################################################################################## 
#
# Skript erstellen:
# 
printf "#!/bin/bash\n"      	> $INST_DIR/$SCRIPTNAME
printf "#\n"                	>> $INST_DIR/$SCRIPTNAME
printf "#\n"						>> $INST_DIR/$SCRIPTNAME
printf 'FACH=$' 				>> $INST_DIR/$SCRIPTNAME
printf '(zenity --entry --title="Mit dem Videoordner verbinden" --text="Geben Sie das Kürzel für das Unterrichtsfach an (z. B. e, bu, it, usw.):" )'        >> $INST_DIR/$SCRIPTNAME
printf "\n" 					>> $INST_DIR/$SCRIPTNAME
printf 'SHARE=$FACH-video\n'   			>> $INST_DIR/$SCRIPTNAME
printf "#\n"    				>> $INST_DIR/$SCRIPTNAME
printf 'USERNAME=$' 				>> $INST_DIR/$SCRIPTNAME
printf '(zenity --entry --title="Mit dem Video- und Audioserver verbinden" --text="Geben Sie ihren Benutzernamen mit Schreibrechten an:" )'        >> $INST_DIR/$SCRIPTNAME
printf "\n" 					>> $INST_DIR/$SCRIPTNAME
printf "#\n"    				>> $INST_DIR/$SCRIPTNAME
printf "#\n"    				>> $INST_DIR/$SCRIPTNAME
printf "nautilus -n --no-desktop \"smb://${MYDOMAIN};"    	>> $INST_DIR/$SCRIPTNAME
printf '$USERNAME@'   								>> $INST_DIR/$SCRIPTNAME
printf "$MYSMBSERVER:/"							>> $INST_DIR/$SCRIPTNAME
printf '$SHARE\" \n'      						>> $INST_DIR/$SCRIPTNAME
printf "\n"    					>> $INST_DIR/$SCRIPTNAME
#
#
chmod 755 $INST_DIR/$SCRIPTNAME
#
#
# Starter erzeugen
#
echo "[Desktop Entry]
Version=1.0
Name=Videos hochladen
Comment=Videos auf den Video-Server hochladen
Exec=$INST_DIR/$SCRIPTNAME
Type=Application
Icon=gnome-fs-network
Categories=GTK;GNOME;Application;Utility;
" > /tmp/$DESKTOPFILE
#
cp /tmp/$DESKTOPFILE /usr/share/applications/
#
chmod +x /tmp/$DESKTOPFILE
#
for homedir in `ls /home2/` ; do 
	if [ ! -d /home2/$homedir/Schreibtisch/ ] ; then 
		mkdir /home2/$homedir/Schreibtisch/
	fi
	cp /tmp/$DESKTOPFILE /home2/$homedir/Schreibtisch/  
	chown $homedir /home2/$homedir/Schreibtisch/$DESKTOPFILE
	chmod 700 /home2/$homedir/Schreibtisch/$DESKTOPFILE
done 
#
#


