#!/usr/bin/env bash

TARGET_IP=192.168.56.123

if [ "$1" != "" ]; then
  TARGET_IP="$1"
fi

#Check if netcat is installed - if not install it
echo "Check if netcat is installed ..."
IS_NETCAT_INSTALLED=$(ssh tom@$TARGET_IP "apt list --installed 2> /dev/null | grep netcat")
if [ -z "$IS_NETCAT_INSTALLED" ]; then
  echo "Netcat required. Installing ..."
  ssh tom@$TARGET_IP "sudo -S apt-get install netcat"
else
    echo "OK"
fi

#Check if nmap is installed - if not install it
echo "Check if nmap is installed ..."
IS_NMAP_INSTALLED=$(ssh tom@$TARGET_IP "apt list --installed 2> /dev/null | grep nmap")
if [ -z "$IS_NMAP_INSTALLED" ]; then
  echo "Nmap required. Installing ..."
  ssh tom@$TARGET_IP "sudo -S apt-get install nmap"
else
    echo "OK"
fi

echo "Running netcat server..."
# switch -k command netcat to wait for another connection attempt
ssh tom@$TARGET_IP "top -n1 -b | tee topResult.txt; netcat -k -l 4321 > /dev/null 2>&1 & disown -h"

echo "Checking if TCP server on $TARGET_IP is open:"
OPEN_PORTS=$(ssh tom@$TARGET_IP "nmap -p 4321 --open $TARGET_IP | grep 4321")
if [ -n "$OPEN_PORTS" ]; then
  echo "TCP port 4321 is open."
else
  echo "TCP port 4321 is not open."
fi

echo "Killing all netcat processes.../"
ssh tom@$TARGET_IP "killall -s KILL netcat"

echo "Checking if TCP server on $TARGET_IP is still open:"
OPEN_PORTS=$(ssh tom@$TARGET_IP "nmap -p 4321 --open $TARGET_IP | grep 4321")
if [ -n "$OPEN_PORTS" ]; then
  echo "TCP port 4321 is open."
else
  echo "TCP port 4321 is not open."
fi

