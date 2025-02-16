/*
    DESCRIPTION:
    Fedora CoreOS 41 network variables used by the Packer Plugin for Oracle VirtualBox (virtualbox-iso).
*/

// VM network settings

variable "vm_network_predictable_interface_names" {
  type        = bool
  description = "Whether to use consistent network device naming instead of the more traditional ethX naming scheme."
  default     = false
}

variable "vm_network_disable_ipv6" {
  type        = bool
  description = "Whether to disable IPv6 (and only use IPv4)."
  default     = true
}
