#!/bin/sh
#
# Entrypoint script
#

echo "Starting spamd"
spamd ${SPAMDOPTIONS}

