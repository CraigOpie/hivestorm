#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get install -y "aide"
DEBIAN_FRONTEND=noninteractive apt-get install -y "vlock"
DEBIAN_FRONTEND=noninteractive apt-get install -y "auditd"
DEBIAN_FRONTEND=noninteractive apt-get install -y "libpam-pwquality"
sudo echo "\nallow-guest=false\n" >> /etc/lightdm/lightdm.conf
sudo ./aideAConfig.sh
sudo ./gnomeConfig.sh
sudo ./sudoConfig.sh
sudo ./aptConfig.sh
sudo ./passwordConfig.sh
sudo ./sessionConfig.sh
sudo ./auditConfig.sh
sudo ./pamConfig.sh
