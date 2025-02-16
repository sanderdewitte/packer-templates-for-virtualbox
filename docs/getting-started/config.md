# Configuration

## Sample variables

The project includes sample variables files that you can use as a starting point.

The [variables][packer-variables] are defined in `.pkrvars.hcl` files.

Run the config script `./config.sh` to copy the `.pkrvars.hcl.sample` files to a `config` directory.
Typically it is followed by running the build script as indicated in the examples below,
however more on the `build.sh` script you will find in the [Build][build] documentation.

```shell
./config.sh
./build.sh
```

The `config` folder is the default folder and will be created if it does not exist.

You can override the default by passing an alternate value as the first argument.

For example:

Custom configuration 1: `custom_config_1`

```shell
./config.sh custom_config_1
./build.sh custom_config_1
```

Custom configuration 2: `custom_config_2`

```shell
./config.sh custom_config_2
./build.sh custom_config_2
```

This is useful for the purposes of running machine image builds for different environments.

## Configuration variables

### Build Packer variables

Edit the `config/build.pkrvars.hcl` file to configure the credentials for the default account on
machine images.

```hcl title="config/build.pkrvars.hcl"
build_username           = "example"
build_password           = "<plaintext_password>"
build_password_encrypted = "<sha512_encrypted_password>"
build_key                = "<public_key>"
```

You can also override the `build_key` value with contents of a file.

```hcl title="config/build.pkrvars.hcl"
build_key = file("${path.root}/config/ssh/build_id_ecdsa.pub")
```

Generate a SHA-512 encrypted password for the `build_password_encrypted` using tools like mkpasswd.

=== &nbsp; Ubuntu

Run the following command to generate a SHA-512 encrypted password for the
`build_password_encrypted` using mkpasswd.

```shell
mkpasswd -m sha512crypt
```

The following output is displayed:

```shell
Password: ***************
<password hash>
```

Or, alternatively, using python.

```shell
 python -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'
```

The following output is displayed:

```shell
Password: ***************
Confirm: ***************
<password hash>
```

=== &nbsp; macOS

Run the following command to generate a SHA-512 encrypted password for the
`build_password_encrypted` using mkpasswd.

```shell
docker run -it --rm alpine:latest
mkpasswd -m sha512
```

The following output is displayed:

```shell
Password: ***************
<password hash>
```

Generate a public key for the `build_key` for public key authentication.

=== &nbsp; Ubuntu

Run the following command to generate a public key for the `build_key` for public key
authentication.

```shell
ssh-keygen -t ecdsa -b 521 -C "<name@example.com>"
```

The following output is displayed:

```shell
Generating public/private ecdsa key pair.
Enter file in which to save the key (/Users/example/.ssh/id_ecdsa):
Enter passphrase (empty for no passphrase): **************
Enter same passphrase again: **************
Your identification has been saved in /Users/example/.ssh/id_ecdsa.
Your public key has been saved in /Users/example/.ssh/id_ecdsa.pub.
```

=== &nbsp; macOS

Run the following command to generate a public key for the `build_key` for public key
authentication.

```shell
ssh-keygen -t ecdsa -b 521 -C "<name@example.com>"
```

The following output is displayed:

```shell
Generating public/private ecdsa key pair.
Enter file in which to save the key (/Users/example/.ssh/id_ecdsa):
Enter passphrase (empty for no passphrase): **************
Enter same passphrase again: **************
Your identification has been saved in /Users/example/.ssh/id_ecdsa.
Your public key has been saved in /Users/example/.ssh/id_ecdsa.pub.
```

The content of the public key, `build_key`, is added the key to the `~/.ssh/authorized_keys` file of
the `build_username` on the Linux guest operating systems.

Note: replace the example public keys and passwords.

### Common Packer variables

Edit the `config/common.pkrvars.hcl` file to configure the following common variables:

- Virtual Machine Settings
- Removable Media and ISO Settings
- Boot and Provisioning Settings
- Build run settings
- OVF Export Settings
- HCP Packer Registry

```hcl title="config/common.pkrvars.hcl"
// Virtual Machine Settings
common_vm_version = 21

// Removable Media and ISO Settings
common_iso_base_path            = "iso"
common_iso_datastore_basic_auth = true
common_iso_datastore_url_scheme = "https"
common_iso_datastore_url        = "artifactory.cosmos.esa.int/artifactory"
common_iso_datastore            = "Internal-OS-ISOs"

// Boot and Provisioning Settings
common_data_source      = "http"
common_http_port_min    = 8000
common_http_port_max    = 8099
common_shutdown_timeout = "10m"

// Run Settings
common_headless = true

// OVF Export Settings
common_ovf_export_enabled = true
common_ovf_export_format  = "ova"

// HCP Packer
common_hcp_packer_registry_enabled = false
```

#### Data source

The default provisioning data source for Linux machine image builds is `http`. This is used to serve
the kickstart files to the Linux guest operating system during the build.

```hcl title="config/common.pkrvars.hcl"
common_data_source = "http"
```

#### IPTables

Packer includes a built-in HTTP server that is used to serve the kickstart files for Linux
machine image builds.

If iptables is enabled on your Packer host, you will need to open `common_http_port_min` through
`common_http_port_max` ports.

```shell
iptables -A INPUT -p tcp --match multiport --dports 8000:8099 -j ACCEPT
```

You can change the `common_data_source` from `http` to `disk` to build supported Linux machine
images without the need to use Packer's HTTP server. This is useful for environments that may not be
able to route back to the system from which Packer is running.

```hcl title="config/common.pkrvars.hcl"
common_data_source = "disk"
```

The Packer plugin's `cd_content` option is used when selecting `disk` unless the distribution does
not support a secondary CD-ROM. For distributions that do not support a secondary CD-ROM the
`floppy_content` option is used.

#### HTTP binding

If you need to define a specific IPv4 address from your host for Packer's built-in HTTP server,
modify the `common_http_ip` variable from `null` to a `string` value that matches an IP address on
your Packer host.

```hcl title="config/common.pkrvars.hcl"
common_http_ip = "<IP_ADDRESS>"
```

### Proxy Packer variables

Edit the `config/proxy.pkrvars.hcl` file to configure the following:

- SOCKS proxy settings used for connecting to Linux machine images.
- Credentials for the proxy server.

```hcl title="config/proxy.pkrvars.hcl"
communicator_proxy_host     = "proxy.example.com"
communicator_proxy_port     = 8080
communicator_proxy_username = "example"
communicator_proxy_password = "<plaintext_password>"
```

### Versioned VM images Packer variables

Edit the `config/<type>-<build>-<version>.pkrvars.hcl` files to configure the following virtual
machine hardware settings, as required:

- CPUs `(int)`
- CPU Cores `(int)`
- Memory in MB `(int)`
- Primary Disk in MB `(int)`
- .iso Path `(string)`
- .iso File `(string)`

```hcl title="config/linux-rhel.pkrvars.hcl"
// Guest Operating System Metadata
vm_guest_os_language = "en_US"
vm_guest_os_keyboard = "us"
vm_guest_os_timezone = "UTC"
vm_guest_os_family   = "linux"
vm_guest_os_name     = "rhel"
vm_guest_os_version  = "9.3"

// Virtual Machine Guest Operating System Setting
vm_guest_os_type = "rhel9_64Guest"

// Virtual Machine Hardware Settings
vm_firmware              = "efi-secure"
vm_cdrom_type            = "sata"
vm_cdrom_count           = 1
vm_cpu_count             = 2
vm_cpu_cores             = 1
vm_cpu_hot_add           = false
vm_mem_size              = 2048
vm_mem_hot_add           = false
vm_disk_size             = 40960
vm_disk_controller_type  = ["pvscsi"]
vm_disk_thin_provisioned = true
vm_network_card          = "vmxnet3"

// Removable Media Settings
iso_datastore_path       = "iso/linux/rhel"
iso_content_library_item = "rhel-9.3-x86_64-dvd"
iso_file                 = "rhel-9.3-x86_64-dvd.iso"

// Boot Settings
vm_boot_order = "disk,cdrom"
vm_boot_wait  = "2s"

// Communicator Settings
communicator_port    = 22
communicator_timeout = "30m"
```

Note: all `variables.pkrvars.hcl` default to using:

- VMware Paravirtual SCSI controller storage device
- VMXNET 3 network card device
- EFI Secure Boot firmware

### Linux Packer variables

#### Additional packages

Edit the `config/linux-<build>-<version>.pkrvars.hcl` file to configure the additional packages to
be installed on the Linux guest operating system during the build.

```hcl title="config/linux-rhel.pkrvars.hcl"
// Additional Settings
additional_packages = ["git", "make", "vim"]
```

#### Red Hat subscription manager

Edit the `config/redhat.pkrvars.hcl` file to configure the credentials for your Red Hat Subscription
Manager account.

```hcl title="config/redhat.pkrvars.hcl"
rhsm_username = "example"
rhsm_password = "<plaintext_password>"
```

These variables are **only** used if you are performing a Red Hat Enterprise Linux Server build and
are used to register the image with Red Hat Subscription Manager during the build for system updates
and package installation.

Before the build completes, the machine image is unregistered from Red Hat Subscription Manager.

#### Network customization

Note:
Static IP assignment is available for certain Linux machine images.
For details on which distributions are compatible, please refer to the [Linux Distributions]
table.

Edit the `config/network.pkrvars.hcl` file to configure a static IP address:

- IPv4 address, netmask, and gateway.
- DNS list.

By default, the network is set to use DHCP for its configuration.

```hcl title="config/network.pkrvars.hcl"
vm_ip_address = "172.16.100.192"
vm_ip_netmask = 24
vm_ip_gateway = "172.16.100.1"
vm_dns_list   = [ "172.16.11.4", "172.16.11.5" ]
```

#### Storage customization

Note:
Storage settings are available for certain Linux machine images.
For details on which distributions are compatible, please refer to the [Linux Distributions]
table.

Edit the `config/linux-storage.pkrvars.hcl` file to configure a partitioning scheme:

- Disk device and whether to use a swap partition.
- Disk partitions and related settings.
- Logical volumes and related settings (optional).

```hcl title="config/linux-storage.pkrvars.hcl"
vm_disk_device = "sda"
vm_disk_use_swap = false
vm_disk_partitions = [
  {
    name = "efi"
    size = 1024,
    format = {
      label  = "EFIFS",
      fstype = "fat32",
    },
    mount = {
      path    = "/boot/efi",
      options = "",
    },
    volume_group = "",
  },
  {
    name = "boot"
    size = 1024,
    format = {
      label  = "BOOTFS",
      fstype = "xfs",
    },
    mount = {
      path    = "/boot",
      options = "",
    },
    volume_group = "",
  },
  {
    name = "root"
    size = -1,
    format = {
      label  = "ROOTFS",
      fstype = "xfs",
    },
    mount = {
      path    = "/",
      options = "",
    },
    volume_group = "",
  },
]
vm_disk_lvm = []
```

Note:
Setting `size = -1` can also be used for the last partition (Logical Volume) of `vm_disk_lvm` so
that it fills the remaining space of the Volume Group.

[//]: Links
[packer-variables]: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/variables
[build]: build.md
[Linux Distributions]: ../index.md#linux-distributions
