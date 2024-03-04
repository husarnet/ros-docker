#!/bin/bash
set -e

output=$(husarnet-dds singleshot) || true
if [[ "$HUSARNET_DDS_DEBUG" == "TRUE" ]]; then
  echo "$output"
fi

# setup ros environment
source "/opt/vulcanexus/$ROS_DISTRO/setup.bash"
if [[ -f "/ros2_ws/install/setup.bash" ]]; then
    source "/ros2_ws/install/setup.bash"
    echo "source /ros2_ws/install/setup.bash" >> /etc/bash.bashrc
fi

if [ -z "$USER" ]; then
    export USER=root
elif ! id "$USER" &>/dev/null; then
    useradd -ms /bin/bash "$USER"
fi

# <additional-user-commands>

if [ $# -eq 0 ]; then
    exec gosu $USER /bin/bash
else
    exec gosu $USER "$@"
fi