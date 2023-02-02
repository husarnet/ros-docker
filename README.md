# ros

ROS docker images with built-in configs for Husarnet VPN.

[![Build/Publish Docker Image](https://github.com/husarnet/ros/actions/workflows/build_push_test.yaml/badge.svg)](https://github.com/husarnet/ros/actions/workflows/build_push_test.yaml)

## How to use it?

### `Dockerfile`

```Dockerfile
FROM husarnet/ros:humble-ros-base

# install ROS package using apt repository ...
RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-demo-nodes-cpp && \
    rm -rf /var/lib/apt/lists/*

# WORKDIR where you build ROS2 packages should point to /ros2_ws - this directory is used in the ENTRYPOINT
WORKDIR /ros2_ws 

# ... or from sources
RUN mkdir src && \
    git clone https://github.com/husarion/rosbot_ros.git src/rosbot_ros -b humble && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build

# ENTRYPOINT ["/ros_entrypoint.sh"] Do not override the entrypoint - this is where magic happens
CMD ros2 run demo_nodes_cpp talker
```

build with:

```
docker build -t chatter:humble .
```

### `compose.yaml`

For computers/robots in the same Husarnet network:

#### **Fast DDS** - simple discovery

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - RMW_IMPLEMENTATION=rmw_fastrtps_cpp
      - FASTRTPS_DEFAULT_PROFILES_FILE=/fastdds-simple.xml # place here a path to NON-EXISTING file - it will be created in entrypoint with a Husarnet config
    command: ros2 run demo_nodes_cpp talker
```

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - RMW_IMPLEMENTATION=rmw_fastrtps_cpp
      - FASTRTPS_DEFAULT_PROFILES_FILE=/fastdds-simple.xml # place here a path to NON-EXISTING file - it will be created in entrypoint with a Husarnet config
    command: ros2 run demo_nodes_cpp listener
```

#### **Fast DDS** - discovery server

First, run the discovery server on the 1st device (we assume further that the Husarnet hostname of a discovery server device is `ds`)

```yaml
services:
  discovery-server:
    image: husarnet/ros:humble-ros-core
    network_mode: host
    ipc: host
    environment:
      - DISCOVERY_SERVER_PORT=11811
    command: fast-discovery-server -x /dds-husarnet-ds.xml
```

Launching ROS nodes on two separate devices:

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - RMW_IMPLEMENTATION=rmw_fastrtps_cpp
      - FASTRTPS_DEFAULT_PROFILES_FILE=/fastdds-ds.xml
      - ROS_DISCOVERY_SERVER=ds:11811 # ds is a hostname of the device running Discovery Server and 11811 is a port we specifed in DISCOVERY_SERVER_PORT env
    command: ros2 run demo_nodes_cpp talker
```

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - RMW_IMPLEMENTATION=rmw_fastrtps_cpp
      - FASTRTPS_DEFAULT_PROFILES_FILE=/fastdds-ds.xml
      - ROS_DISCOVERY_SERVER=ds:11811 # ds is a hostname of the device running Discovery Server and 11811 is a port we specifed in DISCOVERY_SERVER_PORT env
    command: ros2 run demo_nodes_cpp listener
```

#### **Cyclone DDS** - simple discovery

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
      - CYCLONEDDS_URI=file:///cyclonedds-simple.xml # place here a path to NON-EXISTING file - it will be created in entrypoint with a Husarnet config
    command: ros2 run demo_nodes_cpp talker
```

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
      - CYCLONEDDS_URI=file:///cyclonedds-simple.xml # place here a path to NON-EXISTING file - it will be created in entrypoint with a Husarnet config
    command: ros2 run demo_nodes_cpp listener
```