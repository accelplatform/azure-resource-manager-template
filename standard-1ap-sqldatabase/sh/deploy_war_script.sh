#!/bin/bash
# $1  = Resouce url prefix

echo "************************************************"
echo "   deploy_war_script.sh"
echo "************************************************"
set -x -v -e

# install ant
yum install ant -y

# Create sample WAR file and static contents.
wget -q ${1}resources/juggling_ant.zip
unzip juggling_ant.zip -d juggling_ant
mv resin-web.xml juggling_ant/project/resin-web.xml
mv storage-config.xml juggling_ant/project/conf/storage-config.xml
cd juggling_ant
ant clean make
ant clean make static
cd ..

# Deploy WAR file and static contents.
mv juggling_ant/imart.war /var/resin/webapps/imart.war
unzip juggling_ant/imart.zip -d /var/www/html/imart
