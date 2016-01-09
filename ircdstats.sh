#!/bin/sh
# Cron script to telnet to ircd and log output of commands so we can run stats
# TODO: Clean this up so it just updates /var/www/htdocs/member/Strykar/images/ircdstats.sh_irc.hackerzlair.org.rrd
MYHOST=localhost

# This is inefficient and needs to change.
# Currently awk-drops first 3 columns and prints server date:time:tz, uptime and connection count
# geckoo www.hackerzlair.org :Tuesday December 18 2012 -- 05:08:54 -06:00
# geckoo :Server Up 62 days, 22:28:41
# geckoo :Highest connection count: 11 (9 clients) (381 connections received)

( echo NICK geckoo ; echo 'USER strykar 8 * :strykar' ; echo OPER geckoo OPERPassHERE ; echo TIME ; echo STATS u ; echo QUIT :Done ; sleep 10 ) | telnet $MYHOST 6667 | awk '{ print substr($0, index($0,$3)) }' | grep -A 1 -B 1 -w ":Server Up" >> /home/strykar/scripts/logs/ircd_result.txt
