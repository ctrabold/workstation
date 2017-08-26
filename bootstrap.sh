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
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if [[ $CI == true ]]; then
    echo "INFO Running in CI mode. Not installing any packages"
  else
    brew tap Homebrew/bundle

    echo "Cleanup 'homebrew'"
    brew prune && brew cleanup && brew tap --repair

    echo "Cleanup dock"
    dockutil --remove all
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
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
  fi
fi

# Run ansible
echo "INFO Check ansible playbook"
ansible-playbook -i ${SOURCE_DIR}/hosts.ini -K ${SOURCE_DIR}/playbook.yml "$@" --syntax-check

if [[ $CI == true ]]; then
  echo "INFO Not installing anything on CI environment for now. Exiting with last exit status..."
  exit $?
fi

echo "INFO Execute ansible playbook"
ansible-playbook -i ${SOURCE_DIR}/hosts.ini -K ${SOURCE_DIR}/playbook.yml "$@"
