# Build

## Build script options

If you need help for script options, pass the `--help` or `-h` flag to the build script to display
the help for the build script.

```shell
./build.sh --help
```

If you need to enable debugging, pass the `--debug` or `-d` flag to the build script to enable debug
mode for Packer.

This example will look for the configuration files in the `config` directory and enable debug mode
for Packer.

```shell
./build.sh --debug
```

This example will look for the configuration files in the `custom_config` directory and enable debug
mode for Packer.

```shell
./build.sh --debug custom_config
```

## Using the build script

### Build with defaults

Start a build by running the build script (`./build.sh`). The script presents a menu the which
simply calls Packer and the respective build(s).

This example will look for the configuration files in the `config` directory.

```shell
./build.sh
```

### Build a specific configuration

This example will look for the configuration files in the `custom_config` directory.

```shell
./build.sh custom_config
```

## Build directly with Packer

You can also start a build based on a specific source for some of the virtual machine images.

For example, if you simply want to build a Red Hat Enterprise Linux 9, run the
following:

Initialize the plugins:

```shell
packer init builds/linux/rhel/9/.
```

Build a specific machine image:

```shell
packer build \
  -force on-error=ask \
  -only vsphere-iso.linux-rhel \
  -var-file="config/build.pkrvars.hcl" \
  -var-file="config/common.pkrvars.hcl" \
  -var-file="config/vsphere.pkrvars.hcl" \
  builds/linux/rhel/9
```

```shell
packer validate \
  -var-file="config/build.pkrvars.hcl" \
  -var-file="config/common.pkrvars.hcl" \
  -var-file="config/proxy.pkrvars.hcl" \
  -var-file="config/vsphere.pkrvars.hcl" \
  builds/linux/rhel/9
```

## Build with environmental variables

You can set your environment variables if you would prefer not to save sensitive information in
clear-text in files.

You can add these to environmental variables using the `set-envvars.sh` script.

```shell
. ./set-envvars.sh
```

Note: you must run the script by sourcing it or use the shorthand "`.`".
