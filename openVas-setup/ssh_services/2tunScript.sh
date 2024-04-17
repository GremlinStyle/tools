#!/bin/bash
sleep 180
ssh -N -o StrictHostKeyChecking=no -R "$PORT1":localhost:22 "$SSHCON"
