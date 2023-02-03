#!/bin/bash
set -e

output=$(husarnet-dds singleshot 2>/dev/null)
if [[ "$HUSARNET_DDS_VERBOSE" == "TRUE" ]]; then
  echo "$output"
fi

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

exec "$@"
