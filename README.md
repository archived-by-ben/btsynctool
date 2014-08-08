btsynctool
==========

A shell script to simplify interactions with the BitTorrent Sync daemon.

####Introduction
This script simplifies the interaction with the BitTorrent Sync daemon for Linux. It handles the following functions.
* Quickly edit the BitTorrent Sync configuration file.
* Display the configuration file onscreen.
* Display the tail of the log file onscreen, both static and as it grows.
* Generate combined write and read only secrets.
* Display the version of the daemon.

It is tested with BitTorrent Sync version 1.3.106.

####Getting Started
Before beginning there are a number of variables that need to be configured. These that can be found at the top of the script `btsynctool`.
* `CONFIG=` The path to the BitTorrent Sync configuration file (JSON document).
* `DAEMON=` The path to the BitTorrent Sync daemon (application).
* `EDITOR=` The path to your favourite text editor.
* `LOG=`    The path to the BitTorrent Sync log file.

The tool has 8 options plus a help display.

```Usage:
  btsynctool [OPTION]

Options:
  -c, --config                   Edits the BitTorrent Sync configuration file.
  -C                             Prints the BitTorrent Sync configuration file.
  -l, --log                      Prints the last 10 lines of the log file.
  -L=K                           Prints the last K lines of the log file.
  -f, --follow                   Prints the last 10 lines of the log file and append data as the file grows.
  -F=K                           Prints the last K lines of the log file and append data as the file grows.
  -s, --generate-secrets         Generate a new write secret and display its read secret.
  -v, --version                  Displays the version of btsynctool daemon.
  -h, --help                     Print this message and exit.```

####Sample screenshots

####Licence
[The MIT License (MIT)](http://opensource.org/licenses/MIT)
Copyright (c) 2014 Ben Garrett
