#!/bin/bash

#for getting the scripts
sudo apt update
sudo apt install curl xmlstarlet sendmail -y

SCRIPTPATH=/root/scripts

#START OF SET-VARIBLE 



#SSH CONFIG

#check if pem file is there cause how do you want to get it ? USB / http anyway it needs to be there 

echo -e "Please save the ssh keyfile of the main server first on disk before proceeding\nIS the keyfile on this device? (Y/n)"

read check

if [ $check == Y ]; then echo "We will procced"; else echo "then please get the keyfile to disk";return; fi; echo "Lol"

printf "\n Please enter a valid ssh connection (user@ipORdns): "
read SSHCON

printf "Please just hit Enter for the ssh-key generation: "

ssh-keygen -t rsa

printf "\n STOP!!!\n PAY ATTENTION AGAIN \n"
sleep 2

printf "now we gona use ssh-copy-id to put the key onto the server for that you need to just enter the path to the keyfile of the server: "
read pa

ssh-copy-id  -f -o "IdentityFile $pa" $SSHCON

#SSH config for tunnel:

echo -e "\nPlease enter the first port of the server which will be used for the tunnels: "
read PORT1

echo -e "\nPlease enter the second port of the server which will be used for the tunnels: "
read PORT2

#OPENVAS / GVM CONFIG

printf "\nPlease name the admin user of openVas: "
read GVMUSER
printf "\nPlease type the password of the admin user from openVas: "
read GVMPASWD

#EMAIL CONFIG

printf "\nPlease type the email used to send reports: "
read FROMAIL
printf "\nPlease type the Appkey of the email you use to send reports: "
read APPKEY
printf "\nPlease type the email used to receive reports: "
read TOMAIL


mkdir -p /root/scripts
chmod 700 /root/scripts
export SSHCON=$SSHCON
export PORT1=$PORT1
export PORT2=$PORT2
export GVMUSER=$GVMUSER
export GVMPASWD=$GVMPASWD
export APPKEY=$APPKEY
export TOMAIL=$TOMAIL
export FROMAIL=$FROMAIL


if [ $SHELL -eq "/bin/bash" ]; then
sudo echo -e "\nexport GVMUSER=$GVMUSER\nexport GVMPASWD=$GVMPASWD\nexport SSHCON=$SSHCON\nexport APPKEY=\"$APPKEY\"\nexport TOMAIL=$TOMAIL\nexport FROMAIL=$FROMAIL\nexport PORT1=$PORT1\nexport PORT2=$PORT2" >> $HOME/.bashrc
elif [ $SHELL -eq "/usr/bin/zsh" ]; then
sudo echo -e "\nexport GVMUSER=$GVMUSER\nexport GVMPASWD=$GVMPASWD\nexport SSHCON=$SSHCON\nexport APPKEY=\"$APPKEY\"\nexport TOMAIL=$TOMAIL\nexport FROMAIL=$FROMAIL\nexport PORT1=$PORT1\nexport PORT2=$PORT2" >> $HOME/.zshrc
else
echo "Unknown Shell"
return


#Without Keypath
#sudo printf "export SCRIPTPATH="$SCRIPTPATH"\nexport KEYPATH="$KEYPATH"\nexport GVMUSER="$GVMUSER"\nexport GVMPASWD="$GVMPASWD"\nexport SSHCON="$SSHCON"\nexport APPKEY="$APPKEY"\nexport TOMAIL="$TOMAIL"\nexport FROMAIL=$FROMAIL >> $HOME/.bashrc


#START OF INSTALLATION
# of openvas for debian according to ("https://greenbone.github.io/docs/latest/22.4/source-build/index.html") with changes for prompted user and password

if hostnamectl | grep -qiP 'system.*[kK]ali'; then
    echo -e "OS is Kali Linux\npossible installation using apt install\nand we will do it "
    echo "I shall continue on a righteus path"
    sudo apt install openvas -y --fix-missing
    sudo gvm-setup
    sudo -E -u _gvm -g _gvm gvmd --delete-user=admin
    sudo -E -u _gvm -g _gvm gvmd --create-user=$GVMUSER --password=$GVMPASWD
    curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/service-setup.sh -o service-setup.sh
    sudo bash service-setup.sh "kali"

    
elif hostnamectl | grep -qiP 'system.*[dD]ebian'; then
    echo -e "OS is Debian Linux\nonly possible installation using source and build to install\n it is a hasle but that's why this script exist\n do you want to install:(y/n)"
    read ans
    if [ $ans == y ]; then
        echo "I shall continue on this treacherous path"
            #Creating user for next steps
            sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/pre-setup.sh) 

            #Start installation of openvas (Debian) source: https://greenbone.github.io/docs/latest/22.4/source-build/index.html
            #PS: Followning script (install-setup.sh) is just copy pasted from source
            sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/install-setup.sh)
            sudo bash <(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/service-setup.sh) "deb"
    fi
fi 

#END OF INSTALLATION

#Create Services and configure them

#IMPORTANT 

echo -e "\n And for the last step change the password"
passwd
