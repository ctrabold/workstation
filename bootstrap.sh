#!/bin/bash

# TODO:
# Check which python
# Get operation system Ubuntu / Mac
# install ansible from repo / brew?
# Run ansible
echo "Let's go!"
ansible-playbook -vvvv -i ./hosts.ini -K playbook.yml --extra-vars "login_user=$USER ansible_hostname=`hostname -f`"
