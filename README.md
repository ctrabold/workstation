# Overview

*This repository is DEPRECATED, no longer supported and utterly outdated.*

I used this repo to document my experience with [Ansible](http://www.ansible.com/) and tools I find useful e.g. to setup my workstation and laptops.

I recommend to have a look at [my dotfiles repo](https://github.com/ctrabold/dotfiles) which supersede this repo in a more lightweight manner.

Thanks for stepping by!

# Installation

    mkdir -p ~/bin/
    git clone https://github.com/ctrabold/workstation.git ~/bin/setup

    ~/bin/setup/bootstrap.sh

    <provide sudo password>
    <watch ansible do his thing>


# Howtos

Q: How do I see a list of all of the `ansible_` variables?<br>
A: Run this command

    cd ~/bin/setup
    ansible -m setup localhost -i hosts.ini

Q: How to write good looking ansible code that is easy to maintain?<br>
A: https://github.com/edx/configuration/wiki/Ansible-Coding-Conventions

Q: How can I manipulate variables?<br>
A: http://jinja.pocoo.org/docs/templates/#builtin-filters


# Kudos

Inspired by

- http://marvelley.com/blog/2014/04/11/local-provisioning-with-ansible/
- http://whitewashing.de/2013/11/19/setting_up_development_machines_ansible_edition.html
