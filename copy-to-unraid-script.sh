#!/bin/bash

#v0.1
######################unraid-install-sslcert######################
###################### User Defined Options ######################

# Define the source directory where the certificates are stored
source_dir="/mnt/certs"

# Define the source certificate file names (I use pfsense with the ACME package, it follows this naming pattern) 
src_cert="subdomain.topleveldomain.com.all.pem"
src_key="subdomain.topleveldomain.com.key"

# Define target directories with respective filenames.  Unraid prefixes certs with your server name, i.e. 'tower_unraid_bundel.pem'. Make sure to replace "tower" with your servername.
# Browse to 'yourserver.com/Settings/ManagementAccess', after configuring "Local TLD:" with your domain name, look for the name of "Self-signed or user-provided certificate:".
# Then make sure to make the name here match.
targets=(
  "/boot/config/ssl/certs/tower_unraid_bundle.pem"
  "/boot/config/ssl/certs/tower_unraid_key.pem"
)

###### Don't change below unless you know what you're doing ######
##################################################################

# Check if the source directory exists
if [ ! -d "$source_dir" ]; then
  echo "Error: Source directory not found: $source_dir"
  exit 1
fi

# Check if the source certificate files exist
if [ ! -f "$source_dir/$src_cert" ] || [ ! -f "$source_dir/$src_key" ]; then
  echo "Error: Source certificate files not found"
  exit 1
fi

# Copy and rename the source certificate files to each target directory
for ((i=0; i<${#targets[@]}; i+=2)); do
  target_dir=$(dirname "${targets[$i]}")
  tgt_cert=$(basename "${targets[$i]}")
  tgt_key=$(basename "${targets[$i+1]}")

  if [ ! -d "$target_dir" ]; then
    echo "Error: Target directory not found: $target_dir"
    continue
  fi

  cp "$source_dir/$src_cert" "$target_dir/$tgt_cert"
  cp "$source_dir/$src_key" "$target_dir/$tgt_key"

  # Set appropriate permissions for the certificate files
  chmod 600 "$target_dir/$tgt_cert"
  chmod 600 "$target_dir/$tgt_key"

  echo "Successfully copied and renamed SSL certificates to $target_dir"
done

# Restart the Nginx web server to apply the changes
echo "Restarting Nginx web server to apply SSL certificate changes..."
/etc/rc.d/rc.nginx restart

echo "SSL certificates successfully reloaded"
