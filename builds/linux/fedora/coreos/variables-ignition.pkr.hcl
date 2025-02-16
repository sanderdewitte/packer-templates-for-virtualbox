/*
    DESCRIPTION:
    Fedora CoreOS 41 ignition variables used by the Packer Plugin for Oracle VirtualBox (virtualbox-iso).
*/

// VM ignition settings

variable "ignition_url" {
  type        = string
  description = "Fetch the ignition config from a URL and embed it in the installed system."
}
