#!/usr/bin/expect -f
set timeout -1
spawn ssh -N -o StrictHostKeyChecking=no -R $env(PORT2):localhost:9392 "$env(SCONU)@$env(SCONI)"
expect "assword"
send "$env(SSHPASSWD)\n"
expect eof