# ros

ROS docker images with built-in configs for Husarnet VPN

## How to use it?

```Dockerfile
FROM husarnet/ros:humble-ros-base

RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-demo-nodes-cpp && \
    rm -rf /var/lib/apt/lists/*

# WORKDIR where you build ROS2 packages should point to /ros2_ws - this directory is used in the ENTRYPOINT
WORKDIR /ros2_ws 

# ENTRYPOINT ["/ros_entrypoint.sh"] Do not override entrypoint - this is where magic happens
CMD ros2 run demo_nodes_cpp talker
```