# Overview

Installs and configures yslow.

## Example

    echo "INFO execute yslow check..."
    FRONTEND_URL=http://example.com
    phantomjs ~/bin/yslow.js -i grade -threshold "F" --dict --console 2 -f tap ${FRONTEND_URL} > yslow.tap


## Requirements

none

## Role Variables

none

## Dependencies

none

## Example Playbook

    - hosts: all
      roles:
         - role: yslow

## License

MIT

## Author Information

Christian Trabold <cookbooks@christian-trabold.de>
