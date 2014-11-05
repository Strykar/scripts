#!/bin/bash
# Wrapper for cron to check and start TF2 server from $SCRIPT if need be

# cron is setup as:
# @reboot /home/tf2server/tf2d.sh start &> /dev/null
# */5 * * * * /home/tf2server/crontf2d.sh &> /dev/null
#

if ! /usr/bin/pgrep srcds ; then /home/tf2server/tf2d.sh start; fi
