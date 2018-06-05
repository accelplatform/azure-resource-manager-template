#!/bin/bash
# $1  = Resouce url prefix

echo "************************************************"
echo "   install_webappsrv_script.sh"
echo "************************************************"
set -x -v -e -u

# Open port 80.
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

# Install Apache httpd 2.4.
yum install httpd-2.4.6-80.el7.x86_64 -y
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig
wget -q -O /etc/httpd/conf/httpd.conf ${1}resources/httpd.conf
/usr/sbin/setsebool httpd_can_network_connect 1

# Install JDK 8.
wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.rpm
rpm -ivh jdk-8u172-linux-x64.rpm
echo "" >> /root/.bash_profile
echo "" >> /root/.bash_profile
echo "JAVA_HOME=/usr/java/jdk1.8.0_172-amd64" >> /root/.bash_profile
echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bash_profile
echo "export PATH" >> /root/.bash_profile
source /root/.bash_profile

# Install Resin Pro 4.0.56.
yum install openssl-devel glibc-devel -y
wget -q http://caucho.com/download/rpm-6.8/4.0.56/x86_64/resin-pro-4.0.56-1.x86_64.rpm
rpm -ivh resin-pro-4.0.56-1.x86_64.rpm
mv /etc/resin/resin.properties /etc/resin/resin.properties.orig
wget -q -O /etc/resin/resin.properties ${1}resources/resin.properties
mkdir /var/resin/tmp
sed -i -e "s*JAVA=\"/usr/bin/java\"*JAVA=\$JAVA_HOME*g" /bin/resinctl
### 制限事項 rpm のインストールは対応してない
### https://www.intra-mart.jp/download/product/iap/iap_release_note/texts/limitations/resin.html#common-resin-debrpm

# Start Environment
service httpd start
service resin start
systemctl enable httpd.service
