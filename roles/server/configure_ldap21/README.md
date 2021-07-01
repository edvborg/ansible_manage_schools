# Installation von rhel8 und 389-ds

rhel 8.2 ISO einlegen und starten -> Server mit GUI wählen (mit Netzwerktools und Systemwerkzeuge)
yum update (bei der direkten Installation von 8.3 gabe es Probleme! Deshalb zuerst 8.2 und dann updaten. Das hat funktioniert)

Nach dem Playbook müssen noch die Daten überspielt werden:
Mit dem Befehl: smbldap-populate wird der directory-Server auf SAMBA-Einträge vorbereitet. Er macht da irgendwelche Standardeinträge.
Dann können über den ApacheDirectoryStudio die ldif Dateien vom alten 389-Server importiert werden. Zuerst die Gruppen und dann alle People. So gab es zumindest am wenigsten Fehlermeldungen.

Eine zweite Netzwerkkarte muss hinzugefügt werden im Storage-Netz! Hat dort die IP 192.168.210.201
Auch auf dem fs1 muss die nfs Freigabe den root Zugriff auf dem Rechner erlauben! Daher:
~~~bash
zfs set sharenfs="anon=nobody,sec=sys,rw=@192.168.210.0/24:@192.168.110.0/24:@192.168.120.0/24:@192.168.130.0/24:@192.168.140.0/24:@192.168.190.0/24,root=@192.168.210.205/32:@192.168.210.201/32,ro=@192.168.210.215/32" tank/home
~~~
