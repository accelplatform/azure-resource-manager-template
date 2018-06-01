#!/bin/bash
# $1 = Resouce url prefix
# $2 = vm user name
# $3 = Azure SQL Database server name
# $4 = database name
# $5 = database user name
# $6 = database user password

echo "************************************************"
echo "   install_webappsrv_script.sh"
echo "************************************************"
set -x -v -e

# Deploy SQL Server JDBC driver.
wget -q https://download.microsoft.com/download/5/D/2/5D2F2C81-405A-44BF-A1CD-C02236C1A9E6/sqljdbc_4.2.8112.200_jpn.tar.gz
tar -zxf sqljdbc_4.2.8112.200_jpn.tar.gz
cp sqljdbc_4.2/jpn/jre8/sqljdbc42.jar /var/resin/webapp-jars/sqljdbc42.jar

# Write an example for resin-web.xml.
wget -q -O resin-web.xml.example $1resources/resin-web.xml.example
sed -i -e "s/\%SERVER\_NAME\%/$3/g" resin-web.xml.example
sed -i -e "s/\%DB\_NAME\%/$4/g" resin-web.xml.example
sed -i -e "s/\%USER\%/$5/g" resin-web.xml.example
sed -i -e "s*\%PASSWORD\%*$6*g" resin-web.xml.example
mv resin-web.xml.example resin-web.xml
