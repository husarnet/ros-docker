# Using `husarnet/ros2router`

## Basic Setup

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
ros2 run demo_nodes_cpp listener
```