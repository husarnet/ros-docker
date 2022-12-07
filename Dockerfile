ARG ROS_DISTRO=humble
ARG TAG=core

FROM ubuntu:20.04 AS yq-getter

ARG TARGETARCH
ARG YQ_VERSION=v4.30.5 

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
        wget

RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH} -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

FROM ros:$ROS_DISTRO-ros-$TAG

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-rmw-fastrtps-cpp \
        ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
        net-tools \
        gettext-base && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=yq-getter /usr/bin/yq /usr/bin/yq
RUN chmod +x /usr/bin/yq

COPY . /

ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
ENV DDS_CONFIG=DEFAULT

WORKDIR /ros2_ws

# ENV DDS_CONFIG=HUSARNET_SIMPLE_AUTO
# ENV DDS_CONFIG=HUSARNET_DISCOVERY_SERVER
# ENV DDS_CONFIG=ENVSUBST

RUN echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
