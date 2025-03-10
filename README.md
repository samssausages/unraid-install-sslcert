# unraid-install-sslcert

This script helps you install and update custom SSL Certificates on Unraid.

It is setup to work with pfsense and ACME certificates

The newest version combines the retrival script and the install script into one.  If you already have the files and don't need to copy from another host, then use the old script and set the file location.

# Install
- Use User-Scripts and set a cron schedule, ideally for 60 days.  Set your letsencrypt renewal to 59 days.

## Enable SSH on Unraid:

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

## Enable SSH on pfsense:

    1.  Create new user named "user" in pfsense
    2.  Add Effective Privileges "admins"
    3.  Add your SSH Key to the "Authorized Keys" section

- Test SSH connection from unraid with:

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
