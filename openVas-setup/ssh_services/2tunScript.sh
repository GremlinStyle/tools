#!/bin/bash
#SSH Con
#ssh -N -o StrictHostKeyChecking=no -i $keypath$ -R 8080:localhost:22 $sshconection$
ssh -N -o StrictHostKeyChecking=no -R $PORT$:localhost:22 $sshconection$
