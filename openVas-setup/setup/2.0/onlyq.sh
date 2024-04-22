#!/bin/bash
SCRIPTPATH=/root/scripts

#START OF SET-VARIBLE 

text=("\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your server: " "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname\e[0m of your server: " "\n\e[96m\e[1m[*]\e[0m Please enter the ssh key password again for me" "\n\e[96m\e[1m[*]\e[0m Now we will use ssh-copy-id to put the freshly generated key onto the server for which will allow us to connect to the server without any need for passwords or keys\n\n\tPlease Enter the \e[31mcomplete path\e[0m to the identity file of the \e[33mserver\e[0m:" "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31mfirst port\e[0m of the server which will be used to tunnel \e[32mssh\e[0m to the server for remote access indepedant of it's network properties:" "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31msecond port\e[0m of the server which will be used to tunnel the \e[32mWebpage\e[0m to the server for accessing the webpage on the main server:" "\n\e[96m\e[1m[*]\e[0m Please enter a name for the \e[31mnew Openvas user\e[0m: " "\n\e[96m\e[1m[*]\e[0m Please enter a \e[31mpassword\e[0m for the new Openvas user: " "\n\e[96m\e[1m[*]\e[0m  Please enter the email used \e[33mto send reports\e[0m: " "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: " "\n\e[96m\e[1m[*]\e[0m  Please type the email used \e[33mto receive reports\e[0m: ")
an=(SCONU SCONI SSHPASSWD pa PORT1 PORT2 GVMUSER GVMPASWD FROMAIL APPKEY TOMAIL)

if [ -e /root/scripts/envar.conf ]; then 
echo -e "A config File was found we will use this one to speed things up\nIf the Variables a right please hit enter without typing anything"; 

len=$(cat /root/scripts/envar.conf | wc -l)
for ((i=1; i<=len; i++)); do
    line=$(sed -n "${i}p" /root/scripts/envar.conf)
    IFS="="
    read -ra newarr <<< "$line"
    echo -e "If the answer is correct please hit enter to proceed otherwise enter the correct answer:${text[$i-1]}\nAnswer found in old config file: ${newarr[1]}\n"
    read ans
    if [ ${#ans} -gt 1 ]; then
    declare ${newarr[0]}=$ans
    ne="${newarr[0]}=$ans"
    sed -i "${i}s/.*/${ne}/" /root/scripts/envar.conf
    echo -e "answer is changed\n"
    else
    echo "answer is unchanged\n"
    fi
done
if [ $i -le ${#text[@]} ]; then
for ((; i <= ${#text[@]}; i++));do
echo -e "${text[$i-1]}"
read ants
declare ${an[$i-1]}=$ants
echo "${an[$i-1]}=$ants" >> /root/scripts/envar.conf
done
fi
else
#SSH CONFIG

#check if pem file is there cause how do you want to get it ? USB / http anyway it needs to be there 

echo -e "\e[96m\e[1m[*]\e[0m Please save the ssh \e[101midentity file\e[0m of the main server first on disk before proceeding\n\tIs the identity file on this device? (\e[32my\e[0m/\e[31mn\e[0m)"
read check

if [ $check == y ]; then echo "Ingore: We will proceed"; else echo "Rude: then please get the keyfile to disk";exit; fi;

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your server: "
read SCONU
echo "SCONU=$SCONU" >> /root/scripts/envar.conf

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname\e[0m of your server: "
read SCONI
echo "SCONI=$SCONI" >> /root/scripts/envar.conf

SSHCON="$SCONU@$SCONI"

echo -e "\n\e[96m\e[1m[*]\e[0m Please leave the \e[31mpassword field NOT empty\e[0m at the ssh-key generation but if you want everything else: "

ssh-keygen -t rsa

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the ssh key password again for me"
read -s SSHPASSWD
echo "SSHPASSWD=$SSHPASSWD" >> /root/scripts/envar.conf

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
echo "PORT1=$PORT1" >> /root/scripts/envar.conf

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31msecond port\e[0m of the server which will be used to tunnel the \e[32mWebpage\e[0m to the server for accessing the webpage on the main server:"
read PORT2
echo "PORT2=$PORT2" >> /root/scripts/envar.conf

#OPENVAS / GVM CONFIG

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a name for the \e[31mnew Openvas user\e[0m: "
read GVMUSER
echo "GVMUSER=$GVMUSER" >> /root/scripts/envar.conf
echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a \e[31mpassword\e[0m for the new Openvas user: "
read -s GVMPASWD
echo "GVMPASWD=$GVMPASWD" >> /root/scripts/envar.conf

#EMAIL CONFIG

echo -e "\n\e[96m\e[1m[*]\e[0m  Please enter the email used \e[33mto send reports\e[0m: "
read FROMAIL
echo "FROMAIL=$FROMAIL" >> /root/scripts/envar.conf
echo -e "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: "
read APPKEY
echo "FROMAIL=$FROMAIL" >> /root/scripts/envar.conf
echo -e "\n\e[96m\e[1m[*]\e[0m  Please type the email used \e[33mto receive reports\e[0m: "
read TOMAIL
echo "FROMAIL=$FROMAIL" >> /root/scripts/envar.conf
fi