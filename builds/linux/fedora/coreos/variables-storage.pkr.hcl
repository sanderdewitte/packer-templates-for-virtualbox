/*
    DESCRIPTION:
    Fedora CoreOS 41 storage variables used by the Packer Plugin for Oracle VirtualBox (virtualbox-iso).
*/

// VM storage settings

variable "vm_disk_devices" {
  type        = string
  description = "Comma separated list of disk devices to use for OS install (e.g. 'sda', or 'sda,sdb')."
  default     = "sda"
}
