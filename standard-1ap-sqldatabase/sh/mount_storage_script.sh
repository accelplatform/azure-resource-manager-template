#!/bin/bash
# $1 = Resouce url prefix
# $2 = VM user name
# $3 = Azure storage account name
# $4 = Azure storage account key
# $5 = Azure file share name
# $6 = mountpoint path

echo "************************************************"
echo "   mount_storage_script.sh"
echo "************************************************"
set -x -v -e -u

# Install some tools.
yum install samba-client samba-common cifs-utils -y

# Mount Azure Files as storage.
mkdir ${6}
echo "//${3}.file.core.windows.net/${5} ${6} cifs nofail,vers=3.0,username=${3},password=${4},dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab
mount -a

# Write an example for storage-config.xml
wget -q $1resources/storage-config.xml.example
sed -i -e "s*\%STORAGE\_PATH\%*${6}*g" storage-config.xml.example
mv storage-config.xml.example storage-config.xml
