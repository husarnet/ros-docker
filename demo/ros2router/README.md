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
