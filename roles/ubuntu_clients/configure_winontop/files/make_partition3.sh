#!/bin/bash
#
fdisk /dev/sda &>/dev/null << EOFDELPART
n
p
3
  
  
w
EOFDELPART
partprobe
