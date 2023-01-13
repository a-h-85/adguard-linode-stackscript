#!/bin/bash

#import stackscript library
source <ssinclude StackScriptID=1>

# send stdout and stderr to both console and log file
>~/stackscript.log
exec >  >(tee -a ~/stackscript.log)
exec 2> >(tee -a ~/stackscript.log >&2)


# This block defines the variables the user of the script needs to provide
# when deploying using this script.
#
#<UDF name="timezone" Label="timezone" example="Asia/Singapore">
# TIMEZONE=
#
#<UDF name="hostname" label="The hostname for the new Linode.">
# HOSTNAME=
# 
# This sets the variable $IPADDR to the IP address the new Linode receives.
IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')

#Set timezone
timedatectl set-timezone $TIMEZONE
echo "---"
echo "DATE OUTPUT"
date
echo "---"

#Set hostname
hostnamectl set-hostname $HOSTNAME
echo "---"
echo "HOSTNAME OUTPUT"
hostname
echo "---"

#add hostname and IP to /etc/hosts
echo "$IPADDR $HOSTNAME" >> /etc/hosts  
echo "---"
echo "/etc/hosts OUTPUT"
cat /etc/hosts
echo "---"

#update
#debian_upgrade()
echo "---"
echo "UPDATE"
sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y full-upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt -y clean
echo "---"

#create update alias
echo "---"
echo "UPDATE ALIAS"
echo "alias up='sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y full-upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt -y clean'" >> ~/.bashrc
tail ~/.bashrc
echo "---"
source ~/.bashrc

#run update
echo "---"
echo "RUN ALIAS"
up
echo "---"

#install adguard
echo "---"
echo "Install AdGuard"
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
echo "---"

#install tailscale
echo "---"
echo "Install Tailscale"
sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y full-upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt -y clean
curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y full-upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt -y clean
touch tailscale.txt
sudo apt-get install tailscale -y > tailscale.txt
sudo tailscale up
echo "---"

#enable fail2ban
echo "---"
echo "Install fail2ban"
#enable_fail2ban()

#install fail2ban
sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y full-upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt -y clean
apt-get install fail2ban -y
echo "---"
