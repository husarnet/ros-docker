# ros

ROS docker images with built-in configs for Husarnet VPN

## How to use it?

### Dockerfile

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