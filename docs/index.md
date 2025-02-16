# Packer templates for VitualBox

## Introduction

This repository automates the creation of reproducable and consistent virtual machine images for [Oracle VirtualBox][virtualbox] using [HashiCorp Packer][packer] and the [Packer Plugin for VirtualBox][packer-plugin-virtualbox] (and its `virtualbox-iso` [builder][packer-plugin-builder-virtualbox-iso]).

All Packer configuration is provided in the [HashiCorp Configuration Language][hcl] ("HCL").

## Linux Distributions

This project supports the following guest operating systems:

| Operating System             | Version   |
| :---                         | :---      |
| [Fedora CoreOS][coreos]      | Based on streams submodule |

## Getting started

Go through the sections below:

1. [Directory structure][directory_structure]
2. [Requirements][requirements]
3. [Transform][transform] (for Fedora CoreOS only) 
4. [Config][config]
5. [Build][build]

[//]: Links
[virtualbox]: https://www.virtualbox.org
[packer]: https://www.packer.io
[packer-plugin-virtualbox]: https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox
[packer-plugin-builder-virtualbox-iso]: https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox/latest/components/builder/iso
[hcl]: https://github.com/hashicorp/hcl
[coreos]: https://fedoraproject.org/coreos/
[directory_structure]: getting-started/directory_structure.md
[requirements]: getting-started/requirements.md
[transform]: getting-started/transform.md
[config]: getting-started/config.md
[build]: getting-started/build.md
