app = "@@NAME@@"
kill_signal = "SIGINT"
kill_timeout = 5
processes = []


[build]
image = "docker.io/certbot/certbot"

[mounts]
source="@@NAME@@"
destination="/etc/letsencrypt"

[[services]]
internal_port = 80
protocol = "tcp"
[[services.ports]]
port = 80

[[services]]
internal_port = 443
protocol = "tcp"
[[services.ports]]
port = 443


[experimental]
auto_rollback = true
cmd = [
  "certonly",
  "-d",
  "@@NAME@@.fly.dev",
  "-n",
  "--standalone",
  "--email",
  "@@NAME@@@testdomain.com",
  "--agree-tos"
]
