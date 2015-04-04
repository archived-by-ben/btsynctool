#!/bin/bash
# /usr/local/bin/btsynctool
# version 2 - https://github.com/bengarrett/btsynctool
#
# A number of short-cuts to interact with the BitTorrent Sync daemon.
# Tested on Ubuntu 14.10 with BitTorrent Sync 1.4.111 and 2.0.99.
# Optional support for ANSI colour output using the source-highlight package.
# Use 'sudo apt-get install source-highlight' to install on Ubuntu/Debian
# Use 'sudo yum install source-highlight' to install on CentOS/RedHat/Fedora

# Change these values to match your BitTorrent Sync installation

# Path to the program or binary file
DAEMON=/opt/btsync/btsync

# Path to the configuration file
CONFIG=/opt/btsync/btsync.conf

# Path to the .sync settings folder
SYNC=/opt/btsync/.sync

# Path to the log file
LOG=$SYNC/sync.log

# Path to your favourite text editor
EDITOR=/usr/bin/nano

# The following values should not be changed

# The description and the process name
DESC="BitTorrent Sync"
PROCESS="btsync"

# BitTorrent Sync debug mode trigger file and body 
DEBUGFILE=$SYNC/debug.txt
DEBUGTRIGGER="FFFF"

# Script name
BASE="$(basename $0)"

# getopt arguments
# Tutorial http://linuxaria.com/howto/parse-options-in-your-bash-script-with-getopt
PARSED_OPTIONS=$(getopt -n "$0" -o hSscCrlL:fF:dDv --long "help,generate-config,generate-secrets,config,restart,log::,follow,debug-logging,debug-off,version" -- "$@")

# Bad arguments, something has gone wrong with getopt command.
if [ $? -ne 0 ]; then
  exit 1
fi

# Requirement for getopt
eval set -- "$PARSED_OPTIONS"

# Check the existence of the btsync daemon
if [ ! -f $DAEMON ]; then
  echo "$BASE: could not find the daemon at $DAEMON"
  exit 1
fi

# Check for ANSI colour support
# http://superuser.com/questions/323930/how-to-check-terminal-color-capability-from-command-line
colorTerm() {
 if which tput > /dev/null 2>&1 && [[ $(tput -T$TERM colors) -ge 8 ]]; then
  return 0
 else
  return 1
 fi
}

# Check if source-highlight is installed
sourceHighlight() {
 if hash source-highlight 2>/dev/null; then
   return 0
 else
   return 1
 fi
}

# Check if BitTorrent Sync is in debug logging mode
debugLogging() {
  # check if $DEBUGFILE exists
  if [ -f "$DEBUGFILE" ]; then
    # save content of $DEBUGFILE to local variable
    local debugbody=$(<$DEBUGFILE)
    # compare content of $DEBUGFILE to $DEBUGTRIGGER
    if [ "$debugbody" = "$DEBUGTRIGGER" ]; then
      return 0
    else
      return 1
    fi
 else
  return 1
 fi
}

# Notice for the need to restart BitTorrent Sync
requestRestart() {
  echo "$DESC will need to be restarted before any saved changes take effect"
}

# Restart BitTorrent Sync
restartDaemon() {
  local processid=$(pgrep -x $PROCESS)
  echo "Restart $DESC:"
  if [ ! $processid = "" ]; then
    local args=$(ps -C $PROCESS --no-headers -o cmd)
    echo "Running as process '$PROCESS'. pid = $processid"
    echo "Will restart $PROCESS using the following arguments"
    echo "$args"
    echo ""
    echo "* Stopping $DESC daemon $PROCESS"
    pkill -9 -e -x $PROCESS
    for i in {1..5}
    do
      if ps $processid > /dev/null; then
      sleep 1s
      else
      break
      fi
    done
    if ps $processid > /dev/null; then
      echo "Could not shut down $PROCESS"
      echo "Maybe there is a permissions problem?"
    else
      echo "* Starting $DESC daemon $PROCESS"
      echo ""
      $args
    fi
  else
    echo "$DESC is not running so it will be started in daemon mode"
    echo ""
    $DAEMON --config $CONFIG
  fi
}

# Process script arguments
case "$1" in
 -h|--help)
  printf "Tools to interact with the $DESC daemon."
  printf "\nUsage:"
  printf "\n  $BASE [OPTION]"
  printf "\n\nOptions:"
  printf "\n  -S, --generate-config\t\t Creates a $DESC sample configuration file. *"
  printf "\n  -c, --config\t\t\t Edits the $DESC configuration file. *"
  printf "\n  -C\t\t\t\t Prints the $DESC configuration file."
  printf "\n  -r, --restart\t\t\t Restarts $DESC, needed to apply any configuration changes."
  printf "\n  -l, --log\t\t\t Prints the last 10 lines of the log file."
  printf "\n  -L=K\t\t\t\t Prints the last K lines of the log file."
  printf "\n  -f, --follow\t\t\t Prints the last 10 lines of the log file and append data as the file grows."
  printf "\n  -F=K\t\t\t\t Prints the last K lines of the log file and append data as the file grows."
  printf "\n  -d  --debug-logging\t\t Switches $DESC into debug logging mode. *"
  printf "\n  -D  --debug-off\t\t Switches $DESC into standard logging mode. *"
  printf "\n  -s, --generate-secrets\t Generate a new write secret and display its read secret."
  printf "\n  -v, --version\t\t\t Displays the version and process of $DESC."
  printf "\n  -h, --help\t\t\t Print this message and exit."
  printf "\n\n\t\t\t\t * $DESC will need to be restarted before the changes take effect.\n"
  ;;
 -S|--generate-config)
  echo "Create $DESC sample configuration:"
  if [ -f "$CONFIG" ]; then
   echo "Ignoring request to create a sample configuration file as $CONFIG already exists"
  else
    echo "Print sample configuration file and save it as $CONFIG"
    $DAEMON --dump-sample-config | tee $CONFIG
    if [ -f "$CONFIG" ]; then
      echo "Sample configuration saved as $CONFIG"
      requestRestart
    else
      echo "Could not write to the file $CONFIG"
      echo "Maybe there is a permissions problem?"
    fi
  fi
  ;;
 -c|--config)
  echo "Configure $DESC:"
  $EDITOR "$CONFIG"
  requestRestart
  ;;
 -C)
  echo "Configuration for $DESC:"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s js -i $CONFIG | cat
  else
   cat "$CONFIG"
  fi
  ;;
 -r|--restart)
  restartDaemon
  ;;
 -l|--log)
  echo "Print the last 10 lines of log:"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s syslog -i $LOG | tail
  else
   tail $LOG
  fi
  ;;
 -L)
  echo "Print the last $2 lines of log:"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s syslog -i $LOG | tail -n $2 $LOG
  else
   tail -n $2 $LOG
  fi
  ;;
 -f|--follow)
  echo "Print and follow 10 lines of log:"
  echo "Press CTRL-C to exit"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s syslog -i $LOG | tail -F $LOG
  else
   tail -F $LOG
  fi
  ;;
 -F)
  echo "Print and follow $2 lines of log:"
  echo "Press CTRL-C to exit"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s syslog -i $LOG | tail -F -n $2 $LOG
  else
   tail -F -n $2 $LOG
  fi
  ;;
 -d|--debug-logging)
  echo "Switch into debug logging mode:"
  if debugLogging; then
    echo "$DESC is already in debug logging mode"
  else
    echo "$DEBUGTRIGGER" > $DEBUGFILE
    if debugLogging; then
      echo "Now in debug logging mode"
      requestRestart
    else
      echo "Could not write '$DEBUGTRIGGER' to the file $DEBUGFILE"
      echo "Maybe there is a permissions problem?"
    fi
  fi
  ;;
 -D|--debug-off)
  echo "Switch into normal logging mode:"
  if ! debugLogging; then
    echo "$DESC is already in normal logging mode"
  else
    : > $DEBUGFILE
    if ! debugLogging; then
      echo "Now in normal logging mode"
      requestRestart
    else
      echo "Could not write to the file $DEBUGFILE"
      echo "Maybe there is a permissions problem?"
    fi
  fi
  ;;
 -s|--generate-secrets)
  printf "Generate folder secret key:"
  WSECRET=$($DAEMON --generate-secret)
  RSECRET=$($DAEMON --get-ro-secret $WSECRET)
  printf "\nFull access secret \t$WSECRET"
  printf "\nRead only secret \t$RSECRET"
  printf "\n"
  ;;
 -v|--version)
  v="$($DAEMON --help | head -1)" # btsync v1.*
  if [ -z "$v" ]; then
    v="$($DAEMON --help | head -2)" # btsync v2.*
  fi
  echo $v
  ps -C btsync -f
  ;;
 *)
 echo "$BASE: invalid usage"
 echo "Try '$BASE --help' or '$BASE -h' for more information"
  exit 1
 ;;
esac

exit 0