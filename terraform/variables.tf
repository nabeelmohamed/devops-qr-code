variable "vpc-name" {}
variable "igw-name" {}
variable "rt-name" {}
variable "subnet-name" {}
variable "sg-name" {}
variable "instance-name" {}
variable "key-name" {}
variable "iam-role" {}
variable "region" {}
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
variable "cluster_name" {}
