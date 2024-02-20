#!/bin/bash
#Openvas Con
ssh -N -o StrictHostKeyChecking=no -i /home/kali/adamMADEtunnel/ubuntu-test.pem -R 8081:localhost:9392 ubuntu@16.171.200.130
