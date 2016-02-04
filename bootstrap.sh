#!/bin/bash

set -e

SOURCE_DIR=`dirname "${BASH_SOURCE[0]}"`

# Smoketest environment
if [[ `which python` ]]; then
  echo "OK Found python!"
else
  echo "Please install python first."
fi

if [[ $OSTYPE == darwin* ]]; then
  if [[ `which brew` ]]; then
    echo "OK Found homebrew!"
  else
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  fi
fi

# Installing most important package
if [[ `which ansible` ]]; then
  echo "Ansible is already installed"
else
  echo "INFO Installing ansible..."
  if [[ $OSTYPE == darwin* ]]; then
    brew install ansible
  else
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
  fi
fi

# Run ansible
echo "INFO Check ansible playbook"
ansible-playbook -i ${SOURCE_DIR}/hosts.ini -K ${SOURCE_DIR}/playbook.yml $* --syntax-check

echo "INFO Execute ansible playbook"
ansible-playbook -i ${SOURCE_DIR}/hosts.ini -K ${SOURCE_DIR}/playbook.yml $*
