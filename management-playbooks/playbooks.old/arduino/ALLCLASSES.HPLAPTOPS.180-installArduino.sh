#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

######Arduino##########################################################
#http://labs.arduino.org/Arduino%20IDE%20on%20Linux-based%20OS
cd /tmp/
#wget http://download.arduino.org/IDE/1.7.10/arduino-1.7.10.org-linux64.tar.xz
wget http://download.arduino.org/IDE/1.7.10/arduino-1.7.10.org-linux32.tar.xz

#tar -xvf arduino-1.7.10.org-linux64.tar.xz
tar -xvf arduino-1.7.10.org-linux32.tar.xz

#cp -r arduino-1.7.10-linux64 /usr/lib/arduino-1.7.10-linux64
cp -r arduino-1.7.10-linux32 /usr/lib/arduino-1.7.10-linux32

#ln -s /usr/lib/arduino-1.7.10-linux64/arduino /usr/bin/arduino
ln -sf /usr/lib/arduino-1.7.10-linux32/arduino /usr/bin/arduino

# manipulated file
file=/etc/udev/rules.d/90-extraacl.rules

printAndLogMessage "Write to file: " $file
echo "
KERNEL="ttyUSB[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="rudi"
KERNEL="ttyACM[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="rudi"
" >> $file

logFile $file

usermod -a -G tty rudi
usermod -a -G dialout rudi

apt-get remove -y -f modemmanager

cd /usr/local/share/
wget http://www.arduino.org/images/home/Arduino.png

#finder entry and icon 
echo "
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Arduino
Comment=Arduino
Exec=/usr/bin/arduino
Icon=/usr/local/share/Arduino.png
Terminal=false
" >> /usr/share/applications/arduino.desktop


#####S4A##############################################################
# http://s4a.cat/
dpkg --add-architecture i386
apt-get update
apt-get -y install ia32-libs

apt-get install -y -f libcairo2:i386 libdatrie1:i386 libgraphite2-3:i386 libharfbuzz0b:i386  libpango-1.0-0:i386 libpango1.0-0:i386 libpangocairo-1.0-0:i386  libpangoft2-1.0-0:i386 libpangox-1.0-0:i386 libpangoxft-1.0-0:i386  libpixman-1-0:i386 libthai0:i386 libxcb-render0:i386 libxcb-shm0:i386  libxft2:i386

cd /tmp
wget http://vps34736.ovh.net/S4A/S4A16.deb
dpkg -i --force-architecture S4A16.deb

## bring Firmaware to desktop
touch /home/rudi/Schreibtisch/
chmod rudi.rudi /home/rudi/Schreibtisch/
cd /home/rudi/Schreibtisch/
wget http://vps34736.ovh.net/S4A/S4AFirmware16.ino

#reboot
