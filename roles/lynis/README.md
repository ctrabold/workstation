# Overview

Customize lynis to perform custom audit checks.

See http://cisofy.com & http://rootkit.nl


## Usage

    /opt/lynis/lynis --auditor "Christian Trabold" --check-all --no-log --quick [--quiet]

Run as CRON job

    /opt/lynis/lynis --auditor "Christian Trabold" --check-all --no-log --cronjob

Ansible:

    - name: Run system checks every day
      cron: name="run lynis"
            user=root
            hour="0"
            job="/usr/sbin/lynis --check-all --no-log --cronjob"
            state=present


## Installation

Configuration is stored in

    /etc/lynis/default.prf

Plugins are stored in

    /etc/lynis/plugins/

Plugins can be used in tests.
Plugins are shell scripts that perform tests (aka bats?)

Example plugin:

    /etc/lynis/plugins/custom_plugin.template


Tests are stored in

    /usr/share/lynsis/include/tests_<group>

Example:

    /usr/share/lynsis/include/tests_accounting

Tests execute plugins and print the reports based on the plugin output.

Boilerplate test:

    /usr/share/lynsis/include/tests_custom.template

Main functions are

    Register
    ReportWarning

They take parameters like --test-no (test number) CUST-0010
The 'CUST-' prefix is mandatory ? for custom plugins.

TODO Clarify what the difference between 'plugins' and 'tests' are

The settings are stored in

- /usr/share/lynsis/db
Properties for tests e.g. file lists
- /usr/share/lynsis/include
Contain tests and meta functions for reporting


View all categories with

    lynis --view-categories

## Add custom files

/usr/share/lynsis/db


## Ideas

- Nagios check report_datetime_end no older than 1d

Customize default properties:

- Set custom report header
    config:profile_name:Audit Template:

- Set 'server' or 'desktop' depending on host:
    config:machine_role:desktop:
