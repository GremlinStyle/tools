#!/bin/bash

text=( "\n\e[96m\e[5m\e[1m[*]\e[0m \e[33mthe username\e[0m of your managment server " "\n\e[96m\e[5m\e[1m[*]\e[0m \e[33mthe hostname\e[0m of your managment server " "\n\e[96m\e[5m\e[1m[*]\e[0m password of the ssh-key generation " "\n\e[96m\e[5m\e[1m[*]\e[0m the password of the managment server identity file file " "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31mfirst port\e[0m of the managment server" "\n\e[96m\e[5m\e[1m[*]\e[0m \e[31msecond port\e[0m of the managment server" "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31m Openvas username\e[0m " "\n\e[96m\e[5m\e[1m[*]\e[0m \e[31mpassword\e[0m for the of Openvas user" "\n\e[96m\e[5m\e[1m[*]\e[0m the email used \e[33mto send reports\e[0m " "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31mAppkey\e[0m of the email" "\n\e[96m\e[5m\e[1m[*]\e[0m the email used \e[33mto receive reports\e[0m ")
an=(SCONU SCONI SSHPASSWD SSHPASSWDS PORT1 PORT2 GVMUSER GVMPASWD FROMAIL APPKEY TOMAIL)

pas() {
    teck=false
    while ! $teck; do
        read -s -p "Please enter the value: " once
        echo ""
        read -s -p "Please repeat it: " twice

        if [ "$once" == "$twice" ]; then
            teck=true
            eval "$1"="'$once'"
        else
            echo "The first input does not match the second. Try again."
        fi
    done
}

echo -e "\e[96m\e[1m[*]\e[0m Please save the ssh \e[101midentity file\e[0m of the main server first on disk before proceeding\n\tIs the identity file on this device? (\e[32my\e[0m/\e[31mn\e[0m)"
read check

if [ $check == y ]; then echo "Ingore: We will proceed"; else echo "Rude: then please get the keyfile to disk";exit; fi;

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your server: "
read SCONU


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname\e[0m of your server: "
read SCONI


SSHCON="$SCONU@$SCONI"

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a password for the ssh-key generation "
pas SSHPASSWD
echo ""


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the password of the server identity file "
pas SSHPASSWDS
echo ""


echo -e "\n\e[96m\e[1m[*]\e[0m Please Enter the \e[31mcomplete path\e[0m to the identity file of the \e[33mserver\e[0m:"
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
pas GVMPASWD
echo ""

#EMAIL CONFIG

echo -e "\n\e[96m\e[1m[*]\e[0m  Please enter the email used \e[33mto send reports\e[0m: "
read FROMAIL

echo -e "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: "
pas APPKEY
echo ""

echo -e "\n\e[96m\e[1m[*]\e[0m  Please type the email used \e[33mto receive reports\e[0m: "
read TOMAIL

echo -e "\n\e[96m\e[1m[*]\e[0m And for the last step change the \e[31mpassword of the current device user\e[0m to a more secure one\n\tIf you think it is \e[33msecure enough\e[0m please press \e[34mCTRL+D\e[0m to canel"
passwd

pattern="PAS{1,2}WD|KEY"

echo -e "\n\e[96m\e[1m[*]\e[0m Are these Answers correct?"
len=${#an[@]}
for ((i=0; i<len; i++)); do
    if [[ ${an[$i]} =~ $pattern ]]; then
        echo -e "${text[$i]} [***]"
    else
        echo -e "${text[$i]} [${!an[$i]}]"
    fi
done

#mkdir -p /root/scripts
echo -e  "\n\e[96m\e[1m[*]\e[0m Please check if all variables are correct. In case they are correct press \e[32my\e[0m else press \e[31mn\e[0m"
read check 
if [ $check == "y" ]; then
    echo -e "We proceed with the installation"
    #echo "" > /root/scripts/envar.conf
    #for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
else
    echo -e "\n\e[96m\e[1m[*]\e[0m  Please answer the question correctly in case they are correct hit enter"
    

    for ((i=0; i<${#an[@]};i++));do
        if [[ ${an[$i]} =~ $pattern ]]; then
            echo -e "${text[$i]} [***]"
            teck=false
                while ! $teck; do
                    read -s -p "Please enter the value: " once
                    echo ""
                    if [ ${#once} -gt 1 ];then
                    read -s -p "Please repeat it: " twice

                    if [ "$once" == "$twice" ]; then
                        teck=true
                        echo -e "answer is changed\n"
                        eval "${an[$i]}"="'$once'"
                    else
                        echo "\nThe first input does not match the second. Try again."
                    fi
                    else
                        break
                        echo -e "answer is unchanged\n"
                    fi
                done
        else
            echo -e "${text[$i]} [${!an[$i]}]"
            read inp
            if [ ${#inp} -gt 1 ];then
                #echo -e "answer is changed\n"
                declare ${an[$i]}=$inp
            else
                echo -e "answer is unchanged\n"
            fi
        fi
    done
    echo "" > /root/scripts/envar.conf
    #for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
fi