/*
    DESCRIPTION:
    Fedora CoreOS ignition variables used by the Packer Plugin for Oracle VirtualBox (virtualbox-iso).
*/

// VM ignition settings

variable "ignition_template" {
  type        = string
  description = "Filename of the ignition template (in the data directory) used to generate config.ign."
  default     = "config.ign.pkrtpl.hcl"
}

variable "ignition_url" {
  type        = string
  description = "Fetch the ignition config from a URL and embed it in the installed system."
}
