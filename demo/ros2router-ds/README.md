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

Open a new terminal and execute:

```bash
docker compose -f compose.localhost.yaml up
```

Open a new terminal and execute:

```bash
export FASTRTPS_DEFAULT_PROFILES_FILE=$(pwd)/shm-only.xml
export ROS_DOMAIN_ID=42
ros2 run demo_nodes_cpp listener
```