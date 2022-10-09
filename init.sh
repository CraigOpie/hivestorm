#!/bin/bash
grep '^sudo:.*$' /etc/group | cut -d: -f4 >> sudoUsers.txt
systemctl list-units --all --type=service --no-pager | grep running >> current.services
diff current.services default.services >> check.services
sudo apt list --installed >> current.apps
diff current.apps default.apps >> check.apps
sudo echo "deb http://security.ubuntu.com/ubuntu/ xenial-security main universe" >> /etc/apt/sources.list
sudo echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates main universe" >> /etc/apt/sources.list
sudo echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial-backports main universe" >> /etc/apt/sources.list
sudo sed -i 's/APT::Periodic::Update-Package-Lists "0";/APT::Periodic::Update-Package-Lists "1";/g' /etc/apt/apt.conf.d/10periodic
sudo apt update
DEBIAN_FRONTEND=noninteractive apt-get install -y "vim"
DEBIAN_FRONTEND=noninteractive apt-get install -y "aide"
DEBIAN_FRONTEND=noninteractive apt-get install -y "vlock"
DEBIAN_FRONTEND=noninteractive apt-get install -y "auditd"
DEBIAN_FRONTEND=noninteractive apt-get install -y "audispd-plugins"
DEBIAN_FRONTEND=noninteractive apt-get install -y "libpam-pwquality"
sudo echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
sudo ./aideAConfig.sh
sudo ./gnomeConfig.sh
sudo ./sudoConfig.sh
sudo ./aptConfig.sh
sudo ./passwordConfig.sh
sudo ./sessionConfig.sh
sudo ./auditConfig.sh
sudo ./pamConfig.sh
