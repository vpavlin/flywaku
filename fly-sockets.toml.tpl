# fly.toml file generated for wakunode on 2023-05-22T14:17:22+02:00

app = "@@NAME@@"
kill_signal = "SIGINT"
kill_timeout = 5
processes = []


[build]
image = "docker.io/statusteam/nim-waku:v0.17.0"

[mounts]
source="@@NAME@@"
destination="/etc/letsencrypt"

[[services]]
internal_port = 9005
protocol = "udp"
[[services.ports]]
port = 9005

[[services]]
internal_port = 60000
protocol = "tcp"
[[services.ports]]
port = 60000

[[services]]
internal_port = 8000
protocol = "tcp"
[[services.ports]]
port = 8000


[experimental]
auto_rollback = true
cmd = [
  "--relay",
  "--topic=/waku/2/default-waku/proto",
  "--dns-discovery=true",
  "--dns-discovery-url=enrtree://AOGECG2SPND25EEFMAJ5WF3KSGJNSGV356DSTL2YVLLZWIV6SAYBM@prod.waku.nodes.status.im",
  "--discv5-discovery=true",
  "--discv5-udp-port=9005",
  "--discv5-enr-auto-update=True",
  "--dns4-domain-name=@@NAME@@.fly.dev",
  "--max-connections=15",
  "--tcp-port=60000",
  "--metrics-server=True",
  "--metrics-server-port=8003",
  "--metrics-server-address=0.0.0.0",
  "--websocket-secure-support=true",
  "--websocket-secure-key-path=/etc/letsencrypt/live/@@NAME@@.fly.dev/privkey.pem",
  "--websocket-secure-cert-path=/etc/letsencrypt/live/@@NAME@@.fly.dev/fullchain.pem",
  "--nodekey=$NODEKEY"
]

#  "--discv5-discovery=true",
#  "--discv5-udp-port=9005",
#  "--discv5-enr-auto-update=True",