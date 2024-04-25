#!/bin/bash

text=( "\n\e[96m\e[5m\e[1m[*]\e[0m \e[33mthe username\e[0m of your managment server " "\n\e[96m\e[5m\e[1m[*]\e[0m \e[33mthe hostname\e[0m of your managment server " "\n\e[96m\e[5m\e[1m[*]\e[0m password of the ssh-key generation " "\n\e[96m\e[5m\e[1m[*]\e[0m the password of the managment server identity file file " "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31mfirst port\e[0m of the managment server" "\n\e[96m\e[5m\e[1m[*]\e[0m \e[31msecond port\e[0m of the managment server" "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31m Openvas username\e[0m " "\n\e[96m\e[5m\e[1m[*]\e[0m \e[31mpassword\e[0m for the of Openvas user" "\n\e[96m\e[5m\e[1m[*]\e[0m the email used \e[33mto send reports\e[0m " "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31mAppkey\e[0m of the email" "\n\e[96m\e[5m\e[1m[*]\e[0m the email used \e[33mto receive reports\e[0m ")
an=(SCONU SCONI SSHPASSWD SSHPASSWDS PORT1 PORT2 GVMUSER GVMPASWD FROMAIL APPKEY TOMAIL)

# usefull commands
#read -ep $'He\nllo:'
#


#Checks password matches password policy
check_pass() {
    local password="$1"

    # Define criteria for a strong password
    local min_length=10
    local has_lowercase="[a-z]"
    local has_uppercase="[A-Z]"
    local has_digit="[0-9]"
    local has_special_char="[\!\"§\$\%\&\/\(\)=?\`´*+~#'\-_\.,;.:<>\|\^°\{\}\\ß@€µ]|[\{-µ]|[€])|([\!-\/]|[:-@]|[\[-\`]|[{-µ]|[€])"

    # Check if the password meets the criteria
    if [ ${#password} -lt $min_length ]; then
        echo "Password is too short. It must be at least $min_length characters long."
        return 1
    fi

    if ! [[ $password =~ $has_lowercase ]]; then
        echo "Password must contain at least one lowercase letter."
        return 1
    fi

    if ! [[ $password =~ $has_uppercase ]]; then
        echo "Password must contain at least one uppercase letter."
        return 1
    fi

    if ! [[ $password =~ $has_digit ]]; then
        echo "Password must contain at least one digit."
        return 1
    fi

    if ! [[ $password =~ $has_special_char ]]; then
        echo "Password must contain at least one special character."
        return 1
    fi

    # Password meets all criteria
    echo "Password is strong."
    return 0
}

#Check port but also compare entered Port to ports used on server
#Is a not used Feature:
check_port_new_need_some_working_on_due_sshkeygen_happening_later(){
local uio="$2"
local port="$1"
tef=false

ppp=$(expect -c "
set timeout -1
spawn ssh $SCONU@$SCONI netstat -tuna
expect \"Enter passphrase for key\"
send \"$SSHPASSWD\r\"
expect eof
" | awk '{print $4}' | grep -oE ':[0-9]+$' | cut -d ':' -f 2 | sort -n | uniq)

while ! $tef;do
    if [ ${#uio} -lt 1 ];then
        read -e  -p "Enter the Port: " p1
    else
        p1="$uio"
    fi
    if (( $p1 >= 49152 && $p1 <= 65535 )); then
        eval "$port"="$p1"

        if [ $PORT1 == $PORT2 ];then
            echo "first port and second port are the same which should not be"
        else
            tefck=true
            for pp in ${ppp[@]};do
                if [ ${!port} == $pp ];then
                    echo -e "Port alread -e y in usage"
                    tefck=false    
                fi
            done
            if [ $tefck == true ]; then
            tef=true
            fi
        fi
    else
        uio=""
        echo "Entered Port is not within range"
    fi
done
}

#In password fiel displays entered char with *
#Not In Usage
hidepas() {
    int=""
    while IFS= read -e  -r -s -n1 char; do
        if [[ $char == $'\0' || $char == $'\n' || $char == $'\r' ]]; then
            break
        elif [[ $char == $'\177' || $char == $'\b' ]]; then  # Try '\b' for Backspace
            int="${int%?}"
            echo -ne "\b \b"
        else
            echo -n "*"
            int+="$char"
        fi
    done
    echo
}

#pasword function: Ask for password two times, compaer first with second time, if true declare VarName=password
#Special thing in case of APPKEY do not use password policy check 
pas() {
    poi="$2"
    teck=false
    while ! $teck; do
        if [ ${#poi} -gt 2 ];then
            read -e  -s -p "Please enter the value: " once
            echo""
            read -e  -s -p "Please repeat it: " twice
            if [ "$once" == "$twice" ]; then
                teck=true
                eval "$1"="'$once'" 
            else
                echo "The first input does not match the second. Try again."
            fi          
        else
        read -e  -s -p "Please enter the value: " once
        echo""
        read -e  -s -p "Please repeat it: " twice

        if [ "$once" == "$twice" ]; then
            if [[ $(check_pass "$once") == "Password is strong." ]];then 
                echo -e "\nA strong password"
                teck=true
                eval "$1"="'$once'"
            else
                echo -e "\nPassword to weak\t\n$(check_pass "$once")"
            fi
            
        else
            echo "The first input does not match the second. Try again."
        fi
        fi
    done
}

#compares PORT1 with PORT2 if they are the same and within range of 49152-65535
check_port(){
local uio="$2"
local port="$1"
tef=false
while ! $tef;do
    if [ ${#uio} -lt 1 ];then
        read -e  -p "Enter the Port: " p1
    else
        p1="$uio"
    fi
    if (( $p1 >= 49152 && $p1 <= 65535 )); then
        eval "$port"="$p1"
        if [ "$PORT1" == "$PORT2" ];then
            echo "first port and second port are the same which should not be"
            
        else
            tef=true
        fi
    else
        uio=""
        echo "Entered Port is not within range"
    fi
done
}

read -ep $'\e[96m\e[1m[*]\e[0m Please save the ssh \e[101midentity file\e[0m of the main server first on disk before proceeding\n\tIs the identity file on this device? (\e[32my\e[0m/\e[31mn\e[0m): ' check

if [ $check == y ]; then echo "Ignore: We will proceed"; else echo "Rude: then please get the keyfile to disk";exit; fi;

read -ep $'\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your server: ' SCONU


read -ep $'\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname\e[0m of your server: ' SCONI


SSHCON="$SCONU@$SCONI"

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a password for the ssh-key generation "
pas SSHPASSWD
echo ""


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the password of the server identity file "
pas SSHPASSWDS
echo ""


read -ep $'\n\e[96m\e[1m[*]\e[0m Please Enter the \e[31mcomplete path\e[0m to the identity file of the \e[33mserver\e[0m: ' pa

for i in {1..3}; do
    if file $pa | grep -qiP "key"; then
        echo -e "\nDoes look like a key file, thanks and now you may proceed\n"
        break
    else
        echo -e "\nDoesn't look like a key file. PLEASE enter the correct path: "
        read -ep "Input: "  pa
        if [ $i -eq 3 ]; then
            echo -e "Your three chances are gone\nExiting"
            exit
        fi
    fi
done

#SSH config for tunnel:

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31mfirst port\e[0m (between 49152 and 65535) of the server which will be used to tunnel \e[32mssh\e[0m to the server for remote access indepedant of it's network properties:"
check_port PORT1


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31msecond port\e[0m (between 49152 and 65535) of the server which will be used to tunnel the \e[32mWebpage\e[0m to the server for accessing the webpage on the main server:"
check_port PORT2


#OPENVAS / GVM CONFIG

read -ep $'\n\e[96m\e[1m[*]\e[0m Please enter a name for the \e[31mnew Openvas user\e[0m: ' GVMUSER

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a \e[31mpassword\e[0m for the new Openvas user: "
pas GVMPASWD
echo ""

#EMAIL CONFIG

read -ep $'\n\e[96m\e[1m[*]\e[0m  Please enter the email used \e[33mto send reports\e[0m: ' FROMAIL

echo -e "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: "
pas APPKEY 123
echo ""

read -ep $'\n\e[96m\e[1m[*]\e[0m  Please type the email used \e[33mto receive reports\e[0m: ' TOMAIL

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

read -ep $'\n\e[96m\e[1m[*]\e[0m Please check if all variables are correct. In case they are correct press \e[32my\e[0m else press \e[31mn\e[0m: ' check 
if [ $check == "y" ]; then
    echo -e "We proceed with the installation"
    #echo -e "SCONU=$SCONU\nSCONI=$SCONI\nSSHPASSWD=$SSHPASSWD\nPORT1=$PORT1\nPORT2=$PORT2\nGVMUSER=$GVMUSER\nGVMPASWD=$GVMPASWD\nFROMAIL=$FROMAIL\nAPPKEY=$APPKEY\nTOMAIL=$TOMAIL" > /root/scripts/envar.conf
    #echo "" > /root/scripts/envar.conf
    #for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
else
    echo -e "\n\e[96m\e[1m[*]\e[0m  Please answer the question correctly in case they are correct hit enter"
    

    for ((i=0; i<${#an[@]};i++));do
        if [[ ${an[$i]} =~ $pattern ]]; then
            echo -e "${text[$i]} [***]"
            teck=false
                while ! $teck; do
                    read -e  -s -p "Please enter the value: " once
                    if [ ${#once} -gt 1 ];then
                        read -e  -s -p "Please repeat it: " twice
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
        elif [[ "${an[$i]}" =~ "PORT" ]];then
            echo -e "${text[$i]} [${!an[$i]}]"
            read -e  -p "Enter the Port: " portint
            if [ "${portint}" -gt 0 ];then
                check_port ${an[$i]} $portint
                echo -e "answer is changed\n"
            else
                echo -e "answer is unchanged\n"
            fi
        else
            echo -e ${text[$i]} [${!an[$i]}]
            read -ep "Input: "  inp
            if [ ${#inp} -gt 1 ];then
                #echo -e "answer is changed\n"
                declare ${an[$i]}=$inp
            else
                echo -e "answer is unchanged\n"
            fi
        fi
    done
    #echo "" > /root/scripts/envar.conf
    #for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
    #echo -e "SCONU=$SCONU\nSCONI=$SCONI\nSSHPASSWD$SSHPASSWD\nPORT1=$PORT1\nPORT2=$PORT2\nGVMUSER=$GVMUSER\nGVMPASWD=$GVMPASWD\nFROMAIL=$FROMAIL\nAPPKEY=$APPKEY\nTOMAIL=$TOMAIL" > /root/scripts/envar.conf
fi


printenv
for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}";done