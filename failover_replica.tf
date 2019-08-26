#----------------------------#
#   INSTANCE SPECIFICATION   #
#----------------------------#

resource "google_sql_database_instance" "failover_replica" {
  count = var.high_available ? 1 : 0

  name                 = "${var.instance_name_without_version}-failover-replica-v${var.map_major_version[var.engine_version]}"
  region               = var.region
  database_version     = var.engine_version
  master_instance_name = google_sql_database_instance.master.name

  #------------------------------------------------#
  #   INSTANCE SPECIFICATION / INSTANCE SETTINGS   #
  #------------------------------------------------#

  replica_configuration {
    failover_target = "true"
  }
  settings {
    tier = var.instance_class

    # disk_size = "${var.allocated_storage}"
    disk_autoresize = var.disk_autoresize

    user_labels = {
      is_production               = var.is_production
      tribe                       = var.tribe
      responsible_people          = var.responsible_people
      communication_slack_channel = var.communication_slack_channel
      alert_slack_channel         = var.alert_slack_channel
      repository                  = var.repository
    }

    #-------------------------------------------------#
    #   INSTANCE SPECIFICATION / NETWORK & SECURITY   #
    #-------------------------------------------------#

    ip_configuration {
      private_network = var.private_network
      ipv4_enabled    = "true"

      dynamic "authorized_networks" {
        for_each = [for item in var.sg_default_allowed_ips: item]
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = lookup(authorized_networks.value, "value", null)
        }
      }
      dynamic "authorized_networks" {
        for_each = [for item in var.sg_custom_allowed_ips: item]
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = lookup(authorized_networks.value, "value", null)
        }
      }
    }
  }
}
