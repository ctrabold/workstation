#!/bin/bash

# TODO:
# Check which python
# Get operation system Ubuntu / Mac
# install ansible from repo / brew?
# Run ansible
ansible-playbook -i ./hosts.ini -K playbook.yml
