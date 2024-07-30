# Using `ROS_DISCOVERY_SERVER`

This demo illustrates how to use the `ROS_DISCOVERY_SERVER` environment variable and the `fastdds discovery` CLI with Husarnet. Note that this is a minimal demo and does not require the `husarnet/ros:$ROS_DISTRO-ros-core` image - `ros:$ROS_DISTRO-ros-core` is enough.

For more information on the Fast DDS Discovery Server, refer to the [official documentation](https://docs.ros.org/en/jazzy/Tutorials/Advanced/Discovery-Server/Discovery-Server.html)

## Basic Setup

Create a `.env` file based on the `.env.template` as a reference, and insert your Husarnet Join Code as the `JOINCODE` env.

### Running the Disovery Server

Open a new terminal and execute:

```bash
docker compose -f compose.ds.yaml up
```

### Running the Talker

Open a new terminal and execute:

```bash
CHATTER_ROLE=talker docker compose up
```

### Running the Listener

Open a new terminal and execute:

```bash
CHATTER_ROLE=listener docker compose up
```

## Running the [Super Client](https://docs.ros.org/en/jazzy/Tutorials/Advanced/Discovery-Server/Discovery-Server.html#ros-2-introspection)

After executing all the commands above in separate terminals (or on separate hosts), you should see the following containers:

```bash
$ docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS                    PORTS     NAMES
b7dc77b25e9d   ros:jazzy-ros-core          "/ros_entrypoint.sh …"   8 minutes ago    Up 8 minutes                        superclient-chatter-1
3472ab3f307b   husarnet/husarnet:2.0.180   "bash husarnet-docker"   8 minutes ago    Up 8 minutes (healthy)              superclient-husarnet-1
4f823219d3fe   listener-chatter            "/ros_entrypoint.sh …"   19 minutes ago   Up 19 minutes                       listener-chatter-1
5cbeee2d7149   husarnet/husarnet:2.0.180   "bash husarnet-docker"   19 minutes ago   Up 19 minutes (healthy)             listener-husarnet-1
359a5188a078   talker-chatter              "/ros_entrypoint.sh …"   20 minutes ago   Up 19 minutes                       talker-chatter-1
a0770d38bb70   husarnet/husarnet:2.0.180   "bash husarnet-docker"   20 minutes ago   Up 20 minutes (healthy)             talker-husarnet-1
```

If you access the `listener-chatter-1` service you will notice that something may be broken:

```bash
user@host:~$ docker exec -it listener-chatter-1 bash
root@5cbeee2d7149:/# source /opt/ros/jazzy/setup.bash 
root@5cbeee2d7149:/# ros2 topic list
/parameter_events
/rosout
root@5cbeee2d7149:/# ros2 topic echo /chatter
WARNING: topic [/chatter] does not appear to be published yet
Could not determine the type for the passed topic
root@5cbeee2d7149:/# 
```

The reason for this is that the discovery server *limits the discovery data between participants that do not share a topic*. `ROS_DISCOVERY_SERVER=discovery-server-host:11811` runs a "Client" mode. To enable the  "Super Client" mode with discovery data from all the topics, we need to use a custom `superclient.xml` file:

In a new terminal, start a Super Client enabled node:

```bash
docker compose -f compose.superclient.yaml up
```

Then, in another terminal, access the Super Client enabled container:

```bash
user@host:~$ docker exec -it superclient-ros-1 bash
root@3472ab3f307b:/# source /opt/ros/jazzy/setup.bash 
root@3472ab3f307b:/# ros2 topic list
/chatter
/parameter_events
/rosout
root@3472ab3f307b:/# ros2 topic echo /chatter
data: 'Hello World: 1822'
---
data: 'Hello World: 1823'
---
```

## Running ROS 2 Node available from Host OS

To share the same Husarnet IPv6 address between ROS 2 nodes running in Docker containers and those running directly on your host OS, you need to reuse the same instance of the Husarnet Client, which is likely running on the host OS.

First, run the ROS 2 talker node in Docker:

```bash
docker compose -f compose.host.yaml up
```

To listen to the messages from this node on the host, open a separate terminal and run:

```bash
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export ROS_DISCOVERY_SERVER=discovery-server-host:11811
ros2 run demo_nodes_cpp listener
# ros2 topic list will not show /chatter topic because we're not using the Super Client config in this demo
```
