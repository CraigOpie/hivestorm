# Hivestorm Process
1. check history then change root password: sudo passwd
2. wget https://github.com/CraigOpie/hivestorm/archive/refs/heads/main.zip
3. unzip main.zip
4. cd hivestorm-main
5. sudo ./init.sh
6. remove unauthorized users 
7. check sudo group cat sudoUsers.txt and remove unauthorized accounts -> sudo deluser [username] sudo
8. check services running against readme less check.services
9. check apps installed for bad actors (readme) less check.apps

10. enable ufw and set permissions for readme apps
11. check listening ports (ss -plunt) and find / -perm 4000 (SUID/SGID)
12. php hardening
13. nginx hardening
14. apache hardening
15. IPv4 TCP SYN cookies have been enabled
16. Ignore bogus ICMP errors enabled
17. Logging of martian packets enabled
18. ICR daemon has been disabled or removed
19. Minetest service has been disabled or removed
20. prohibited software nmap, john the ripper, netcat backdoor, ophcrack removed
21. Firefox warns when sites try to install add-ons
22. PHP does not display errors php.ini
23. Apache server tokens set to least
24. Apache trace requests disabled
25. sudo getent passwd, sudo getent shadow
26. Greeter does not enumerate user accounts
27. ignore broadcast ICMP ehco request enabled
28. ipv4 accept ICMP redirects disabled
29. sysctl.conf FTP, POP3, SMTP disabled or removed

30. require secure passwords, limit password reuse,
31. update apt to check daily updates

Useful commands:
getent passwd
sudo deluser --remove-home $user
getent shadow
sudo chage -l $user
sudo chage -m $days $user
sudo chage -M $days $user
sudo chage -I $days $user
sudo chage -E $dayssince1990 $user
getent group
sudo gpasswd -a $user sudo
sudo gpasswd -d $user sudo
