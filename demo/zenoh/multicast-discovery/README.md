# Using Zenoh RMW with `scouting/multicast/enabled=true`

This demo illustrates how to connect ROS nodes scattered over multiple hosts using the Zenoh middleware without the need to setup a Zenoh router.

Please be aware that multicast discovery is disabled by default for important reasons. See the [excerpt from Zenoh RMW's design documentation](https://github.com/ros2/rmw_zenoh/blob/rolling/docs/design.md#brief-overview) below:

> The UDP Multicast Scouting is disabled by default. The decision to not rely on UDP multicast for discovery was intentional, aimed at avoiding issues with misconfigured networks, operating systems, or containers. It also helps prevent uncontrolled communication between robots in the same LAN, which could lead to interferences if not properly configured with different ROS_DOMAIN_ID or namespaces.

Husarnet is not used in this demo, as at the time of writing, Husarnet does not support multicast connections. Instead, the demo uses a Docker network to simulate a LAN where multicast discovery can be tested.

There are two hosts, `talker-host` and `listener-host`, both connected using a Docker network, `zenoh-multicast-discovery-net`:
- `talker-host` runs a talker node that scouts for peers using multicast on all available network interfaces
- `listener-host` runs a listener node that scouts for peers using multicast on all available network interfaces

For more information about enabling multicast discovery, [see here.](https://github.com/ros2/rmw_zenoh?tab=readme-ov-file#examples)

For more information about the general Zenoh RMW setup, [visit the project repository.](https://github.com/ros2/rmw_zenoh)

Please note that the provided `rmw-zenoh-session.json5` config file is an unmodified copy of the default config from Zenoh RMW repository.

## Basic Setup

Create a `.env` file based on the `.env.template` as a reference. There you can change the ROS distribution by setting `CHOOSEN_ROS=jazzy`.

### Creating a Network

```bash
docker network create zenoh-multicast-discovery-net
```

### Running the Talker

```bash
CHATTER_ROLE=talker docker compose up --build --force-recreate
```

### Running the Listener

```bash
CHATTER_ROLE=listener docker compose up --build --force-recreate
```
