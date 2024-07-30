# Using `CYCLONEDDS_URI`

This demo illustrates how to use the `CYCLONEDDS_URI` environment variable. Note that this is a minimal demo and does not require the `husarnet/ros:$ROS_DISTRO-ros-core` image - `ros:$ROS_DISTRO-ros-core` is enough.

For more information about the Cyclone DDS setup, refer to the following versions:

| ROS 2 Distro | Cyclone DDS version |
| - | - |
| Jazzy | [0.10.5](https://github.com/eclipse-cyclonedds/cyclonedds/blob/releases/0.10.x/docs/manual/options.md) |
| Humble | [0.10.4](https://github.com/eclipse-cyclonedds/cyclonedds/blob/releases/0.10.x/docs/manual/options.md) |
| Foxy | [0.7.0](https://github.com/eclipse-cyclonedds/cyclonedds/blob/releases/0.7.x/docs/manual/options.md) |

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
