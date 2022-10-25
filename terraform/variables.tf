variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "setup" {
  default = {
    "foo" = {
      "vm_to_clone" = "bnw_2019_gui"
      "vm_folder" = "BN-ALL-SIMPLIVITY-VMS"
      # and the rest
    },
    "bar" = {
      "vm_to_clone" = "alw_2019_gui"
      "vm_folder" = "AL-ALL-SIMPLIVITY-VMS"
      # and the rest
    },
  }
}
