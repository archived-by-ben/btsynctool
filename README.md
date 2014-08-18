btsynctool
==========

A shell script to simplify interactions with the BitTorrent Sync daemon.

####Introduction
This script simplifies the interaction with the BitTorrent Sync daemon for Linux. It handles the following functions.
* Quickly edit the BitTorrent Sync configuration file.
* Display the configuration file on screen.
* Display the tail of the log file on screen, both static and as it grows.
* Generate combined write and read only secrets.
* Display the version of the daemon.

It is tested with BitTorrent Sync version 1.3.106.

####Getting Started
Before beginning there are a number of variables that need to be configured. These that can be found at the top of the script `btsynctool`.
* `DAEMON=` The path to the BitTorrent Sync daemon (application).
* `CONFIG=` The path to the BitTorrent Sync configuration file (JSON document).
* `SYNC=` The path to the BitTorrent Sync .sync settings folder.
* `LOG=`    The path to the BitTorrent Sync log file.

The tool has 11 options plus a help display.
```
Tools to interact with the BitTorrent Sync daemon.
Usage:
  btsynctool [OPTION]

Options:
  -c, --config                   Edits the BitTorrent Sync configuration file. *
  -C                             Prints the BitTorrent Sync configuration file.
  -r, --restart                  Restarts BitTorrent Sync, needed to apply any configuration changes.
  -l, --log                      Prints the last 10 lines of the log file.
  -L=K                           Prints the last K lines of the log file.
  -f, --follow                   Prints the last 10 lines of the log file and append data as the file grows.
  -F=K                           Prints the last K lines of the log file and append data as the file grows.
  -d  --debug-logging            Switches BitTorrent Sync into debug logging mode. *
  -D  --debug-off                Switches BitTorrent Sync into standard logging mode. *
  -s, --generate-secrets         Generate a new write secret and display its read secret.
  -v, --version                  Displays the version and process of BitTorrent Sync.
  -h, --help                     Print this message and exit.

                                 * BitTorrent Sync will need to be restarted before the changes take effect.
```

####Sample screenshots

![btsynctool --help](https://raw.githubusercontent.com/bengarrett/btsynctool/master/screenshots/btsynctool--help.png)

![btsynctool --config](https://github.com/bengarrett/btsynctool/blob/master/screenshots/btsynctool-C.png)

![btsynctool -s](https://raw.githubusercontent.com/bengarrett/btsynctool/master/screenshots/btsynctool-s.png)

![btsynctool -v](https://raw.githubusercontent.com/bengarrett/btsynctool/master/screenshots/btsynctool-v.png)

![btsynctool -l](https://raw.githubusercontent.com/bengarrett/btsynctool/master/screenshots/btsynctool-l.png)

![btsynctool -f](https://raw.githubusercontent.com/bengarrett/btsynctool/master/screenshots/btsynctool-f.png)

####Licence
[The MIT License (MIT)](http://opensource.org/licenses/MIT)
Copyright (c) 2014 Ben Garrett
