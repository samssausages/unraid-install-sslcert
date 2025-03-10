#!/bin/bash
set -euo pipefail

# Log function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

# User defined
hostname="tower"
ssh_host="pfsense"

# Remote source files on pfsense
remote_cert="/conf/acme/${hostname}.yourdomain.com.all.pem"
remote_key="/conf/acme/${hostname}.yourdomain.com.key"

# Local destination files
dest_cert="/boot/config/ssl/certs/${hostname}_unraid_bundle.pem"
dest_key="/boot/config/ssl/certs/${hostname}_unraid_key.pem"

# Check destination directories exist
dest_cert_dir=$(dirname "$dest_cert")
dest_key_dir=$(dirname "$dest_key")

if [ ! -d "$dest_cert_dir" ]; then
  log "ERROR: Destination directory not found: $dest_cert_dir"
  exit 1
fi

if [ ! -d "$dest_key_dir" ]; then
  log "ERROR: Destination directory not found: $dest_key_dir"
  exit 1
fi

# Verify remote files exist before attempting copy
ssh "$ssh_host" "test -f '$remote_cert'" || { log "ERROR: Remote certificate not found: $remote_cert"; exit 1; }
ssh "$ssh_host" "test -f '$remote_key'" || { log "ERROR: Remote key file not found: $remote_key"; exit 1; }

# Copy files from pfsense via scp with error checks
if scp "$ssh_host:$remote_cert" "$dest_cert"; then
  log "Certificate file copied successfully."
else
  log "ERROR: Failed copying certificate file."
  exit 1
fi

if scp "$ssh_host:$remote_key" "$dest_key"; then
  log "Key file copied successfully."
else
  log "ERROR: Failed copying key file."
  exit 1
fi

# Set file permissions and verify each step
if chown root:root "$dest_cert" && chmod 600 "$dest_cert"; then
  log "Permissions set for certificate."
else
  log "ERROR: Failed setting permissions for certificate."
  exit 1
fi

if chown root:root "$dest_key" && chmod 600 "$dest_key"; then
  log "Permissions set for key."
else
  log "ERROR: Failed setting permissions for key."
  exit 1
fi

log "Successfully copied and configured SSL certificates."

# Restart Nginx web server with check
log "Restarting Nginx..."
if /etc/rc.d/rc.nginx stop; then
  sleep 5
  if /etc/rc.d/rc.nginx start; then
    log "Nginx restarted successfully."
  else
    log "ERROR: Failed to start Nginx."
    exit 1
  fi
else
  log "ERROR: Failed to stop Nginx."
  exit 1
fi
