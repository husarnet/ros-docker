#!/bin/bash
set -e

output=$(husarnet-dds singleshot) || true
if [[ "$HUSARNET_DDS_DEBUG" == "TRUE" ]]; then
    echo "$output"
fi

# setup ros environment
source "/opt/vulcanexus/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

# <additional-user-commands>

if [ ! -z "$USER" ] && [ "$USER" != "root" ]; then
    # Check if the user already exists; if not, create the user
    if ! id "$USER" &>/dev/null; then
        useradd -ms /bin/bash "$USER"
        echo "[ \"$(whoami)\" != \"$USER\" ] && su - $USER" >> /etc/bash.bashrc
    fi

    if [ $# -eq 0 ]; then
        exec gosu $USER /bin/bash
    else
        exec gosu $USER "$@"
    fi
else
    exec "$@"
fi
