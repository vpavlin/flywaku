# flywaku

This repository contains artifacts to deploy [nwaku](https://github.com/waku-org/nwaku) on Fly.io. Fly.io offers limited free tier (1 vCPU, 256 MB RAM), but if you want to run your own Waku node, it is a reasonable minimalistic start.

Start by signing up on fly.io

Then clone this repository.

```
git clone git@github.com:vpavlin/flywaku.git
cd flywaku
```

Next you can `deploy` the node

```
make deploy
```

This will

1. download `flyctl`
1. template `fly.toml` with name of your application 
1. launch (create) the app in Fly.io
1. deploy the app

You will be asked is you want to get an IPv4 allocated - this costs $2/month (based on [current pricing](https://fly.io/docs/about/pricing/#anycast-ip-addresses)). Fly.io automatically assigns IPv6 addresses, but nwaku does not support those at the moment.

Your node should be up and running. You can view the logs by running

```
./flyctl logs
```

If you want to connect to your node, you need to take a look into the logs and find the multiaddress - the log line looks like the following:

```
2023-05-22T19:33:47Z app[91857936f17908] ams [info]INF 2023-05-22 19:33:47.922+00:00 Listening on                               topics="waku node" tid=513 file=waku_node.nim:939 full=[/dns4/vpavlin-wakunode.fly.dev/tcp/60000/p2p/16Uiu2HAmEfW59g6LUsvvBHQ25U9c881VVqwMsUkFiTVebVPSukpj]
```

In particular, you are looking for the multiaddress string (e.g. `/dns4/vpavlin-wakunode.fly.dev/tcp/60000/p2p/16Uiu2HAmEfW59g6LUsvvBHQ25U9c881VVqwMsUkFiTVebVPSukp`)

You can then use a tool like [wakucanary](https://github.com/waku-org/nwaku/tree/master/apps/wakucanary) to check the connectivity to your node

```
wakucanary -p=relay -a=${MULTIADDR_FROM_LOGS}
...
INF 2023-05-22 22:06:39.925+02:00 The node is reachable and supports all specified protocols tid=1140494 file=wakucanary.nim:189
```

In case the node is not available, you can try to run `make deploy` again to make sure the IP was properly assigned to the machine.

## Run With  WSS (WebSockets Secure) Enabled

To enable WSS for your Waku v2 Node, you need to first generate the certificates using Certbot

```
make certs
```

this will deploy an interim container which will obtain certificate and private key from Let's Encrypt and store them in a persistent volume

Once this is done, you can run deployment with `WSS_ENABLED=1` flag to use different `fly.toml` template (i.e. `fly-sockers.toml.tpl`) to have the volume mounted and websocket cert and key configured for yout node

```
make deploy WSS_ENABLED=1
```