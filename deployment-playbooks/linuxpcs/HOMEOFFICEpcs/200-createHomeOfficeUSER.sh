#!/bin/bash


##
## we create a users and we neet mkpasswd from package whois
##
# install whois
apt-get update
apt-get install whois

## standard USER myoffice with password: myoffice
useradd -m -c MyOffice -u 1011 -p $(mkpasswd -m sha-512 "myoffice") -s /bin/bash -G sudo myoffice

