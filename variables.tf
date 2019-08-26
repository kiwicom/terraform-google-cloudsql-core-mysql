#-------------------------------#
#   ENVIRONMENT SPECIFICATION   #
#-------------------------------#

variable "instance_name_without_version" {
}

variable "region" {
}

variable "is_production" {
}

variable "map_env" {
  type        = map(string)
  description = "Map of credits for instances"

  default = {
    "1" = "prod"
    "0" = "non-prod"
  }
}

variable "read_replica" {
}

variable "high_available" {
}

variable "tribe" {
}

variable "responsible_people" {
}

variable "communication_slack_channel" {
}

variable "alert_slack_channel" {
}

variable "repository" {
}

#----------------------------#
#   INSTANCE SPECIFICATION   #
#----------------------------#

variable "map_major_version" {
  type        = map(string)
  description = "Map of Postges versions"

  default = {
    # MySQL 5.7
    "MYSQL_5_7" = "57"
  }
}

variable "engine_version" {
}

variable "instance_class" {
}

variable "read_replica_instance_class" {
}

variable "allocated_storage" {
}

variable "disk_autoresize" {
}

#---------------------------------------------------#
#   INSTANCE SPECIFICATION / MASTER USER SETTINGS   #
#---------------------------------------------------#

variable "master_username" {
}

variable "master_password" {
}

#-------------------------------------------------#
#   INSTANCE SPECIFICATION / NETWORK & SECURITY   #
#-------------------------------------------------#

variable "private_network" {
}

variable "sg_default_allowed_ips" {
  type        = list(map(string))
  description = "List of default whitelisted IPs"
}

variable "sg_custom_allowed_ips" {
  type        = list(map(string))
  description = "List of custom whitelisted IPs"
}

#------------------------------------------------#
#   INSTANCE SPECIFICATION / DATABASE OPTIONS    #
#------------------------------------------------#

variable "db_name" {
}

#-------------------------------------#
#   INSTANCE SPECIFICATION / BACKUP   #
#-------------------------------------#

variable "backup_time" {
}

#-----------------------------------------#
#   INSTANCE SPECIFICATION / MONITORING   #
#-----------------------------------------#

#------------------------------------------#
#   INSTANCE SPECIFICATION / MAINTENANCE   #
#------------------------------------------#

variable "maintenance_window_day" {
}

variable "maintenance_window_hour" {
}

variable "maintenance_update_track" {
}
