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


echo "┌─────────────────────────────────────────"
echo "|Installing dnsmasq"
echo "└─────────────────────────────────────────"
apt-get install dnsmasq -yqq

echo "┌─────────────────────────────────────────"
echo "|Configuring dnsmasq"
echo "└─────────────────────────────────────────"
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
wget -q https://raw.githubusercontent.com/orislabs/rpiap/master/dnsmasq.conf -O /etc/dnsmasq.conf


echo "┌─────────────────────────────────────────"
echo "|configuring dnsmasq to start at boot"
echo "└─────────────────────────────────────────"
update-rc.d dnsmasq defaults

echo "┌─────────────────────────────────────────"
echo "|Installing hostapd"
echo "└─────────────────────────────────────────"
apt-get install hostapd -yqq

echo "┌─────────────────────────────────────────"
echo "|Configuring hostapd"
echo "└─────────────────────────────────────────"
wget -q https://raw.githubusercontent.com/orislabs/rpiap/master/hostapd.conf -O /etc/hostapd/hostapd.conf
sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

echo "┌─────────────────────────────────────────"
echo "|configuring hostapd to start at boot"
echo "└─────────────────────────────────────────"
systemctl unmask hostapd.service
systemctl enable hostapd.service


echo "┌─────────────────────────────────────────"
echo "|Configuring iptables"
echo "└─────────────────────────────────────────"
sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE # Liga NAT no eth0

#iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80
#Regra em cima redirecciona trafego para o WebServer 

#iptables -t nat -A POSTROUTING -j MASQUERADE
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get -y install iptables-persistent

rule=net.ipv4.ip_forward=1; sed -i "/^#$rule/ c$rule" /etc/sysctl.conf 

# echo "┌─────────────────────────────────────────"
# echo "|Installing and configuring nginx"
# echo "└─────────────────────────────────────────"
# apt-get install nginx -yqq
# wget -q https://raw.githubusercontent.com/orislabs/rpiap/master/default_nginx -O /etc/nginx/sites-enabled/default


echo "┌─────────────────────────────────────────"
echo "|Reboot and test"
echo "└─────────────────────────────────────────"

