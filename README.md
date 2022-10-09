# Hivestorm Process
1. change root password: sudo passwd
2. wget https://github.com/CraigOpie/hivestorm/archive/refs/heads/main.zip
3. unzip main.zip
4. cd hivestorm-main
5. sudo ./init.sh
6. remove unauthorized users 
7. check sudo group cat sudoUsers.txt and remove unauthorized accounts -> sudo deluser [username] sudo
8. check services running against readme less check.services
9. check apps installed for bad actors (readme) less check.apps

10. require secure passwords, limit password reuse,
11. update apt to check daily updates
