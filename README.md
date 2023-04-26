# unraid-install-sslcert

This script helps you install and update custom SSL Certificates on Unraid.

It is setup to work with pfsense and ACME certificates

One script retrieves the certs from pfsense using the ACME plugin.
The other script copies them over and restarts the webserver.


Install using User-Scripts and set a cron schedule, ideally for 60 days.
