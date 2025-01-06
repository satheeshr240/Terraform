variable "ami" {
  default = "ami-0e2c8caa4b6378d8c"
}
variable "instance_type" {
  default = "t2.medium"
}
variable "key_name" {
  default = "satheesh"
}
variable "subnet_id" {
  default = "subnet-0b6676147b46014b1"
}
variable "security_group_ids" {
  type    = list(string)
  default = ["sg-06504889e3cde5eb5"]
}
variable "iam_instance_profile" {
  default = "SSM"
}