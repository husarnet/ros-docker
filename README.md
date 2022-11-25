# ros

ROS docker images with built-in configs for Husarnet VPN

## Available envs

- `DDS-CONFIG=HUSARNET_SIMPLE_AUTO` - activates simple DDS discovery mechnism with all Husarnet peers listed in a XML DDS config file.
- `DDS_CONFIG=HUSARNET_DISCOVERY_SERVER` - activates [Fast DDS Discovery Server](https://docs.ros.org/en/humble/Tutorials/Advanced/Discovery-Server/Discovery-Server.html) mechanism that works only for devices within the same Husarnet network. Additional env `ROS_DISCOVERY_SERVER` pointing on the hostname of the device running a discovery server need to be set for each "client" devices (see example below for details)
- `DDS_CONFIG=ENVSUBST` - allows you to bind mount the DDS XML config file to the containers that has environment variables inside. Those envs need to be set before the container startup.
s
## How to use it?

### `Dockerfile`

```Dockerfile
FROM husarnet/ros:humble-ros-base

RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-demo-nodes-cpp && \
    rm -rf /var/lib/apt/lists/*

# WORKDIR where you build ROS2 packages should point to /ros2_ws - this directory is used in the ENTRYPOINT
WORKDIR /ros2_ws 

RUN mkdir src && \
    git clone https://github.com/husarion/rosbot_ros.git src/rosbot_ros -b humble && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build

# ENTRYPOINT ["/ros_entrypoint.sh"] Do not override entrypoint - this is where magic happens
CMD ros2 run demo_nodes_cpp talker
```

build with:

```
docker build -t chatter:humble .
```

### `compose.yaml`

For computers/robots in the same Husarnet network:

#### `HUSARNET_SIMPLE_AUTO` setting

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - DDS_CONFIG=HUSARNET_SIMPLE_AUTO
    command: ros2 run demo_nodes_cpp talker
```

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - DDS_CONFIG=HUSARNET_SIMPLE_AUTO
    command: ros2 run demo_nodes_cpp listener
```

#### `HUSARNET_SIMPLE_AUTO` setting

First, run the discovery server on 1st device (further we assume that the Husarnet hostname of a discovery server device is `ds`)

```yaml
services:
  discovery-server:
    image: husarnet/ros:humble-ros-core
    network_mode: host
    ipc: host
    environment:
      - DDS_CONFIG=HUSARNET_DISCOVERY_SERVER
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
      - DDS_CONFIG=HUSARNET_DISCOVERY_SERVER
      - ROS_DISCOVERY_SERVER=ds # ds is a hostname of the device running Discovery Server
    command: ros2 run demo_nodes_cpp talker
```

```yaml
services:
  chatter:
    image: chatter:humble
    network_mode: host
    ipc: host
    environment:
      - DDS_CONFIG=HUSARNET_DISCOVERY_SERVER
      - ROS_DISCOVERY_SERVER=ds # ds is a hostname of the device running Discovery Server
    command: ros2 run demo_nodes_cpp listener
```