#! /bin/bash -e

sleep 5

export HOME='/var/jenkins_home'

/usr/sbin/nginx

# ===================================================
# Certs install
#/root/install_certs.sh
# ===================================================


# ===================================================
# Certs update to crontab
#/root/certs_update.sh
# ===================================================

/usr/local/bin/jenkins2.sh

exec "$@"