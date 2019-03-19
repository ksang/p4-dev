#!/bin/bash

# Topology:
#                      h2
#                      |
#                      |
#                    +----+
#                  / | R2 | \
#                /   +----+   \
#              /                \
#            /                   \
#       +----+                  +----+
# h1--- | R1 |------------------| R4 |---h4
#       +----+                  +----+
#             \                  /
#               \              /
#                 \  +----+  /
#                   \| R3 |/
#                    +----+
#                      |
#                      |
#                      h3
#
# Host MAC:     00:04:00:00:00:<NUM>
# Host IP:      10.0.<NUM>.10
# Gateway MAC:  00:aa:bb:00:00:<NUM>
# Gateway IP:   10.0.<NUM>.1
# Link MAC:     00:aa:bb:00:<LINK>:<NUM>
# Link IP:      192.168.<LINK>.<NUM>

display_usage() {
	echo "Usage:"
	echo -e "\t./start_4nodes [JSON_FILE]"
}

if ! [ $(id -u) = 0 ]; then
   echo "Error: the script need to be run as root." >&2
   exit 1
fi
# check argument num
if [ -z "$1" ]
    then
       echo "Error: no behavior model json file supplied."
       display_usage
       exit 1
fi

LD_LIBRARY_PATH=/usr/local/lib python /p4-dev/mininet_env.py --behavioral-exe /home/vagrant/p4lang/bin/simple_router/simple_router --json $1
