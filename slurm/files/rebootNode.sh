#!/bin/bash
/usr/bin/scontrol update nodename=$(/usr/bin/hostname) state=drain reason="auto reboot"
while  /usr/bin/squeue |grep $(/usr/bin/hostname)  ; do sleep 5;  done;
/usr/sbin/reboot 
