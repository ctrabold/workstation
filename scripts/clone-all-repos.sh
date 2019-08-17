#!/bin/bash
#
# Public Repos
#
#    curl -s https://api.github.com/orgs/twitter/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'
#
# Private Repos
#
#    curl -u [[USERNAME]] -s https://api.github.com/orgs/[[ORGANIZATION]]/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'
set -eu

GITHUB_USERNAME="christian-trabold"
GITHUB_TOKEN="token"
GITHUB_ORGANIZATION=""

curl -u $GITHUB_USERNAME:$GITHUB_TOKEN -s https://api.github.com/orgs/${GITHUB_ORGANIZATION}/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["clone_url"]} ]}'

