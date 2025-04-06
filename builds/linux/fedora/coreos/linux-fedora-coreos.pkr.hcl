/*
    DESCRIPTION:
    Fedora CoreOS 41 template using the Packer Builder for VirtualBox (virtualbox-iso).
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.12.0"
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
    git = {
      source  = "github.com/ethanmdavidson/git"
      version = ">= 0.6.3"
    }
  }
}

//  BLOCK: data
//  Defines data sources.

data "git-repository" "cwd" {}

//  BLOCK: locals
//  Defines local variables

locals {
  build_timestamp                        = timestamp()
  build_datetime                         = formatdate("YYYY-MM-DD hh:mm ZZZ", "${local.build_timestamp}")
  build_version                          = try(length(data.git-repository.cwd.head) > 0 ? (data.git-repository.cwd.head == "main" ? var.version : join("-", [var.version, data.git-repository.cwd.head, "SNAPSHOT"])) : join("-", [var.version, "PRE-REMOTE"]), join("-", [var.version, "PRE-COMMIT"]))
  build_stream_data                      = jsondecode(file("${abspath(path.root)}/streams/streams/${var.iso_datastore_stream}.json"))
  build_artifact_data                    = lookup(local.build_stream_data.architectures[var.vm_guest_os_architecture].artifacts, "metal", "{'release': '', 'formats': ''}")
  build_iso_data                         = lookup(local.build_artifact_data.formats, "iso", "{'disk': {'location': '', 'sha256': ''}}")
  build_iso_file                         = basename(local.build_iso_data.disk.location)
  build_by                               = "HashiCorp Packer ${packer.version}"
  build_description                      = "Version: ${local.build_version}\nBuilt by: ${local.build_by}\nBuilt on: ${local.build_datetime}\nBuilt from: ${local.build_iso_file}"
  build_vm_guest_os_major_version        = split(".", local.build_artifact_data.release)[0]
  build_vm_name                          = join("-", ["${var.vm_guest_os_family}", "${var.vm_guest_os_name}", "${local.build_vm_guest_os_major_version}", "v${local.build_version}"])
  build_iso_paths                        = {
    localstore = join("/", [replace(lower(join("/", ["${var.common_iso_base_path}", "${var.vm_guest_os_family}", "${var.vm_guest_os_name}", "${local.build_vm_guest_os_major_version}", "${var.vm_guest_os_architecture}"])), " ", "-"), "${local.build_iso_file}"])
    datastore  = "${local.build_iso_data.disk.location}"
  }
  data_source_list                       = split("_", var.common_data_source)
  data_source_destination_device         = length(var.vm_disk_devices) > 0 ? trimspace(split(",", var.vm_disk_devices)[0]) : "sda"
  data_source_command_base               = join(" ", ["coreos.inst.install_dev=/dev/${local.data_source_destination_device}", "coreos.inst.skip_reboot"])
  data_source_command_ignition           = local.data_source_list[0] == "http" ? (local.data_source_list[length(local.data_source_list) - 1] == "remote" ? "coreos.inst.ignition_url=${var.ignition_url}" : "coreos.inst.ignition_url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/config.ign") : join("", ["coreos.inst.ignition_url=cdrom:LABEL=", var.common_data_source, ":/config.ign"])
  data_source_command_post               = var.vm_network_predictable_interface_names ? (var.vm_network_disable_ipv6 ? "ipv6.disable" : "") : (var.vm_network_disable_ipv6 ? join(" ", ["ipv6.disable", "net.ifnames=0", "biosdevname=0"]) : join(" ", ["net.ifnames=0", "biosdevname=0"]))
  data_source_command                    = join(" ", ["${local.data_source_command_base}", "${local.data_source_command_ignition}", "${local.data_source_command_post}"])
  data_source_command_reverse_boot_order = "efibootmgr | grep BootOrder | awk -F' ' '{print $2}' | awk -F',' '{for(i=NF; i>0; i--) printf \"%s%s\", $i, (i>1?\",\":\"\\n\")}' | xargs -I{} efibootmgr -o {} >/dev/null 2>&1"
  data_source_command_reboot             = "systemctl reboot"
  data_source_content                    = {
    "/config.ign" = templatefile("${abspath(path.root)}/data/config.ign.pkrtpl.hcl", {
      build_username              = var.build_username
      build_password_encrypted    = var.build_password_encrypted
      build_public_key            = var.build_public_key
      build_public_key_additional = var.build_public_key_additional
      build_system_user           = var.build_system_user
    })
  }
  manifest_datetime                      = formatdate("YYYYMMDD'T'hhmmss'Z'ZZZ", "${local.build_timestamp}")
  manifest_path                          = "${path.cwd}/manifests/"
  manifest_output                        = join("/", [trimsuffix("${local.manifest_path}", "/"), "${local.build_vm_name}_build_manifest.json"])
}

//  BLOCK: source
//  Defines builder configuration blocks

source "virtualbox-iso" "linux-fedora-coreos" {

  // Virtual Machine settings
  vm_name           = local.build_vm_name
  guest_os_type     = var.vm_guest_os_type
  cpus              = var.vm_cpu_count
  memory            = var.vm_mem_size
  disk_size         = var.vm_disk_size
  audio_controller  = var.vm_audio_controller
  gfx_controller    = var.vm_gfx_controller
  gfx_vram_size     = var.vm_gfx_vram_size
  gfx_accelerate_3d = var.vm_gfx_accelerate_3d
  nic_type          = var.vm_nic_type

  // Removable media settings
  cd_label   = var.common_data_source == "disk" ? var.common_data_source : null
  cd_content = var.common_data_source == "disk" ? local.data_source_content : null

  // HTTP settings
  http_port_min     = var.common_data_source == "http" || var.common_data_source == "http_local" ? var.common_http_port_min : null
  http_port_max     = var.common_data_source == "http" || var.common_data_source == "http_local" ? var.common_http_port_max : null
  http_content      = var.common_data_source == "http" || var.common_data_source == "http_local" ? local.data_source_content : null
  http_bind_address = var.common_data_source == "http" || var.common_data_source == "http_local" ? "0.0.0.0" : null

  // ISO settings
  iso_urls        = [local.build_iso_paths.localstore, local.build_iso_paths.datastore]
  iso_checksum    = "sha256:${local.build_iso_data.disk.sha256}"
  iso_target_path = replace(lower(join("/", ["${var.common_iso_base_path}", "${var.vm_guest_os_family}", "${var.vm_guest_os_name}", "${local.build_vm_guest_os_major_version}", "${var.vm_guest_os_architecture}"])), " ", "-")
  iso_interface   = var.vm_boot_firmware == "bios" ? "ide" : "sata"

  // Boot settings
  firmware        = var.vm_boot_firmware
  boot_wait       = var.vm_boot_wait
  boot_command    = var.vm_boot_firmware == "bios" ? [
    "<spacebar><wait>",
    "<tab>",
    "<down><down><right><leftCtrlOn>k<leftCtrlOff><wait>",
    "${local.data_source_command}",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ] : [
    "<spacebar><wait>",
    "e",
    "<down><down><end><spacebar><wait>",
    "${local.data_source_command}",
    "<down><end><wait>",
    "<leftCtrlOn>x<leftCtrlOff>",
    "<wait70>",
    "<enter><wait>",
    "${local.data_source_command_reverse_boot_order}",
    "<enter><wait>",
    "${local.data_source_command_reboot}",
    "<wait><enter>"
  ]
  vboxmanage_post = var.vm_boot_firmware == "bios" ? [
    ["storageattach", "{{.Name}}", "--storagectl=IDE Controller", "--port=0", "--device=1", "--type=dvddrive", "--medium=emptydrive"],
    ["storageattach", "{{.Name}}", "--storagectl=IDE Controller", "--port=0", "--device=1", "--type=dvddrive", "--medium=none"],
    ["modifyvm", "{{.Name}}", "--boot1", "disk", "--boot2", "none"]
  ] : [
    ["storageattach", "{{.Name}}", "--storagectl=SATA Controller", "--port=13", "--device=0", "--type=dvddrive", "--medium=emptydrive"],
    ["storageattach", "{{.Name}}", "--storagectl=SATA Controller", "--port=13", "--device=0", "--type=dvddrive", "--medium=none"],
    ["modifyvm", "{{.Name}}", "--boot1", "disk", "--boot2", "none"]
  ]

  // Shutdown settings
  acpi_shutdown       = var.common_acpi_shutdown
  shutdown_command    = var.common_acpi_shutdown ? "" : "echo '${var.build_password}' | sudo -S shutdown -P now"
  shutdown_timeout    = var.common_shutdown_timeout

  // Communicator settings
  communicator         = var.communicator
  ssh_port             = var.communicator_port
  ssh_timeout          = var.communicator_timeout
  ssh_username         = var.build_username
  ssh_private_key_file = var.build_private_key_file

  // Run settings
  headless         = var.common_headless
  output_directory = "${var.common_output_base_path}/${local.build_vm_name}"

  // Oracle VirtualBox settings
  virtualbox_version_file = var.communicator == "none" ? "" : ".vbox_version"
  guest_additions_mode    = "disable"

}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {

  sources = ["source.virtualbox-iso.linux-fedora-coreos"]

  provisioner "shell" {
    expect_disconnect = true
    inline = [
      "echo 'Applying latest updates...'",
      "sudo rpm-ostree upgrade | grep -v -e '^Upgraded:$' -e '\\s\\+->\\s\\+'",
      "sudo systemctl reboot"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Verifying updates...'",
      "if sudo rpm-ostree status; then",
      "  echo 'Update completed successfully.';",
      "else",
      "  echo 'Update verification failed'; exit 1;",
      "fi"
    ]
  }

  post-processor "shell-local" {
    inline = [
      "rm -f ${var.build_private_key_file}"
    ]
  }

  post-processor "vagrant" {
    compression_level = 9
    output            = "${var.common_output_base_path}/${local.build_vm_name}/${local.build_vm_name}.box"
  }

  post-processor "manifest" {
    output     = local.manifest_output
    strip_path = true
    strip_time = false
    custom_data = {
      build_description   = local.build_description
      build_datetime      = local.manifest_datetime
      build_username      = var.build_username
      iso_file            = local.build_iso_file
      data_source_command = local.data_source_command
      vm_cpu_count        = var.vm_cpu_count
      vm_disk_size        = var.vm_disk_size
      vm_mem_size         = var.vm_mem_size
      vm_guest_os_type    = var.vm_guest_os_type
    }
  }

}
