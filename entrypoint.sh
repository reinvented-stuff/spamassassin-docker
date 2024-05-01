#!/bin/sh
#
# Entrypoint script
#

echo "Updating spamassassin databases"
/usr/bin/sa-update --nogpg -v

echo "Starting spamd"
/usr/sbin/spamd ${SPAMDOPTIONS}

