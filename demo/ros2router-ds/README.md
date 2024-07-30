# Using `husarnet/ros2router`: Discovery Server Setup

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

### Running the Listener on localhost

#### With Shared Memory Setup

Open a new terminal and execute:

```bash
docker compose -f compose.shm.yaml up
```

Open a new terminal and execute:

```bash
export FASTRTPS_DEFAULT_PROFILES_FILE=$(pwd)/shm-only.xml
ros2 run demo_nodes_cpp listener
```

#### With `ROS_LOCALHOST_ONLY=1`

Open a new terminal and execute:

```bash
docker compose -f compose.localhost.yaml up
```

Open a new terminal and execute:

```bash
export ROS_LOCALHOST_ONLY=1
ros2 run demo_nodes_cpp listener
```