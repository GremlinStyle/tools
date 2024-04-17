#!/bin/bash
ssh -N -o StrictHostKeyChecking=no -R "$PORT2":localhost:9392 "$SSHCON"
