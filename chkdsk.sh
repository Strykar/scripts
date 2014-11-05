#!/bin/sh
# Check disk usage periodically via cron and free space up if $full - Stry

# send email to $admin
#ADMIN="admin@hackerzlair.org"

# set alert level in percentage
ALERT=95

# List directories we can safely smoke
D1=/home/strykar/eggdrop/wakka/logs/*
D2=/var/log/*.1
D3=/var/log/*.2
D4=/var/log/*.3
D5=/var/log/*.4


/usr/bin/df -HP | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  #echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $ALERT ]; then
    wall "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)"
    wall "Clearing old logs trying to free up space. Your shiz in /tmp is gone."
#    mail -s "Alert: Almost out of disk space $usep" $ADMIN

    rm $D1
    rm $D2
    rm $D3
    rm $D4
    rm $D5
    rm -rf /tmp/*
fi
done
