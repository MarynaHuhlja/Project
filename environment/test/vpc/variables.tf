variable "name" {
  default = "test-vpc-more"
}

variable "project" {
  default = "Projectmore"
}
variable "env" {
  default = "test"

}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

}


variable "private_subnet_cidrs" {
  default = [
    "10.0.11.0/24",
    "10.0.22.0/24"
  ]
}

variable "default_route_table_tags" {
  description = "Additional tags for the default route table"
  type        = map(string)
  default = {
    Name = "Projectmore-route_table"
  }
}

variable "default_security_group_name" {
  description = "Name to be used on the default security group"
  type        = string
  default     = "Projectmore-route_table"
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = ["proj-public_subnet"]
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = ["proj-privat_subnet"]
}

variable "public_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default = {
    NamePublic = "proj-public_subnet"
  }
}
variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default = {
    NamePrivat = "proj-privat_subnet"
  }
}
