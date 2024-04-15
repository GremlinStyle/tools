#!/bin/bash
#Openvas Con
#ssh -N -o StrictHostKeyChecking=no -i $keypath$ -R 8081:localhost:9392 $sshcone$
ssh -N -o StrictHostKeyChecking=no -R "$PORT2":localhost:9392 "$SSHCON"
