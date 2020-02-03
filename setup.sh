#!/bin/bash
if [ "$EUID" -ne 0 ]
	then echo "Must be root, run sudo -i before running that script."
	exit
fi

echo "┌─────────────────────────────────────────"
echo "|Welcome to Oris Labs Network Setup"
echo "|This will Setup a Standalone AP with NAT"
echo "└─────────────────────────────────────────"
read -p "Press enter to continue"

echo "┌─────────────────────────────────────────"
echo "|Updating repositories"
echo "└─────────────────────────────────────────"
apt-get update -yqq

echo "┌─────────────────────────────────────────"
echo "|Configuring wlan0"
echo "└─────────────────────────────────────────"
echo 'interface wlan0' >> /etc/dhcpcd.conf ## append to file
echo '	  static ip_address=192.168.4.1/24' >> /etc/dhcpcd.conf
echo '	  nohook wpa_supplicant' >> /etc/dhcpcd.conf


# echo "┌─────────────────────────────────────────"
# echo "|Installing dnsmasq"
# echo "└─────────────────────────────────────────"
# apt-get install dnsmasq -yqq

# echo "┌─────────────────────────────────────────"
# echo "|Configuring dnsmasq"
# echo "└─────────────────────────────────────────"
# mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
# wget -q https://raw.githubusercontent.com//master/dnsmasq.conf -O /etc/dnsmasq.conf


