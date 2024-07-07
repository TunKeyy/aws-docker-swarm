variable "key_name" {
  default = "test-docker-swarm"
}

variable "sec_group_name" {
  default = "Docker Swarm Security Group"
}

variable "sec_group_description" {
  default = "Docker Swarm Security Group - allow All Trafic to My IP"
}

variable "user_data" {
  default = "./config.sh"
}

variable "volume_size" {
  default = 8
}

variable "ip_list" {
  description = "Allowed IPs"
  type = list(string)
  default = [ 
    "0.0.0.0/0", 
    ]
}

variable "instance_count" {
  default = 2
}

variable "port_list" {
  description = "Allow ports"
  type = list(number)
  default = [ 
    22,
    80,
    8080,
    ]
}