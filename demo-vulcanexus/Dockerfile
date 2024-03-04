ARG ROS_DISTRO=humble

FROM husarnet/ros:vulcanexus-humble-ros-core-testing

ARG ROS_DISTRO

SHELL ["/bin/bash", "-c"]

# install ros package
RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-demo-nodes-cpp && \
    rm -rf /var/lib/apt/lists/*
