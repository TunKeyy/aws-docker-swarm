#!/bin/bash

# Read settings from environment variables
var_smbuser=${smbuser:-smbuser}
var_smbpassword=${password:-pass}
var_smbgroup="smbgroup"

useradd $var_smbuser
groupadd $var_smbgroup
usermod -aG $var_smbgroup $var_smbuser

(echo "$var_smbpassword"; echo "$var_smbpassword") | smbpasswd -s -a $var_smbuser

# Prepare data directory
mkdir -p /data
chmod 0770 /data
chown "$var_smbuser:$var_smbgroup" /data

smbd  --foreground --log-stdout