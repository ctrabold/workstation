#!/bin/bash

set -e

SOURCE_DIR=`dirname "${BASH_SOURCE[0]}"`

# Smoketest environment
if [[ `which python` ]]; then
  echo "OK Found python!"
else
  echo "Please install python first."
fi

# Installing most important package
echo "INFO Installing ansible..."
if [[ $OSTYPE == darwin* ]]; then
  brew install ansible
else
  repo_installed=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep rquillo/ansible`
  if [[ repo_installed ]]; then
    echo "Ansible is already installed"
  else
    sudo add-apt-repository -y ppa:rquillo/ansible
    sudo apt-get install -y ansible
  fi
fi

# Run ansible
echo "INFO Execute ansible playbook"
ansible-playbook -i ${SOURCE_DIR}/hosts.ini -K ${SOURCE_DIR}/playbook.yml
