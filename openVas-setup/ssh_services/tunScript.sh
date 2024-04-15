#!/bin/bash
#Openvas Con
#ssh -N -o StrictHostKeyChecking=no -i $keypath$ -R 8081:localhost:9392 $sshconection$
ssh -N -o StrictHostKeyChecking=no -R $port2$:localhost:9392 $sshconection$
