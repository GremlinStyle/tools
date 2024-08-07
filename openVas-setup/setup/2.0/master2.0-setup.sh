#!/bin/bash

text=( "\n\e[96m\e[5m\e[1m[*]\e[0m \e[33mthe username\e[0m of your management server " "\n\e[96m\e[5m\e[1m[*]\e[0m \e[33mthe hostname or IP address\e[0m of your management server " "\n\e[96m\e[5m\e[1m[*]\e[0m passphrase of the ssh-key generation " "\n\e[96m\e[5m\e[1m[*]\e[0m the passphrase of the management server identity file file " "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31mfirst port\e[0m of the management server" "\n\e[96m\e[5m\e[1m[*]\e[0m \e[31msecond port\e[0m of the management server" "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31m Openvas username\e[0m " "\n\e[96m\e[5m\e[1m[*]\e[0m \e[31mpassword\e[0m for the of Openvas user" "\n\e[96m\e[5m\e[1m[*]\e[0m the email used \e[33mto send reports\e[0m " "\n\e[96m\e[5m\e[1m[*]\e[0m the \e[31mAppkey\e[0m of the email" "\n\e[96m\e[5m\e[1m[*]\e[0m the email used \e[33mto receive reports\e[0m ")
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
        #echo "Password is too short. It must be at least $min_length characters long."
        return 1
    fi

    if ! [[ $password =~ $has_lowercase ]]; then
        #echo "Password must contain at least one lowercase letter."
        return 1
    fi

    if ! [[ $password =~ $has_uppercase ]]; then
        #echo "Password must contain at least one uppercase letter."
        return 1
    fi

    if ! [[ $password =~ $has_digit ]]; then
        #echo "Password must contain at least one digit."
        return 1
    fi

    if ! [[ $password =~ $has_special_char ]]; then
        #echo "Password must contain at least one special character."
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
            teck=true
            eval "$1"="'$once'"          
        else
        read -e  -s -p "Please enter the value: " once
        echo""
        read -e  -s -p "Please repeat it: " twice

        if [ "$once" == "$twice" ]; then
            if [[ $(check_pass "$once") == "Password is strong." ]];then 
                echo -e "\nA strong password"
                pas_list=(SSHPASSWD SSHPASSWDS GVMPASWD)
                tmp_list=()
                for i in ${pas_list[@]};do
                    if [[ "$1" != "$i" ]];then
                        tmp_list+=("$i")
                    fi
                done
                tteck=true
                for i in ${tmp_list[@]};do
                    if [ "$once" == "${!i}" ];then
                        echo -e "Password/passphrase already in usage"
                        tteck=false
                    fi
                done
                if [ $tteck == true ];then
                    teck=true
                    eval "$1"="'$once'"
                    echo -e "\n\e[92m\e[5m[*]OK\e[0m"
                fi
            else
                echo -e "\nPassword to weak"
                #break #Stops asking for strong password
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
re="^[0-9]+\$"
while ! $tef;do
    if [ ${#uio} -lt 1 ];then
        read -e  -p "Enter the Port: " p1
    else
        p1="$uio"
    fi
    if [[ $p1 =~ $re ]];then
    if (( $p1 >= 49152 && $p1 <= 65535 )); then
        eval "$port"="$p1"
        if [ "$PORT1" == "$PORT2" ];then
            uio=""
            echo "first port and second port are the same which should not be"
            
        else
            tef=true
            echo -e "\n\e[92m\e[5m[*]OK\e[0m"
        fi
    else
        uio=""
        echo "Entered Port is not within range"
    fi
    else
    echo "Input is not a number"
    uio=""
    fi
done
}

check_mail() {
local email_regex='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
mail="$1"
emailtext="$2"

read -ep "$(echo -e $emailtext) " email
tmail=false
while ! $tmail;do
    # Check if the email matches the pattern
    if [[ $email =~ $email_regex ]]; then
        eval "$mail"="$email"
        echo -e "\n\e[92m\e[5m[*]OK\e[0m"
        tmail=true
    else
        echo "Invalid email address: $email"
        read -ep "Please enter the email again: " email
    fi
done
}

read -ep $'\e[96m\e[1m[*]\e[0m Please save the ssh \e[101midentity file\e[0m of the management server first on disk before proceeding\n\tIs the identity file on this device? (\e[32my\e[0m/\e[31mn\e[0m): ' check

if [ $check == y ]; then echo "Ignore: We will proceed"; else echo "Rude: then please get the keyfile to disk";exit; fi;

read -ep $'\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe username\e[0m of your management server: ' SCONU


read -ep $'\n\e[96m\e[1m[*]\e[0m Please enter \e[33mthe hostname or IP address\e[0m of your management server: ' SCONI


SSHCON="$SCONU@$SCONI"

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a passphrase for the ssh-key generation "
pas SSHPASSWD
echo ""


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the passphrase of the management server identity file "
pas SSHPASSWDS
echo ""


read -ep $'\n\e[96m\e[1m[*]\e[0m Please Enter the \e[31mcomplete path\e[0m to the identity file of the \e[33mmanagement server\e[0m: ' pa

for i in {1..3}; do
    if file $pa | grep -qiP "key"; then
        echo -e "\nDoes look like a key file, thanks and now you may proceed\n"
        break
    else
        echo -e "\nDoesn't look like a key file. PLEASE enter the correct path: "
        read -ep "Path: "  pa
        if [ $i -eq 3 ]; then
            echo -e "Your three chances are gone\nExiting"
            exit
        fi
    fi
done

#SSH config for tunnel:

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31mfirst port\e[0m (between 49152 and 65535) of the management server which will be used to tunnel \e[32mssh\e[0m to the management server for remote access indepedant of it's network properties:"
check_port PORT1


echo -e "\n\e[96m\e[1m[*]\e[0m Please enter the \e[31msecond port\e[0m (between 49152 and 65535) of the management server which will be used to tunnel the \e[32mWebpage\e[0m to the management server for accessing the webpage on the management server:"
check_port PORT2


#OPENVAS / GVM CONFIG

read -ep $'\n\e[96m\e[1m[*]\e[0m Please enter a name for the \e[31mnew Openvas user\e[0m: ' GVMUSER

echo -e "\n\e[96m\e[1m[*]\e[0m Please enter a \e[31mpassword\e[0m for the new Openvas user: "
pas GVMPASWD
echo ""

#EMAIL CONFIG

check_mail FROMAIL '\n\e[96m\e[1m[*]\e[0m  Please enter the email used \e[33mto send reports\e[0m:'

echo -e "\n\e[96m\e[1m[*]\e[0m Please type the \e[31mAppkey\e[0m of the email you use to send reports: "
pas APPKEY 123
echo ""

check_mail TOMAIL '\n\e[96m\e[1m[*]\e[0m  Please type the email used \e[33mto receive reports\e[0m: '

echo -e "\n\e[96m\e[1m[*]\e[0m And for the last step change the \e[31mpassword of the root device user\e[0m to a more secure one\n\tIf you think it is \e[33msecure enough\e[0m please press \e[34mCTRL+D\e[0m to canel"
passwd

echo -e "\n\e[96m\e[1m[*]\e[0m And for the last step change the \e[31mpassword of the $SUDO_USER device user\e[0m to a more secure one\n\tIf you think it is \e[33msecure enough\e[0m please press \e[34mCTRL+D\e[0m to canel"
sudo -u $SUDO_USER passwd 

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

mkdir -p /root/scripts

read -ep $'\n\e[96m\e[1m[*]\e[0m Please check if all variables are correct. In case they are correct press \e[32my\e[0m else press \e[31mn\e[0m: ' check 
if [ $check == "y" ]; then
    echo -e "We proceed with the installation"
    echo "" > /root/scripts/envar.conf
    for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
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
                        echo -e "answer is unchanged\n"
                        break
                    fi
                done
        elif [[ "${an[$i]}" =~ "PORT" ]];then
            echo -e "${text[$i]} [${!an[$i]}]"
            read -e  -p "Enter the Port: " portint
            if [ "${#portint}" -gt 0 ];then
                check_port "${an[$i]}" "$portint"
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
    echo "" > /root/scripts/envar.conf
    for ((i=0; i<${#an[@]};i++));do echo "${an[$i]}=${!an[$i]}" >> /root/scripts/envar.conf; done
fi


#NEEDS USER INPUT MADE SCRIPT WITH EXPECT FOR USER
#Enables the Kali Device to connect without a hitch to the server
#ssh-copy-id  -f -o "IdentityFile $pa" "$SCONU@$SCONI"
#Enables the server to connect without a hitch
#ssh "$SCONU@$SCONI" cat .ssh/id_rsa.pub | tee -a $HOME/.ssh/authorized_keys


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

chmod 700 $pa

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
    \"Overwrite (y/n)\" {send \"y\r\";expect \"Enter passphrase\"}
    \"Enter passphrase\"
}

# Send the SSH password
send \"$SSHPASSWD\r\"
# Expect \"Enter same passphrase again\"
expect \"Enter same passphrase again\"

# Send the SSH password again
send \"$SSHPASSWD\r\"

# Expect end of file
expect eof
"

#Enables the Kali Device to connect without a hitch to the server
expect -c "
set timeout -1
spawn ssh-copy-id  -f -o \"IdentityFile $pa\" \"$SCONU@$SCONI\"
expect {
	\"Are you sure you want to continue connecting\" {send \"yes\n\";expect \"Enter passphrase for key\"}
	\"Enter passphrase for key\"
}
send \"$SSHPASSWDS\r\"
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
" >  $HOME/.ssh/authorized_keys

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
else
echo -e "\n\e[31m\e[1m[*]\e[0m Warning this doesn't seem to be Kali Linux\ncancel script"
fi 


