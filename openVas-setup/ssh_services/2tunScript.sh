#!/bin/bash
#SSH Con
ssh -N -o StrictHostKeyChecking=no -i /home/kali/adamMADEtunnel/ubuntu-test.pem -R 8080:localhost:22 ubuntu@16.171.200.130
