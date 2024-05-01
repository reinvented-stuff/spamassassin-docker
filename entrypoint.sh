#!/bin/sh
#
# Entrypoint script
#

set -e

echo "Updating spamassassin databases"
sa-update

echo "Starting spamd"
spamd ${SPAMDOPTIONS}

