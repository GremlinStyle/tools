#!/usr/bin/expect -f
set timeout -1
spawn ssh -N -o StrictHostKeyChecking=no -R $env(PORT1):localhost:22 $env(SSHCON)
expect "assword"
send "$env(SSHPASSWD)\n"
expect eof