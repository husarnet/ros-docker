# Using `FASTRTPS_DEFAULT_PROFILES_FILE` (using Discovery Server)

This demo illustrates how to use the `FASTRTPS_DEFAULT_PROFILES_FILE` environment variable. Note that this is a minimal demo and does not require the `husarnet/ros:$ROS_DISTRO-ros-core` image - `ros:$ROS_DISTRO-ros-core` is enough.

For more information about the FastDDS DDS setup, refer to the [FastDDS manual](https://fast-dds.docs.eprosima.com/en/latest/fastdds/xml_configuration/xml_configuration.html)

## Basic Setup

Create a `.env` file based on the `.env.template` as a reference, and insert your Husarnet Join Code as the `JOINCODE` env.

### Running the Discovery Server

Open a new terminal and execute:

```bash
docker compose -f compose.ds.yaml up --force-recreate
```

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
