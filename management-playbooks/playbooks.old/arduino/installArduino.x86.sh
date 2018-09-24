#!/bin/bash



######Arduino##########################################################
#
cd /tmp/
#wget http://download.arduino.org/IDE/1.7.10/arduino-1.7.10.org-linux64.tar.xz
wget  http://download.arduino.org/IDE/1.7.11/arduino-1.7.11.org-linux32.tar.xz -e http_proxy=proxy:8080
     
#tar -xvf arduino-1.7.10.org-linux64.tar.xz
tar -xvf arduino-1.7.11.org-linux32.tar.xz

#cp -r arduino-1.7.10-linux64 /opt/arduino-1.7.10-linux64
cp -r arduino-1.7.11-linux32 /opt/arduino-1.7.11-linux32

#ln -s /opt/arduino-1.7.10-linux64/arduino /usr/bin/arduino
ln -sf /opt/arduino-1.7.11-linux32/arduino /usr/bin/arduino

# manipulated file
file=/etc/udev/rules.d/90-extraacl.rules

echo "
KERNEL="ttyUSB[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="rudi"
KERNEL="ttyACM[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="rudi"
" > $file



#usermod -a -G tty rudi
#usermod -a -G dialout rudi

#apt-get remove -y -f modemmanager

cd /opt/arduino-1.7.11-linux32/
wget http://www.arduino.org/images/home/Arduino.png

#finder entry and icon 
echo "[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Arduino
Comment=Arduino
Exec=/usr/bin/arduino
Icon=/opt/arduino-1.7.11-linux32/Arduino.png
Terminal=false
Categories=GTK;GNOME;Development;WebDevelopment;

" > /usr/share/applications/arduino.desktop

