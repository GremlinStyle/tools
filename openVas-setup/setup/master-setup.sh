#!/bin/bash

#for getting the scripts
sudo apt update
sudo apt install curl xmlstarlet sendmail -y

SCRIPTPATH=/root/scripts
keypath=root/.ssh/id_rsa

printf "\n Please enter a valid ssh connection: "
read sshcon

printf "Please just hit Enter for the ssh-key generation"

ssh-keygen -t rsa

printf "\n STOP PAY ATTENTION AGAIN "
read

printf "\nPlease name the admin user of openVas"
read user
printf "\nPlease type the password of the admin user from openVas"
read pasdw
printf "\nPlease type the email used to send reports"
read fromail
printf "\nPlease type the Appkey of the email you use to send reports"
read fromail
printf "\nPlease type the email used to receive reports"
read tomail

mkdir -p /root/scripts
chmod 700 /root/scripts
export SCRIPTPATH=/root/scripts
export SSHCON=$sshcon
export KEYPATH=/root/.ssh/id_rsa
export GVMUSER=$user
export GVMPASDW=$pasdw
export APPKEY=$appkey
export TOMAIL=$tomail
export FROMAIL=$fromail

#printf "export SCRIPTPATH="$scriptpath"\nexport KEYPATH="$keypath"\nexport GVMUSER="$user"\nexport GVMPASDW="$pasdw"\nexport SSHCON="$sshcon"\nexport APPKEY="$appkey"\nexport TOMAIL="$tomail"\nexport FROMAIL=$fromail >> $HOME/.profile
sudo printf "export SCRIPTPATH="$scriptpath"\nexport KEYPATH="$keypath"\nexport GVMUSER="$user"\nexport GVMPASDW="$pasdw"\nexport SSHCON="$sshcon >> /root/.profile


#START OF INSTALLATION
# of openvas for debian according to ("https://greenbone.github.io/docs/latest/22.4/source-build/index.html") with changes for prompted user and password

if hostnamectl | grep -qiP 'system.*[kK]ali'; then
    echo -e "OS is Kali Linux\npossible installation using apt install\n it is recommended:(y/n)"
    read answ
    if [ "$ans" = "y" ]; then
        echo "I shall continue on a righteus path"
        sudo apt install openvas -y --fix-missing
    fi

    
elif hostnamectl | grep -qiP 'system.*[dD]ebian'; then
    echo -e "OS is Debian Linux\nonly possible installation using source and build to install\n it is a hasle but that's why this script exist\n do you want to install:(y/n)"
    read answ
    if [ "$ans" = "y" ]; then
        echo "I shall continue on this treacherous path"
            #Creating user for next steps
            sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/pre-setup.sh) 

            #Start installation of openvas (Debian) source: https://greenbone.github.io/docs/latest/22.4/source-build/index.html
            #PS: Followning script (install-setup.sh) is just copy pasted from source
            sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/install-setup.sh)
    fi
fi 

#END OF INSTALLATION

#Create Services and configure them

#IMPORTANT 
sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/service-setup.sh) $scriptpath $sshcon $keypath
