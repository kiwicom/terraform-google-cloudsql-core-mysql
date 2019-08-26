#----------------------------#
#   INSTANCE SPECIFICATION   #
#----------------------------#

resource "google_sql_database_instance" "master" {
  name             = "${var.instance_name_without_version}-v${var.map_major_version[var.engine_version]}"
  region           = var.region
  database_version = var.engine_version

  #------------------------------------------------#
  #   INSTANCE SPECIFICATION / INSTANCE SETTINGS   #
  #------------------------------------------------#

  settings {
    tier            = var.instance_class
    disk_size       = var.allocated_storage
    disk_autoresize = var.disk_autoresize

    user_labels = {
      env                         = var.map_env[var.is_production]
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

    #--------------------------------------#
    #   INSTANCE SPECIFICATION / BACKUPS   #
    #--------------------------------------#

    backup_configuration {
      binary_log_enabled = var.is_production
      enabled            = var.is_production
      start_time         = var.backup_time
    }

    #------------------------------------------#
    #   INSTANCE SPECIFICATION / MAINTENANCE   #
    #------------------------------------------#

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_update_track
    }
  }
  # lifecycle {
  #   prevent_destroy = "1"
  # }
}

#------------------------------------#
#   DATABASE OPTIONS SPECIFICATION   #
#------------------------------------#

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.master.name
  # lifecycle {
  #   prevent_destroy = "1"
  # }
}

#-------------------------------#
#   MASTER USER SPECIFICATION   #
#-------------------------------#

resource "google_sql_user" "master" {
  name     = var.master_username
  password = var.master_password
  instance = google_sql_database_instance.master.name
  host     = "%"
}
