# Overview

Installs and configures security related tools.


## Requirements

none

## Role Variables

none

## Dependencies

none

## Example Playbook

    - hosts: all
      roles:
         - role: security

## License

MIT

## Author Information

Christian Trabold <cookbooks@christian-trabold.de>




# Overview

This repository stores information, ideas and howtos about pentest strategies.

It also stores ansible roles to install and configure pentest tools.

Use [kali-linux](http://docs.kali.org) for a comprehensive collection and playground for the tools.


## Best practices

One of the best methods of understanding your network security posture is to try to defeat it. Place yourself in the mind-set of an attacker.

Launch a FTP bounce scan, idle scan, fragmention attack, or try to tunnel through one of your own proxies.

-- from the `nmap` manual


Build the tools for a future you would want to live in
-- quote EFF


## Decide where you want to start.

Hardening internal nodes or server nodes facing the internet?

    +------------------+       +------------------+   
    |     INTERNAL     |  vs.  |     EXTERNAL     |
    +------------------+       +------------------+

How predictable are attacks from inside (e.g. through a worm or trojan) and from the outside world (e.g. through an attacker or security hole)?

Or start with both?


# Test the workstations

    passwd --maxdays 60 --warndays 50
    Set the maximum number of days a password remains valid. After MAX_DAYS, the password is required to be changed.
    Set the number of days of warning before a password change is required. The WARN_DAYS option is the number of days prior to the password expiring that a user will be warned that his/her password is about to expire.




# Test the servers

Make black boxes gray boxes:

    python sslyze.py --regular --xml_out ssl-check.xml --targets_in ssl-sites.txt
    perl nikto.pl -C -Format html -output report.html -h http://127.0.0.1/


# Rules

- Get permission first
- Be peaceful
- avoid alert fatique

# Action Items

- scan for domains that are public by accident
    + google: site:.domain.name
- SSH connection to internal hosts via default password & with root key
- get all IP addresses
- check suspicious ports & service => overview of vulnerable services on each IP
- check password strength of LDAP users (Feed Hydra with known passwords & usernames)
- get outdated users in LDAP
- Test NFS / samba shares
- check workstation & server systems (nmap, lynis, rkhunter)
- Research WebShell scanner
- Review gauntlet -> monitorama talk ueber Security Scans


# Introduce a Maturity Model

The Center for Internet Security introduces Levels to benchmark the current security level (see 'CIS Benchmarks').

See https://cisecurity.org

Why CIS?

- What do I need to do to make my systems _sufficiently_ reliable and secure, based on my organization's assessment of the costs of security measures versus the value of operating reliable systems for my customers?
- How much is enough?
What method can I use to determine the minimum level of due care based on best-practice benchmarks needed to reduce my enterprise risk to an ecceptable level?
- Who to trust?
Whom can I trust to tell me what I need to do and to help me protect my systems and networks?

TODO Research CIS LEVEL 1 Benchmarks - the Prudent Level of Minimum Due Care

Why I've choosen these steps?

- SysAdmins with any level of security knowledge and experience can understand and perform the specified actions
- The action is unlikely to cause an interrupption of service to the operation system or the applications that run on it
- The actions can be automatically monitored and the configuration verified by Scoring Tools that are available from the Center or by CIS-certified Scoring tools

CIS Level-1 compliance produces substantial improvement in security for the systems connected to the Internet.

    How do you know that your web applications are secure?


Say with me: I DON'T BELIEVE YOU!
Whenever someone says it's DONE, ask for a proof (tests)


# Get an overview

## Host discovery

Scan infrastructure for potential security flaws and attack windows

Examples:

    nmap -sL         # Simply lists each host of the network(s), WITHOUT sending any packets to the target hosts
                     # The list scan is a good sanity check to ensure that you have proper IP addresses for your targets
                     # If the hosts sport domain names you do not recognize , it is worth investigating further to prevent scanning the wrong comany's network.
                     # IMPORTANT: Can not be combined with OS detection etc.

    nmap -sn        # No port scan
                    # Tells nmap not to do a port scan after host discovery - only print out the available hosts ('ping scan')
                    # Can be combined with `--traceroute`

    nmap -sV        # Scan tool versions

    nmap \
        -p 1-65535 \ # Always scann the whole port range to detect 'hidden' services
        -oN \        # normal format
        -oG \        # Grepable format
        -oX \        # XML format
        <file>       # Output file for reference
        --open       # Only show open (or possibly open) ports
        --iflist     # Print host interfaces and routes
        -A           # Aggressive scan options: ASK FOR PERMISSION BEFORE USING THIS! Enables OS detection, version detection, script scanning, and traceroute, RUNS default SCRIPTS!! Does not affect aggressive timing Use -T4 setting
        -6           # Enable IPv6 scanning
        -Pn          # Disable ping (ICMP protocol)
        -sU          # UDP scans (can be combined with TCP scan `-sS`)
                     # UDP scanning is SLOW because of Linux kernel restrictions: max 1 respond per second by default (65536 ports = 18h) so use `-sU with a specific port range e.g. `-p U:1-1000,T:1-65535`
                     # Consider to set `--scan-delay 1s` for UDP scans
        --reason     # Explains why a host and port has the given state (maybe too much detail)

- Customize Output: `-oX scan-report.xml -oN scan-report.nmap <target>`
Disable console output with `-oN scan-report.nmap - <target>`
Output a format to stdout `-oX - <target>` this will output XML to the CLI
Use dynamic placeholders in the filename like

    -oX 'scan-%T-%D.xml'

Output all formats with `-oA <name>` which creates plain, XML and grepable files with the same filename.

- Stealth mode (incognito mode, if firewalls are in use)

Interesting Options when stealth mode is needed:

    `-f` allows to fragment packages
    `-S` spoof source address
    `-data-length <num>` append random data to sent packets
    `--spoof-mac <mac address>`
    `--scan-delay 1s`, `--min-rate` and `--max-rate` to prevent detection by IDS/IPs.

    Or even better use `-T <timing>`:

    paranoid   (0)
    sneaky     (1)
    polite     (2)
    normal     (3) # default
    aggressive (4) # recommended
    insane     (5)

    For scans inside LANs `aggressive` or `insane` are OKAY
    Don't use `polite` unless really needed. Better switch off version detection.

- Scan OS with `-O`
+ use `--osscan-guess` to guess OS more aggressively
+ use `--osscan-limit` to require a TCP port for the detection (otherwise it does not work and doesn't make sense). This option limits OS detection to promising targets and ignores the rest, which saves time during the scan.
- NMAP provides a Scripting Engine (NSE) which allows plugins for detecting vulnerables for example.

Documentation: http://www.nmap.org/book/


- Test firewalls with `--badsum` and `--source-port <portnumber>`

If they let `nmap` through (we get reports) than the firewall is badly configured.


### Lessons learned

An administrator who sees a bunch of connection attempts in her logs from a single system should know that she has been connect scanned (`nmap -sT`).

`-sI` zombie host:probeport (idle scan) is so fascinating (and extraordinary stealthy) that it deserves a dedicated webpage: http://nmap.org/book/idlescan.html

The option `--script=default` enables the default scripts.

IMPORTANT: Scripts can damage the target host.

Better use `--script "not intrusive` or `--script "default and safe`

Some of the scripts in this category are considered _intrusive_ and should not be run against a target network without permission.

The scripts can be specified with `--script <category>`

Categories:

    auth
    broadcast
    default
    discovery
    dos
    exploit
    external
    fuzzer
    intrusive
    malware
    safe
    version
    vuln

NSE script files end with the `.nse` extension.

Example for HTTP scan:

    nmap --script "http-*"

nmap is fast, but speed can be an issue when considering firewall restrictions e.g. response rate limiting.

- There is a GUI for nmap e.g. to convert XML reports to HTML

    http://nmapparser.wordpress.com

- Evaluate Tunnel Broker www.tunnelbroker.net
- Run a test on scanme.nmap.org?


## Collect Host Hardening Index for all hosts

1) Run `lynis` on the mission critical nodes to perform a system audit.
2) Run the audit on developers machines as well to detect issues e.g. malware.
3) Install as CRON and collect hardening status as metric

Useful commands:

    lynis --check-update
    lynis --view-categories
    lynis --auditor "Christian Trabold" --check-all --no-log --cronjob

See dedicated README in subfolder for details.

# Plugins

    ./lynis --no-log --quick --auditor "Christian Trabold" --plugin-dir /home/christian/Desktop/lynis-plugins --tests "CUS-0000"

## Cronjobs

Running Lynis as a cronjob is also possible. For that purpose the --cronjob parameter exists. By adding this option all special chars will be stripped from the output and the scan will be run completely automated (no user intervention needed).

Example:

    #!/bin/sh

    AUDITOR="automated"
    DATE=$(date +%Y%m%d)
    HOST=$(hostname)
    LOG_DIR="/var/log/lynis"
    REPORT="$LOG_DIR/report-${HOST}.${DATE}"
    DATA="$LOG_DIR/report-data-${HOST}.${DATE}.txt"
    
    cd /usr/local/lynis
    ./lynis -c --auditor "${AUDITOR}" --cronjob > ${REPORT}
    
    mv /var/log/lynis-report.dat ${DATA}
    # The End

Add the contents of this script to /etc/cron.daily/lynis and create the related paths in the script (/usr/local/lynis and /var/log/lynis).


## Check for malware (based on lynis reports)

- Roll-out packages `rkhunter` and `chkrootkit`

### rkhunter

rkhunter  is a shell script which carries out various checks on the local system to try and detect known rootkits and malware.

FILES
The default settings are stored in `/etc/rkhunter.conf`.
The default settings for CRON and apt config are stored in `/etc/default/rkhunter`.

Interesting flags:

    CRON_DAILY_RUN="true"
    CRON_DB_UPDATE="true"

Modifications of the configuration can be written in `/etc/rkhunter.conf.local`

I'd prefer to write the defaults directly in `/etc/rkhunter.conf` and NOT use the `.local` approach to have one single file of thruth.

Logs are stored in `/var/log/rkhunter.log`.

Run config check after each modification (and in ansible's `template` task):

    rkhunter -C 

Commands:

    rkhunter --update
    rkhunter --list tests
    rkhunter --check \
             --skip-keypress \
             --no-email-on-warning

    rkhunter --check \
             --nocolors \
             --no-email-on-warning \
             --skip-keypress \
             --no-summary | my-script.rb

As CRON:

    rkhunter --cronjob --report-warnings-only --syslog

On 'non-ruby' environments, we might want to set the `DISABLE_UNHIDE=1` option to `DISABLE_UNHIDE=0`

#
# If both the C 'unhide', and Ruby 'unhide.rb', programs exist on the system, then it
# is possible to disable the execution of one of the programs if desired. By default
# rkhunter will look for both programs, and execute each of them as they are found.
# If the value of this option is 0, then both programs will be executed if they are
# present. A value of 1 will disable execution of the C 'unhide' program, and a value
# of 2 will disable the Ruby 'unhide.rb' program. The default value is 0. To disable
# both programs, then disable the 'hidden_procs' test.
#

See all files installed by this package with `dpkg -L rkhunter`


### chkrootkit

This program locally checks for signs of a rootkit chkrootkit is available at: http://www.chkrootkit.org/. `chkrootkit` must run as root.

`chkrootkit` looks rather outdated. Is it still considered useful? Or is `lynis` and `rkhunter` good enough?

On 'false positives': If chkrootkit says that it may have found a rootkit, "don't panic."first, inspect your system and make sure that chkrootkit hasn't found a false positive.  by design, chkrootkit is a bit trigger happy.  it's better to be safe than to be sorry, i suppose.

Please see README.FALSE-POSITIVES for a brief discussion on false positives and a list of know packages that cause false positives.

    chkrootkit -l   # Print available tests

 For example, the following command checks for trojaned ps and ls
 binaries and also checks if the network interface is in promiscuous
 mode.

    chkrootkit ps ls sniffer

 The `-q' option can be used to put chkrootkit in quiet mode -- in
 this mode only output messages with `infected' status are shown.


Configuration: `/etc/chkrootkit.conf`

There is support for excluding files (e.g. dotfiles), using the `-e` flag, for example:

    chkrootkit -e '/lib/init/rw/.mdadm /lib/init/rw/.ramfs'

    WARNING: by using this option you are giving attackers a way to avoid
    detection! Make absolutely sure that these are truly false positives
    and do a periodic check of any excluded files to make sure they are
    still the legitimate files you think they are.



If rooted we can inspect the files that are modified with this command:

    chkrootkit -x | more


### Ideas

Send emails on errors or log files to the monitoring servers?


## Install auditd and configure to the minimum

Start slowly. Only log `/root` folder and `/etc/`?

Similar to `etc watcher`

    sudo apt-get install auditd
    sudo auditctl –w /etc/login.defs –p wa
    sudo auditctl –w /etc/securetty
    sudo auditctl –w /var/log/faillog
    sudo auditctl –w /var/log/lastlog




# WIFI

Check for default passwords on base station

    iwlist wlan0 scan

Passive Scanning traffic:

    airmon-ng start wlan0


# Web App Testing with Gamr


    git clone https://github.com/freddyb/Garmr.git
    cd Garmr
    sudo python setup.py install
    garmr -u http://my.target.app

run into issues:

    @see http://stackoverflow.com/questions/5663980/importerror-no-module-named-beautifulsoup
    sudo apt-get install python-beautifulsoup


# VPN

- http://www.rebootuser.com/?p=1474
- http://www.opensourceforu.com/2012/01/ipsec-vpn-penetration-testing-backtrack-tools/
