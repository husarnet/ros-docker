# Using `CYCLONEDDS_URI`

This demo illustrates how to use the `CYCLONEDDS_URI` environment variable with the `husarnet/ros:$ROS_DISTRO-ros-core` image.

## Basic Setup

Create a `.env` file based on the `.env.template` as a reference, and insert your Husarnet Join Code as the `JOINCODE` env.

### Running the Talker

Open a new terminal and execute:

```bash
CHATTER_ROLE=talker docker compose up --build --force-recreate
```

### Running the Listener

Open a new terminal and execute:

```bash
CHATTER_ROLE=listener docker compose up --build --force-recreate
```
