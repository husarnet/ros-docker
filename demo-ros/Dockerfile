ARG ROS_DISTRO=humble

FROM husarnet/ros:$ROS_DISTRO-ros-core-testing

ARG ROS_DISTRO

# install ros package
RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-demo-nodes-cpp && \
    rm -rf /var/lib/apt/lists/*
