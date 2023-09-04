#!/bin/bash

#v0.1
#######################rsync-certs-pfsense########################
###################### User Defined Options ######################

# This script requires you to setup SSH credentials so you can remote into your pfsense box from unraid.  Make a user on your pfsense box that is restricted only to this task & give it the SSH key.
# then config your /boot/config/ssh/config to match the host, user and key.

# SSH login credentials to pfsene box.
SSH_HOST="pfsense"
SSH_USER="rsync"
# Remote directory to download (This is where pfsense acme stores the certs)
REMOTE_DIR="/conf/acme"
# Array of local directories to save files to
LOCAL_DIRS=(
  "/mnt/certs"
  # Add more directories here as needed
)

###### Don't change below unless you know what you're doing ######
##################################################################

for dir in "${LOCAL_DIRS[@]}"; do
  rsync -avz -e ssh "$SSH_USER@$SSH_HOST:$REMOTE_DIR/" "$dir"
done

# echo files copied
local_dirs_str=""
for dir in "${LOCAL_DIRS[@]}"; do
  local_dirs_str+="${dir}, "
done

# Remove the trailing comma and space
local_dirs_str=${local_dirs_str%, }

echo "Finished copying pfSense acme files to ${local_dirs_str}"
