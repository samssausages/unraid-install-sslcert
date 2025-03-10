# unraid-install-sslcert

This script helps you install and update custom SSL Certificates on Unraid.

It is setup to work with pfsense and ACME certificates

One script retrieves the certs to your local server from pfsense, using SSH and the ACME plugin.
The other script copies them over and restarts the webserver.
 
The newest version combines the script into one.  If you don't need the SSH function from pfsense, use the old script.

# Install
- Use User-Scripts and set a cron schedule, ideally for 60 days.  Set your letsencrypt renewal to 59 days.
- Enable SSH on pfsense:
    1.  Create new user named "user" in pfsense
    2.  Add Effective Privileges "admins"
    3.  Add your SSH Key to the "Authorized Keys" section
 - Enable SSH on Unraid:
    1.  Generate SSH key
```
ssh-keygen -t ed25519 -a 100 -f /boot/config/ssh/pfsense

# Ensure the .ssh directory exists for root
mkdir -p /root/.ssh

# Copy the key to root's .ssh directory
cp /boot/config/ssh/pfsense /root/.ssh/pfsense
cp /boot/config/ssh/pfsense.pub /root/.ssh/pfsense.pub

# Set correct permissions
chmod 600 /root/.ssh/pfsense
chmod 644 /root/.ssh/pfsense.pub
```
    2.  Edit or create file: /boot/config/ssh/config
```
Host pfsense
    Hostname 10.10.10.1
    user user
    Identityfile ~/.ssh/pfsense
```
  3. Test on unraid with:
```
ssh pfsense
```

Changelog:
v1.0
- Depreciated rsync in favor of more simple copy command
- Added various pre and post checks, with better logging
v0.7
- Increased usability with server_name variable, so user doesn't need to update the raw path.
- added error check to cp operation
- added error check to restart nginx operation
