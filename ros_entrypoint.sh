#!/bin/bash
set -e

# Generate Husarnet DDS config if DISCOVERY_SERVER_PORT is set and not empty.
# For FastDDS Discovery Server - server 
if [[ -n "${DISCOVERY_SERVER_PORT:-}" ]]; then
    husarnet-dds singleshot
fi

# Generate Husarnet DDS config if:
# -RMW_IMPLEMENTATION is rmw_fastrtps_cpp,
# FASTRTPS_DEFAULT_PROFILES_FILE is set and not empty, and the file specified by
# FASTRTPS_DEFAULT_PROFILES_FILE doesn't exist in the file system.
# OR
# - RMW_IMPLEMENTATION is rmw_cyclonedds_cpp,
# CYCLONEDDS_URI is set and not empty, and the file specified by
# CYCLONEDDS_URI doesn't exist in the file system.
if
    (
        [[ "$RMW_IMPLEMENTATION" == "rmw_fastrtps_cpp" ]] &&
            [[ -n "${FASTRTPS_DEFAULT_PROFILES_FILE:-}" ]] &&
            [[ ! -e "$FASTRTPS_DEFAULT_PROFILES_FILE" ]]
    ) || (
        [[ "$RMW_IMPLEMENTATION" == "rmw_cyclonedds_cpp" ]] &&
            [[ -n "${CYCLONEDDS_URI:-}" ]] &&
            [[ ! -e "${CYCLONEDDS_URI#file://}" ]]
    )
then
    husarnet-dds singleshot
fi

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

exec "$@"
