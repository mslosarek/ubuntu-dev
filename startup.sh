#!/bin/bash

# Import SSH keys
if [ -n "$SSH_IMPORT_ID" ]; then
  IMPORT_TYPE=${SSH_IMPORT_FROM:-gh}
  echo "Importing SSH keys for $SSH_IMPORT_ID from $IMPORT_TYPE"
  su - dev -c "ssh-import-id $IMPORT_TYPE:$SSH_IMPORT_ID"
  echo "SSH keys imported successfully"
else
  echo "WARNING: SSH_IMPORT_ID not set. No SSH keys will be imported."
  echo "You may not be able to log in because password authentication is disabled."
fi

# Print exposed ports information
echo "SSH port exposed on host port: ${SSH_PORT:-2222}"

# Handle any additional ports from ADDITIONAL_PORTS
if [ -n "$ADDITIONAL_PORTS" ]; then
  echo "Custom port mappings:"
  IFS=','
  for port_mapping in $ADDITIONAL_PORTS; do
    echo " - $port_mapping"
  done
fi

exec /usr/sbin/sshd -D
