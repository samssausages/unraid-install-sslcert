# unraid-install-sslcert

This script helps you install and update custom SSL Certificates on Unraid.

It is setup to work with pfsense and ACME certificates

One script retrieves the certs to your local server from pfsense, using the ACME plugin.
The other script copies them over and restarts the webserver.

The two scripts could be combined, but I separated them so people who don't use pfsense can use just the one script.

Install using User-Scripts and set a cron schedule, ideally for 60 days.

Changelog:
v0.7
- Increased usability with server_name variable, so user doesn't need to update the raw path.
- added error check to cp operation
- added error check to restart nginx operation
