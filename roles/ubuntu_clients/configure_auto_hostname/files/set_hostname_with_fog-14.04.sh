#!/bin/bash
#
# 
# für Ubuntu 16.04
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
#
#
for INTERFACE in `ls /sys/class/net/`; do
        if [ ! $INTERFACE == "lo" ] ; then
                # cat /sys/class/net/$INTERFACE/address
                MYMAC=`cat /sys/class/net/$INTERFACE/address`
        fi
done
#
# get 'hostname - MAC' from database 
#
FOGHOSTNAME=`mysql --batch -u fogreader -pfogpassword --host=fog fog -e 'select hm.hmMAC,hn.hostName from hostMAC hm, hosts hn where hm.hmHostID= hn.hostID' | grep $MYMAC | awk '{print $2}'`
#
# FOGHOSTNAME=`mysql --batch -u fogreader -pfogpassword --host=fog fog -e 'select hostname, hostMAC from hosts'  | grep $MYMAC | awk '{print $1}'`
#
OLDHOSTNAME=$(hostname)
#
#
echo "old configured hostname: $OLDHOSTNAME"
echo "hostname from fogserver: $FOGHOSTNAME"
#
if [ ! -n "$FOGHOSTNAME" ]; then 
	echo "hostname not found" 
else
	if [ ! "$OLDHOSTNAME" == "$FOGHOSTNAME" ] ; then
	#	echo $FOGHOSTNAME 
	echo $FOGHOSTNAME > /etc/hostname
	/sbin/reboot
	fi
fi
#
#
