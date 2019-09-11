#!/bin/bash
#
# 
# für Ubuntu 16.04 / 18.04
# 
# Borg Innsbruck
#
# Ändert den Hostnamen
#
# der FOG-Server wird nach dem Hostnamen zur eigenen MAC-Adresse abgefragt
#
# Dieser Hostname aus der FOG-Datenbank wird mit dem momentan konfigurierten 
# Hostnamen verglichen und bei Ungleichheit geändert.
#
#Die MAC-Adresse des lokalen Hoste wird ausgelesen und in der Variable "MYMAC" gespeichert.
#
for INTERFACE in `ls /sys/class/net/`; do
        if [ ! $INTERFACE == "lo" ] ; then
                cat /sys/class/net/$INTERFACE/address
                MYMAC=`cat /sys/class/net/$INTERFACE/address`
        fi
done
#
# get 'hostname - MAC' from database 
#
#Der User "fogreader" liest auf der mysql-Datenbank des Fog-Servers den zugehörigen Host-Namen aus.
FOGHOSTNAME=`mysql --batch -u fogreader -pfogpassword --host=fog fog -e 'select hm.hmMAC,hn.hostName from hostMAC hm, hosts hn where hm.hmHostID= hn.hostID' | grep $MYMAC | awk '{print $2}'`
#
OLDHOSTNAME=$(hostname)
# Prüfung, ob die Suche erfolgreich war - andernfalls erfolgt die Ausgabe "hostname not found".
# 
# Anschließend wird geprüft, ob der ausgegeben Host-Name mit dem vorhanden ("OLDHOSTNAME") übereinstimmt.
# Dienst "systemd" (der für Host-Namen verantwortlich ist) wird neu gestartet.
# Anschließend wird der Hostname gelöscht und der Fog-Hostname gesetzt.
#
if [ ! -n "$FOGHOSTNAME" ]; then 
	echo "hostname not found" 
else
	if [ ! "$OLDHOSTNAME" == "$FOGHOSTNAME" ] ; then
	#echo $FOGHOSTNAME 
	#echo $FOGHOSTNAME > /etc/hostname

	systemctl restart systemd-hostnamed
	hostnamectl set-hostname ""
	hostnamectl set-hostname "$FOGHOSTNAME"
	/sbin/reboot
   #   else
   #     echo $FOGHOSTNAME
	fi
fi
#
#
