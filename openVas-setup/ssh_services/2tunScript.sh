#!/bin/bash
#SSH Con
ssh -N -o StrictHostKeyChecking=no -i $sshkey-path -R 8080:localhost:22 $sshcon
