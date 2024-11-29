#!/bin/bash

CHATTER_ROLE=${1:-talker}

apt update && apt install -y \
    ros-$ROS_DISTRO-demo-nodes-cpp

ros2 run demo_nodes_cpp $CHATTER_ROLE