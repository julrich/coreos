ui = true

storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

max_lease_ttl = "720h"
default_lease_ttl = "168h"
cluster_name = "rm-vault"

telemetry {
  statsd_address = "momcorphq.vault-exporter-statsd.services.ruhmesmeile.local:9125"
}