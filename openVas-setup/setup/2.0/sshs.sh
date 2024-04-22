#!/usr/bin/expect -f
spawn ssh -N -o StrictHostKeyChecking=no -R $env(PORT1):localhost:22 $env(SSHCON)
expect "assword"
send "$env(SSHPASSWD)\n"
interact