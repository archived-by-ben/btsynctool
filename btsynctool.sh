#!/bin/bash
# /usr/local/bin/btsynctool
# A number of short-cuts to interact with the BitTorrent Sync daemon.
# Tested on Ubuntu 14.04 and BitTorrent Sync 1.3.*.
# Optional support for ANSI colour output using the source-highlight package.
# Use sudo apt-get install source-highlight to install.

DESC="BitTorrent Sync"
CONFIG=/opt/btsync/btsync.conf
DAEMON=/opt/btsync/btsync
EDITOR=/usr/bin/nano
LOG=/opt/btsync/.sync/sync.log

# Script name
BASE="$(basename $0)"

# getopt arguments
# Tutorial http://linuxaria.com/howto/parse-options-in-your-bash-script-with-getopt
PARSED_OPTIONS=$(getopt -n "$0" -o hscClL:fF:v --long "help,generate-secrets,config,log::,follow,version" -- "$@")

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

# Process script arguments
case "$1" in
 -h|--help)
  printf "Tools to interact with the $DESC daemon."
  printf "\nUsage:"
  printf "\n  $BASE [OPTION]"
  printf "\n\nOptions:"
  printf "\n  -c, --config\t\t\t Edits the $DESC configuration file."
  printf "\n  -C\t\t\t\t Prints the $DESC configuration file."
  printf "\n  -l, --log\t\t\t Prints the last 10 lines of the log file."
  printf "\n  -L=K\t\t\t\t Prints the last K lines of the log file."
  printf "\n  -f, --follow\t\t\t Prints the last 10 lines of the log file and append data as the file grows."
  printf "\n  -F=K\t\t\t\t Prints the last K lines of the log file and append data as the file grows."
  printf "\n  -s, --generate-secrets\t Generate a new write secret and display its read secret."
  printf "\n  -v, --version\t\t\t Displays the version of $BASE daemon."
  printf "\n  -h, --help\t\t\t Print this message and exit.\n"
  ;;
 -c|--config)
  echo "Configure $DESC:"
  $EDITOR "$CONFIG"
  ;;
 -C)
  echo "Configuration for $DESC:"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s js -i $CONFIG | cat
  else
   cat "$CONFIG"
  fi
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
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s syslog -i $LOG | tail -f $LOG
  else
   tail -f $LOG
  fi
  ;;
 -F)
  echo "Print and follow $2 lines of log:"
  if colorTerm && sourceHighlight; then
   source-highlight -f esc -s syslog -i $LOG | tail -f -n $2 $LOG
  else
   tail -f -n $2 $LOG
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
  $DAEMON --help | head -1
  ;;
 *)
 echo "$BASE: invalid usage"
 echo "Try '$BASE --help' or '$BASE -h' for more information."
  exit 1
 ;;
esac

exit 0