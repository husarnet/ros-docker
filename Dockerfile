ARG ROS_DISTRO=humble
ARG TAG=core

FROM ubuntu:20.04 AS husarnet-dds-getter

ARG TARGETARCH
ARG HUSARNET_DDS_RELEASE="v1.1.0"

RUN apt update && apt install -y \
        curl

RUN curl -L https://github.com/husarnet/husarnet-dds/releases/download/${HUSARNET_DDS_RELEASE}/husarnet-dds-linux-${TARGETARCH} -o /usr/bin/husarnet-dds

FROM ros:$ROS_DISTRO-ros-$TAG

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-rmw-fastrtps-cpp \
        ros-$ROS_DISTRO-rmw-cyclonedds-cpp && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=husarnet-dds-getter /usr/bin/husarnet-dds /usr/bin/husarnet-dds
RUN chmod +x /usr/bin/husarnet-dds

COPY . /

WORKDIR /ros2_ws

RUN echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
