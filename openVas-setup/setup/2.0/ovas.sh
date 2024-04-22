#!/usr/bin/expect -f
spawn ssh -N -o StrictHostKeyChecking=no -R $env(PORT1):localhost:9392 $env(SSHCON)
expect "assword"
send "$env(SSHPASSWD)\n"
interact