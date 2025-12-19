# Using Zenoh RMW with `mode="client"`

This demo illustrates how to connect two hosts over Husarnet using the Zenoh middleware by connecting nodes on the client host to a remote Zenoh router.

There are two hosts, `talker-host` and `listener-host`, both connected using Husarnet:
- `talker-host` runs a talker node along with the Zenoh router.
- `listener-host` runs a listener node that connects directly to the remote router.

For more information about connecting to a Zenoh router on another host, [see here.](https://github.com/ros2/rmw_zenoh?tab=readme-ov-file#connecting-to-the-zenoh-router-on-another-host)

For more information about the general Zenoh RMW setup, [visit the project repository.](https://github.com/ros2/rmw_zenoh)

Please note that the provided `rmw-zenoh-*.json5` config files are unmodified copies of the default configs from Zenoh RMW repository.

## Basic Setup

Create a `.env` file based on the `.env.template` as a reference, and insert your Husarnet Join Code as the `JOINCODE` env.

### Running the Talker

Open a new terminal and execute:

```bash
docker compose -f compose.talker.yaml up --build --force-recreate
```

### Running the Listener

Open a new terminal and execute:

```bash
docker compose -f compose.listener.yaml up --build --force-recreate
```
