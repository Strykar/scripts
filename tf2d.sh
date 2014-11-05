#!/bin/sh
# 
# Simple script to start TF2 server
# Sat Dec  8 17:43:19 IST 2012
#
# NOTE: This expects the TF2 server to be run as user "tf2server"
#
# Ensure this script is run as tf2server (EUID 500) only.
if [[ $EUID -ne 500 ]]; then
   echo "This script can ONLY be run as user: tf2server"
   echo `/bin/grep tf2server /etc/passwd`
   echo "Perhaps you're root? Your EUID seems to be $EUID"
   exit 1
fi

MAP="jump_4starters_a9"
MAXPLAYERS="24"
GAMEIP="192.168.1.113"
GAMEPORT="27015"
GAMEPID="/home/tf2server/pids/tf2d.pid"
GAMEDIR="/home/tf2server/hlds/gameserver/orangebox"
GAMEBIN="./srcds_run"
STEAMBIN="/home/tf2server/hlds/steam"
GAMEOPTS="-game tf -autoupdate -steambin $STEAMBIN -maxplayers $MAXPLAYERS +map $MAP +ip $GAMEIP -port $GAMEPORT -pidfile $GAMEPID"

start() {
  if ! /usr/bin/pgrep srcds ; then
    rm -f $GAMEPID
    if [ -x /home/tf2server/hlds/gameserver/orangebox/srcds_run -a -x /home/tf2server/hlds/steam ] ; then
         echo "Starting TF2 server with detached screen-name: tf2"
	  echo "You can use screen -r tf2 to bring it back up and Ctrl + A + D will minimize the console."
	  echo "Ctrl+D will terminate the session and Ctrl + A + [ will allow you to scroll through it."
	  echo ""

      cd $GAMEDIR
      /usr/bin/screen -A -m -d -S tf2 $GAMEBIN $GAMEOPTS
	echo "Your server is starting with these options:"
	echo ""
	echo ""
	echo "./srcds "
	echo "$GAMEOPTS"
    fi
  fi
}

stop() {
  if [ -e "$GAMEPID" ]; then
    echo "Stopping Team Fortress server..."
    pid=$(cat $GAMEPID)
    /bin/kill $pid 1> /dev/null 2> /dev/null
    # Just in case:
    /usr/bin/pkill srcds 1> /dev/null 2> /dev/null
    rm -f $GAMEPID
  fi
}

reload() {
  echo "Reloading Team Fortress configuration..."
  if [ -e "$GAMEPID" ]; then
    pid=$(cat $GAMEPID)
    kill -HUP $pid
  else
    /usr/bin/pkill -HUP srcds
  fi
}

config() {
  if [ -x $GAMEDIR/$GAMEBIN -a -x $STEAMBIN ] ; then
	clear
	echo ""
	echo "SRCDS and Steam binaries look good.."
	sleep 1
	echo ""
	echo "My TF 2 config is as follows:"
	sleep 1
  	echo ""
  	echo "Server IP/PORT:	$GAMEIP:$GAMEPORT"		
  	echo "Steam directory:  $STEAMBIN"
  	echo "Game directory:	$GAMEDIR"
  	echo "As user: "	`/bin/grep tf2server /etc/passwd`
  	echo ""
	echo ""
	sleep 1
	echo "SRCDS TF server will start with these options:"
	echo ""
	echo "$GAMEOPTS"
	echo ""
  else
	echo "Uhm..."
	echo "SRCDS and Steam binary paths seem invalid!"
  fi
}
  
status() {
  if /usr/bin/pgrep srcds 2>/dev/null ; then
    echo "Team Fortress 2 server is running."
  else
    echo "Team Fortress server is stopped."
  fi
}

# See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  reload)
    reload
    ;;
  config)
    config
    ;;
  status)
    status
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart|reload|status}"
    ;;
esac
