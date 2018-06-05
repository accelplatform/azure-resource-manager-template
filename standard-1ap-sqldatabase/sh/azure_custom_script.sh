#!/bin/bash
# $1  = Resouce url prefix
# $2  = VM user name
# $3  = Azure storage account name
# $4  = Azure storage account key
# $5  = Azure file share name
# $6  = mountpoint path
# $7  = Azure SQL Database server name
# $8  = database name
# $9  = database user name
# $10 = database user password

echo "************************************************"
echo "   azure_custom_script.sh"
echo "************************************************"
set -x -v -e -u

# Install some tools.
yum install wget unzip vim -y

# Install Web server and application server
sh install_webappsrv_script.sh ${1}

# Mount storage
sh mount_storage_script.sh ${1} ${2} ${3} ${4} ${5} ${6}

# Prepare DB connecting
sh prepare_db_connect_script.sh ${1} ${2} ${7} ${8} ${9} ${10}


# Create WAE
sh deploy_war_script.sh ${1}


echo ""
echo ""
echo "Completed!!"