ARG ROS_DISTRO

FROM husarnet/ros:humble-ros-core-testing

# install ros package
RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-demo-nodes-cpp && \
    rm -rf /var/lib/apt/lists/*
