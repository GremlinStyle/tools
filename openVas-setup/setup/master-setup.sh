#!/bin/bash

#for getting the scripts
sudo apt update
sudo apt install curl

echo "Please enter the path where the scripts should be saved\n Entered Path should NOT END WITH / \n recommended: /home/scripts"
read script
echo "\n Please enter a valid ssh connection: "
read sshcon
echo "\n Please enter a valid ssh-key path: "
read keypath
echo "\nPlease name the admin user of openVas"
read user
echo "\nPlease type the password of the admin user from openVas"
read pasdw

 

#Creating user for next steps
sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/pre-setup.sh) 



#Start installation of openvas (Debian) source: https://greenbone.github.io/docs/latest/22.4/source-build/index.html
#PS: Followning script (install-setup.sh) is just copy pasted from source
sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/install-setup.sh) $user $pasdw

#Create Services
#IMPORTANT 
sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/service-setup.sh) $script $sshcon $keypath
