# Using `ROS_STATIC_PEERS` env

Create a `.env` file based on the `.env.template` as a reference, and insert your Husarnet Join Code as the `JOINCODE` env.

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
