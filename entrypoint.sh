#!/bin/sh
#
# Entrypoint script
#

set -e

echo "Updating spamassassin databases"
/usr/bin/sa-update --nogpg -v

echo "Starting spamd"
/usr/sbin/spamd ${SPAMDOPTIONS}

