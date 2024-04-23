#!/bin/bash

text=( "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your server: " "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname\e[0m of your server: " "\n\e[96m\e[1m[*]\e[0m Please enter a password for the ssh-key generation " "\n\e[96m\e[1m[*]\e[0m Please enter the password of the server identity file file: " "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31mfirst port\e[0m of the server which will be used to tunnel \e[32mssh\e[0m to the server for remote access indepedant of it's network properties:" "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31msecond port\e[0m of the server which will be used to tunnel the \e[32mWebpage\e[0m to the server for accessing the webpage on the main server:" "\n\e[96m\e[1m[*]\e[0m Please enter a name for the \e[31mnew Openvas user\e[0m: " "\n\e[96m\e[1m[*]\e[0m Please enter a \e[31mpassword\e[0m for the new Openvas user: " "\n\e[96m\e[1m[*]\e[0m Please enter the email used \e[33mto send reports\e[0m: " "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: " "\n\e[96m\e[1m[*]\e[0m Please type the email used \e[33mto receive reports\e[0m: ")
an=(SCONU SCONI SSHPASSWD SSHPASSWDS PORT1 PORT2 GVMUSER GVMPASWD FROMAIL APPKEY TOMAIL)

echo -e "\e[96m\e[1m[*]\e[0m Please save the ssh \e[101midentity file\e[0m of the main server first on disk before proceeding\n\tIs the identity file on this device? (\e[32my\e[0m/\e[31mn\e[0m)"
read check

if [ $check == y ]; then echo "Ingore: We will proceed"; else echo "Rude: then please get the keyfile to disk";exit; fi;

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your server: "
read SCONU


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname\e[0m of your server: "
read SCONI


SSHCON="$SCONU@$SCONI"

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a password for the ssh-key generation "
read -s SSHPASSWD



echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the password of the server identity file file: "
read -s SSHPASSWDS



echo -e "\n\e[96m\e[1m[*]\e[0m Now we will use ssh-copy-id to put the freshly generated key onto the server for which will allow us to connect to the server without any need for passwords or keys\n\n\tPlease Enter the \e[31mcomplete path\e[0m to the identity file of the \e[33mserver\e[0m:"
read pa

for i in {1..3}; do
    if file $pa | grep -qiP "key"; then
        echo -e "\nDoes look like a key file, thanks and now you may proceed\n"
        break
    else
        echo -e "\nDoesn't look like a key file. PLEASE enter the correct path: "
        read pa
        if [ $i -eq 3 ]; then
            echo -e "Your three chances are gone\nExiting"
            exit
        fi
    fi
done

#SSH config for tunnel:

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31mfirst port\e[0m of the server which will be used to tunnel \e[32mssh\e[0m to the server for remote access indepedant of it's network properties:"
read PORT1


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31msecond port\e[0m of the server which will be used to tunnel the \e[32mWebpage\e[0m to the server for accessing the webpage on the main server:"
read PORT2


#OPENVAS / GVM CONFIG

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a name for the \e[31mnew Openvas user\e[0m: "
read GVMUSER

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a \e[31mpassword\e[0m for the new Openvas user: "
read -s GVMPASWD


#EMAIL CONFIG

echo -e "\n\e[96m\e[1m[*]\e[0m  Please enter the email used \e[33mto send reports\e[0m: "
read FROMAIL

echo -e "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: "
read APPKEY

echo -e "\n\e[96m\e[1m[*]\e[0m  Please type the email used \e[33mto receive reports\e[0m: "
read TOMAIL

echo -e "\n\e[96m\e[1m[*]\e[0m And for the last step change the \e[31mpassword of the current device user\e[0m to a more secure one\n\tIf you think it is \e[33msecure enough\e[0m please press \e[34mCTRL+D\e[0m to canel"
passwd

echo -e "\n\e[96m\e[1m[*]\e[0m Are these Answers correct?"
len=${#an[@]}
for ((i=0; i<len; i++)); do
    echo -e "\nQuestion $i:"
    echo -e "${text[$i]}\nAnswer:\t${!an[$i]}"
done

echo -e  "\n\e[96m\e[1m[*]\e[0m Please check if all variables are correct. In case they are correct press \e[32my\e[0m else press \e[31mn\e[0m"
read check 
if [ $check == "y" ]; then
    echo -e "We proceed with the installation"
    #echo -e "SCONU=$SCONU\nSCONI=$SCONI\nSSHPASSWD=$SSHPASSWD\nPORT1=$PORT1\nPORT2=$PORT2\nGVMUSER=$GVMUSER\nGVMPASWD=$GVMPASWD\nFROMAIL=$FROMAIL\nAPPKEY=$APPKEY\nTOMAIL=$TOMAIL" > /root/scripts/envar.conf
    echo "" > /root/scripts/envar.conf
    for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
else
    echo -e "\n\e[96m\e[1m[*]\e[0m  Please answer the question correctly in case they are correct hit enter"
    for ((i=0; i<${#an[@]};i++));do
        echo -e "\nOrginal Answer: ${!an[$i]}${text[$i]}"
        read inp
        if [ ${#inp} -gt 1 ];then
            #echo -e "answer is changed\n"
            declare ${an[$i]}=$inp
            else
            #echo -e "answer is unchanged\n"
        fi
    done
    echo "" > /root/scripts/envar.conf
    for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
    #echo -e "SCONU=$SCONU\nSCONI=$SCONI\nSSHPASSWD$SSHPASSWD\nPORT1=$PORT1\nPORT2=$PORT2\nGVMUSER=$GVMUSER\nGVMPASWD=$GVMPASWD\nFROMAIL=$FROMAIL\nAPPKEY=$APPKEY\nTOMAIL=$TOMAIL" > /root/scripts/envar.conf
fi

#NEEDS USER INPUT MADE SCRIPT WITH EXPECT FOR USER
#Enables the Kali Device to connect without a hitch to the server
#ssh-copy-id  -f -o "IdentityFile $pa" "$SCONU@$SCONI"
#Enables the server to connect without a hitch
#ssh "$SCONU@$SCONI" cat .ssh/id_rsa.pub | tee -a $HOME/.ssh/authorized_keys

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
export SSHPASSWD=$SSHPASSWD
export SSHPASSWDS=$SSHPASSWDS

expect -c "
# Set timeout to -1 to wait indefinitely
set timeout -1

# Spawn ssh-keygen
spawn ssh-keygen -t rsa

# Expect \"Enter file in which to save the key\"
expect \"Enter file in which to save the key\"

# Send a carriage return to accept the default file path
send \"\r\"

expect {
    \"Overwrite (y/n)\" {
        # If \"Overwrite (y/n)\" is encountered, automatically answer \"yes\" (y)
        send \"y\r\"
    }
}

# Expect \"Enter passphrase (empty for no passphrase)\"
expect \"Enter passphrase\"

# Send the SSH password
send \"$SSHPASSWD\r\"
send_user \"$SSHPASSWD\r\"
# Expect \"Enter same passphrase again\"
expect \"Enter same passphrase again\"

# Send the SSH password again
send \"$SSHPASSWD\r\"

# Expect end of file
expect eof
"

#Enables the Kali Device to connect without a hitch to the server
expect -c "
# Set timeout to -1 to wait indefinitely
set timeout -1

# Spawn ssh-keygen
spawn ssh-copy-id  -f -o \"IdentityFile $pa\" \"$SCONU@$SCONI\"
# Expect \"Enter passphrase (empty for no passphrase)\"
expect \"Enter passphrase for key\"
send \"$SSHPASSWDS\"
expect eof
"
#Enables the server to connect without a hitch
expect -c "
log_user 0
spawn -noecho ssh $SCONU@$SCONI cat .ssh/id_rsa.pub
expect \"Enter passphrase for key\"
send \"$SSHPASSWD\r\"
expect -re {ssh-rsa\s+([^\r\n]+)}
puts \$expect_out(0,string)
expect eof
"

sudo apt update
sudo apt install curl xmlstarlet sendmail -y

#START OF INSTALLATION
# of openvas for debian according to ("https://greenbone.github.io/docs/latest/22.4/source-build/index.html") with changes for prompted user and password

if hostnamectl | grep -qiP 'system.*[kK]ali'; then
    echo -e "OS is Kali Linux\npossible installation using apt install\nand we will do it "
    echo "I shall continue on a righteus path"
    sudo apt install openvas -y --fix-missing
    sudo gvm-setup
    sudo -E -u _gvm -g _gvm gvmd --delete-user=admin
    sudo -E -u _gvm -g _gvm gvmd --create-user=$GVMUSER --password=$GVMPASWD
    sudo -E -u _gvm -g _gvm gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value $(sudo -E -u _gvm -g _gvm gvmd --get-users --verbose | grep $GVMUSER | awk '{print $2}')
    curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/setup/2.0/service2.0-setup.sh -o service-setup.sh
    sudo bash service-setup.sh "kali"


    
elif hostnamectl | grep -qiP 'system.*[dD]ebian'; then
    echo -e "OS is Debian Linux\nonly possible installation using source and build to install\n it is a hasle but that's why this script exist\n do you want to install:(y/n)"
    exit
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

