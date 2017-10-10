btsynctool
==========

A shell script to simplify interactions with the BitTorrent Sync daemon.

#### Introduction
This script simplifies the interaction with the BitTorrent Sync daemon for Linux. It handles the following functions.
* Quickly create and edit the BitTorrent Sync configuration file.
* Restart the daemon to apply any new configurations.
* Display the configuration file on screen.
* Display the tail of the log file on screen, both static and as it grows.
* Trigger the debug logging mode.
* Generate combined write and read only secrets.
* Display the version of the daemon.

It is tested with BitTorrent Sync version 2.0.93 and 1.4.111.

#### What's new
[Releases](https://github.com/bengarrett/btsynctool/releases)

#### Install and configure on Ubuntu/Debian
###### Download
```
cd ~
wget https://github.com/bengarrett/btsynctool/archive/master.zip
unzip master.zip
cd btsynctool-master/
```
###### Configure
```
chmod +x btsynctool.sh
nano -B btsynctool.sh
```
###### Install and test
```
sudo cp btsynctool.sh /usr/local/bin/btsynctool
btsynctool -h
```

#### Getting Started
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
  -S, --generate-config          Creates a BitTorrent Sync sample configuration file. * 
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

###### Add colour syntax for configuration output

Ubuntu/Debian: `sudo apt-get install source-highlight`

CentOS/RedHat/Fedora: `sudo yum install source-highlight`

For other distributions the [source highlight website](https://www.gnu.org/software/src-highlite/) has compile instructions.

#### Sample screen shots

##### Help
![btsynctool--help](https://cloud.githubusercontent.com/assets/513842/6430192/7afea28a-c053-11e4-8386-c2bcc1991d10.png)

##### Configuration
![btsynctool-c](https://cloud.githubusercontent.com/assets/513842/6430189/7aca3e1e-c053-11e4-99c4-68bcb7f85126.png)

##### Log file follow
![btsynctool-f](https://cloud.githubusercontent.com/assets/513842/6430190/7acd5176-c053-11e4-9351-26d68ff98851.png)

##### Log file
![btsynctool-l](https://cloud.githubusercontent.com/assets/513842/6430193/7affc3cc-c053-11e4-99cd-79df2fe96c88.png)

##### Generate secrets
![btsynctool-s](https://cloud.githubusercontent.com/assets/513842/6430194/7b2d32bc-c053-11e4-99c6-e84e4ad9eca4.png)

##### Version
![btsynctool-v](https://cloud.githubusercontent.com/assets/513842/6430195/7b316076-c053-11e4-8156-f899fbd96c7a.png)

#### Licence
[The MIT License (MIT)](http://opensource.org/licenses/MIT)
Copyright (c) 2015 Ben Garrett
