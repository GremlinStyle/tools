#!/bin/bash
sleep 180
ssh -N -o StrictHostKeyChecking=no -R "$PORT2":localhost:9392 "$SSHCON"
