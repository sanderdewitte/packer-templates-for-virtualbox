/*
    DESCRIPTION:
    Fedora CoreOS 41 variables using the Packer Builder for Oracle VirtualBox (virtualbox-iso).
*/

//  BLOCK: variable
//  Defines the input variables.

// Version

variable "version" {
  type = string
  description = "Image build version."
}

// Virtual Machine Settings

variable "vm_guest_os_type" {
  type        = string
  description = "The guest operating system type, also know as guestid."
}

variable "vm_guest_os_family" {
  type        = string
  description = "The guest operating system family. Used for naming."
}

variable "vm_guest_os_name" {
  type        = string
  description = "The guest operating system name. Used for naming."
}

variable "vm_guest_os_architecture" {
  type        = string
  description = "The guest operating system architecture. Used for naming."
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of virtual CPUs."
}

variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB."
}

variable "vm_disk_size" {
  type        = number
  description = "The size for the virtual disk in MB."
}

variable "vm_audio_controller" {
  type        = string
  description = "The audio controller type to be used. One of `ac97`, `hda` or `sb16`."
  default     = "ac97"
}

variable "vm_gfx_controller" {
  type        = string
  description = "The graphics controller type to be used. One of `vboxvga`, `vboxsvga`, `vmsvga` or `none` (when set to `none` the graphics controller is disabled)."
  default     = "vmsvga"
}

variable "vm_gfx_vram_size" {
  type        = number
  description = "The VRAM size to be used."
  default     = 16
}

variable "vm_gfx_accelerate_3d" {
  type        = bool
  description = "3D acceleration for the graphics controller."
  default     = false
}

variable "vm_nic_type" {
  type        = string
  description = "The NIC type to be used for the network interfacesr. One of `82540EM`, `82543GC`, `82545EM`, `Am79C970A`, `Am79C973`, `Am79C960` or `virtio`."
  default     = "82543GC"
}

// ISO Settings

variable "common_iso_base_path" {
  type        = string
  description = "The base path of a local guest operating system ISO"
  default     = "iso"
}

variable "iso_datastore_stream" {
  type        = string
  description = "Fedora CoreOS stream. One of 'next', 'stable' or 'testing'."
  default     = "stable"
}

// Boot Settings

variable "common_data_source" {
  type        = string
  description = "The provisioning data source. One of `http`, `http_local`, `http_remote` or `disk`."
}

variable "common_http_port_min" {
  type        = number
  description = "The start of the HTTP port range."
  default     = 8000
}

variable "common_http_port_max" {
  type        = number
  description = "The end of the HTTP port range."
  default     = 9000
}

variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before boot."
  default     = "10s"
}

variable "vm_boot_firmware" {
  type        = string
  description = "The boot firmware type for the virtual machine. Allowed values are 'bios', 'efi', 'efi-secure'."
  default     = "efi"
}

variable "common_acpi_shutdown" {
  type        = bool
  description = "whether to shutdown the VM via power button."
  default     = false
}

variable "common_shutdown_timeout" {
  type        = string
  description = "Time to wait for guest operating system shutdown."
  default     = "5m"
}

// Run Settings

variable "common_headless" {
  type        = bool
  description = "Defines whether the VMware virtual machine is built by launching a GUI that shows the console of the machine being built."
  default     = true
}

variable "common_output_base_path" {
  type        = string
  description = "Base path of the directory where the resulting virtual machine will be created."
  default     = "artifacts"
}

// Communicator Settings and Credentials

variable "communicator" {
  type        = string
  description = "The type of communicator protocol to use. One of `none`, `ssh`, `winrm` or a custom builder supported communicator."
  default     = "ssh"
}

variable "communicator_port" {
  type        = number
  description = "The port (on the VM) for the communicator protocol."
  default     = 22
}

variable "communicator_port_host" {
  type        = number
  description = "The port (on the host) for the communicator protocol."
  default     = 2223
}

variable "communicator_timeout" {
  type        = string
  description = "The timeout for the communicator protocol."
  default     = "20m"
}

variable "build_username" {
  type        = string
  description = "The username to login to the guest operating system."
}

variable "build_password" {
  type        = string
  description = "The password to login to the guest operating system."
  sensitive   = true
}

variable "build_password_encrypted" {
  type        = string
  description = "The SHA-512 encrypted password to login to the guest operating system (genreate with 'openssl passwd -6 <unencrypted_password>')."
  sensitive   = true
}

variable "build_private_key_file" {
  type        = string
  description = "The local file containing the private key used for the SSH key pair."
  sensitive   = true
}

variable "build_public_key" {
  type        = string
  description = "The public key to login to the guest operating system."
  sensitive   = true
}

variable "build_public_key_additional" {
  type        = string
  description = "Additional public key to add to authorized_keys (for instance, one created with different ciphers)."
  sensitive   = true
}

variable "build_system_user" {
  type        = bool
  description = "Whether to make the build user a system user (UID < 1000)."
  default     = true
}
