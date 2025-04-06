# Packer templates for VirtualBox

## Introduction

This repository automates the creation of reproducable and consistent virtual machine images for [Oracle VirtualBox][virtualbox] using [HashiCorp Packer][packer] and the [Packer Plugin for VirtualBox][packer-plugin-virtualbox] (and its `virtualbox-iso` [builder][packer-plugin-builder-virtualbox-iso]).

All Packer configuration is provided in the [HashiCorp Configuration Language][hcl] ("HCL").

## Linux Distributions

This project supports the following guest operating systems:

| Operating System             | Version   |
| :---                         | :---      |
| [Fedora CoreOS][coreos]      |  Based on streams submodule |

## Documentation

Please refer to the [documentation][documentation] for more detailed information about this project and how to get started.

## Contributing

Contributions are very welcome.

For more detailed information on contributing refer to the [contribution guidelines][contributing] to get started.

## License

See the [LICENSE][license] file for this project's licensing.

[//]: Links
[virtualbox]: https://www.virtualbox.org
[packer]: https://www.packer.io
[packer-plugin-virtualbox]: https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox
[packer-plugin-builder-virtualbox-iso]: https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox/latest/components/builder/iso
[hcl]: https://github.com/hashicorp/hcl
[coreos]: https://fedoraproject.org/coreos/
[contributing]: CONTRIBUTING.md
[documentation]: docs/index.md
[license]: LICENSE
