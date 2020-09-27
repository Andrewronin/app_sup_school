#! /bin/bash
echo -e " \e[35m == 0. Preinstall configuration == \e[0m"
cat /etc/os-release | grep "PRETTY_NAME"
echo 'usertest ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/usertest
sudo yum install wget traceroute net-tools -y &>/dev/null

echo -e " \e[35m == 1. Create user with home directory and password == \e[0m"
sudo useradd --create-home         \
        --home-dir /home/usertest1 \
        --password testpassword    \
          usertest
cat /etc/passwd | grep usertest

echo -e " \e[35m == 2. Switch to the user == \e[0m"
sudo su usertest --login -c 'whoami'
sudo su usertest --login && whoami

echo -e " \e[35m == 3. Test your direction == \e[0m"
pwd 

echo -e " \e[35m == 4. Create directory == \e[0m"
mkdir dir && cd dir
pwd

echo -e " \e[35m == 5. Create 40 files XY_filename == \e[0m"
touch {a..d}{1..10}_filename
ls -l

echo -e " \e[35m == 6. Create 20 files .XY_filename == \e[0m"
touch .{a..d}{1..5}_filename
ls -la

echo -e " \e[35m == 7. Add some lines to files using echo == \e[0m"
for number in 1 2 3 4 5 6 7 8 9 10
do
    for some in 1 2 3 4 5
    do
        echo "${some} line" >> a${number}_filename
    done
done
cat a6_filename

echo -e " \e[35m == 8. List diirectory with options == \e[0m"
ls -l -a -h -t -S

echo -e " \e[35m == 9. Create file with spaces == \e[0m"
touch 'first file'
touch second\ file
ls -a *\ file

echo -e " \e[35m == 10. Delete file with spaces == \e[0m"
rm *\ file

echo -e " \e[35m == 11. Move files to dir1 == \e[0m"
mkdir ~/dir1
mv c*_* ~/dir1
ls ~/dir1

echo -e " \e[35m == 12. Copy files to dir1 == \e[0m"
cp [ad]*_* ~/dir1
ls ~/dir1

echo -e " \e[35m == 13. Delete files in dir1 == \e[0m"
rm ~/dir1/[ac]*_*
ls ~/dir1

echo -e " \e[35m == 14. Delete directory dir1 == \e[0m"
rm -rf ~/dir1
ls ~

echo -e " \e[35m == 15. Create directory == \e[0m"
mkdir ~/dir1/dir2/dir3 -p

echo -e " \e[35m == 16. Show env == \e[0m"
echo "Current user = ${USER}. Home directory = ${HOME}"


echo -e " \e[35m == 17. Add user to sudoers == \e[0m"
echo 'usertest ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/usertest

echo -e " \e[35m == 17. Show file == \e[0m"
echo "full file" $(cat /var/log/dmesg | wc -l)
echo "first 10 lines of file" $(head -10 /var/log/dmesg | wc -l)
echo "last 10 lines of file"  $(tail -10 /var/log/dmesg | wc -l)
wc -l /var/log/dmesg #number of lines

echo -e " \e[35m == 18. Search with pattern == \e[0m"
sudo grep -i -r -l iptables ~ 2>/dev/null | wc -l

echo -e " \e[35m == 19. List rpm packages == \e[0m"
rpm -qa | wc -l

echo -e " \e[35m == 20. Info about libgcc package == \e[0m"
rpm -q libgcc --info

echo -e " \e[35m == 21. Download package == \e[0m"
curl -O -s http://mirror.centos.org/centos/7/os/x86_64/Packages/GeoIP-data-1.5.0-14.el7.noarch.rpm 
wget -q http://mirror.centos.org/centos/7/os/x86_64/Packages/GeoIP-data-1.5.0-14.el7.noarch.rpm 

echo -e " \e[35m == 22. Install package == \e[0m"
geoiplookup tut.by
sudo yum install GeoIP -y &>/dev/null
sudo rpm --upgrade --verbose GeoIP-data-1.5.0-14.el7.noarch.rpm &>/dev/null
geoiplookup tut.by
sudo yum remove GeoIP -y &>/dev/null

echo -e " \e[35m == 22. List of installed repos == \e[0m"
sudo yum repolist

echo -e " \e[35m == 23. Add epel-realise == \e[0m"
sudo yum install epel-release -y &>/dev/null
sudo yum repolist

echo -e " \e[35m == 24. Update packages == \e[0m"
sudo yum upgrade -y &>/dev/null

echo -e " \e[35m == 25. Install nginx == \e[0m"
sudo yum install nginx -y &>/dev/null
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
sudo journalctl _SYSTEMD_UNIT=nginx.service
curl -s -I localhost:80 | grep '200 OK'

echo -e " \e[35m == 26. Read nginx config == \e[0m"
cat /etc/nginx/nginx.conf | grep -v '#'

echo -e " \e[35m == 27. Kill nginx process == \e[0m"
sudo systemctl status nginx | grep 'Active:'
sudo pkill nginx
sudo systemctl status nginx | grep 'Active:'
sudo systemctl start nginx
sudo kill $(sudo systemctl status nginx | grep 'Main PID' | awk '{print $3}')
sudo systemctl status nginx | grep 'Active:'

echo -e " \e[35m == 28. Remove Nginx == \e[0m"
sudo yum remove nginx -y &>/dev/null

echo -e " \e[35m == 29. Working with archives == \e[0m"
#create
cd ~
tar -cf 1_archive.tar dir/ 
tar -cf 2_archive.tar dir/ && gzip 2_archive.tar 
tar -cf 3_archive.tar dir/ && bzip2 3_archive.tar 
#read
tar -tf 1_archive.tar
#extract
mkdir -p /tmp/archive/1_archive /tmp/archive/2_archive /tmp/archive/3_archive
tar -xf  1_archive.tar     -C /tmp/archive/1_archive/
tar -xzf 2_archive.tar.gz  -C /tmp/archive/2_archive/
tar -xjf 3_archive.tar.bz2 -C /tmp/archive/3_archive/

echo -e " \e[35m == 30. Working with script == \e[0m"
touch script.sh
tee script.sh <<EOT
#! /bin/bash
cat \$1
EOT
chmod u+x script.sh
ls -l script.sh
./script.sh script.sh
chmod +x script.sh
ls -l script.sh

echo -e " \e[35m == 31. Working with monitoring Linux == \e[0m"
echo $(top -b -n 1 | grep -o "load\ average.*")
echo $(top -b -n 1 | grep -o "Tasks: .* total")
echo $(top -b -n 1 | grep "KiB Mem :")
echo $(top -b -n 1 | grep "%Cpu(s):")

echo -e " \e[35m == 32. Working with filesystem == \e[0m"
df -h

echo -e " \e[35m == 33. Size of /var dir == \e[0m"
sudo du -sh /var
sudo du -sh --block-size=1MB /var
sudo du -sh --block-size=1GB /var

echo -e " \e[35m == 34. Network subinterface == \e[0m"
sudo ifconfig eth0:1 192.168.121.1/24 up
ifconfig -a 

echo -e " \e[35m == 35. Network route == \e[0m"
sudo ip route add 192.168.121.0/24 via 192.168.121.1
ip route
sudo traceroute 192.168.121.1