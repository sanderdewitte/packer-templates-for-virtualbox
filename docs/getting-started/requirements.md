# Requirements

## VirtualBox

The project is tested/deployed on the following platforms:

### Deployments

| Platform                           | Version       |
| :---                               | :---          |
| &nbsp;&nbsp; VirtualBox            | 7.1 or later |

## Packer

The project is tested/built on the following platforms:

### Building

| Platform                    | Version        |
| :---                        | :---           |
| &nbsp;&nbsp; Ubuntu Desktop | 22.04 or later |

### Packer CLI

HashiCorp [Packer][packer-install] - 1.11 or later.

### Plugins

Required plugins are automatically downloaded and initialized when using `./build.sh`.

For disconnected sites (_e.g._, air-gapped or dark sites), you may download the plugins and place
these in same directory as your Packer executable `/usr/local/bin` or `$HOME/.packer.d/plugins`.

| Plugin                                 | Version  | Description      | Resources                                                                                                               |
| :---                                   | :---     | :---             | :---                                                                                                                    |
| &nbsp;&nbsp; Packer Plugin for VMware  | >= 1.2.7 | By HashiCorp     | [Repo][packer-plugin-virtualbox-repo]  &nbsp;&nbsp; [Docs][packer-plugin-virtualbox-docs]  |
| &nbsp;&nbsp; Packer Plugin for Git     | >= 0.6.2 | Community Plugin | [Repo][packer-plugin-git-repo]     &nbsp;&nbsp; [Docs][packer-plugin-git-docs]     |

## Additional software packages

The following additional software packages must be installed on the operating system running Packer.

- [git][download-git] - Git command-line tools.
- [jq][jq] - A command-line JSON processor - 1.6 or later.

Required based on options:

- One of the following command-line ISO creators. Required only when the dynamically generated Kickstart file is provided from (virtual) cdrom instead of from Packer provided HTTP server (i.e. when `common_data_source` is set to `disk` instead of `http`).
  - [xorriso][gnu-xorriso] - Linux.
  - [oscdimg][adk-install] - Windows.
  - [hdiutil][hdi-util] - MacOS.

Optionally:

- [mkpasswd][man-mkpasswd] - A password generating utility.

[//]: Links
[packer-install]: https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli
[packer-plugin-virtualbox-repo]: https://github.com/hashicorp/packer-plugin-virtualbox
[packer-plugin-virtualbox-docs]: https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox
[packer-plugin-git-repo]: https://github.com/ethanmdavidson/packer-plugin-git
[packer-plugin-git-docs]: https://developer.hashicorp.com/packer/integrations/ethanmdavidson/git
[download-git]: https://git-scm.com/downloads
[jq]: https://stedolan.github.io/jq/
[gnu-xorriso]: https://www.gnu.org/software/xorriso/
[adk-install]: https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install
[hdi-util]: https://ss64.com/mac/hdiutil.html
[man-mkpasswd]: https://linux.die.net/man/1/mkpasswd
