# workstation

An approach to configure my dev workstation while learning [Ansible](http://www.ansible.com/). Very much WIP

My goal is to reduce the manual steps when installing my Macbook and Ubuntu machine to a minimum.

Because it's boring.

I also use this repo to document my experience with [Ansible](http://www.ansible.com/).

Because it's fun.


# Important

I use this repo to learn a new tool. Thus I consider the content unstable.

Use at your own risk. Thanks!


# Installation

    cd
    mkdir -p bin/
    git clone git@github.com:ctrabold/workstation.git bin/setup

    ./bin/setup/bootstrap.sh

    <provide sudo password>
    <watch ansible do his thing>


# Howtos

Q: How do I see a list of all of the `ansible_` variables?<br>
A: Run this command

    ansible -m setup localhost -i hosts.ini


# TODOs / ideas

- How to handle App-Store Apps? AppleScript?
- Check if `homebrew` is outdated
- Fix `rubygems` install issues
- Add more Apps / create custom casks
<pre>
iShowU_1.92.3.dmg
Slowyapp_v1.2.dmg
onthejob_3.0.6.zip
ChimooTimer.dmg
solarized.zip
yslow-phantomjs-3.1.1.zip
</pre>


# Kudos

Inspired by

- http://marvelley.com/blog/2014/04/11/local-provisioning-with-ansible/
- http://whitewashing.de/2013/11/19/setting_up_development_machines_ansible_edition.html
