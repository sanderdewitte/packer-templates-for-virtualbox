# Directory structure

The directory structure of this project. Hidden directories are not listed (intentionally).

```shell
.
├── build.sh
├── config.sh
├── CONTRIBUTING.md
├── download.sh
├── LICENSE
├── README.md
├── set-envvars.sh
├── artifacts
├── builds
│   ├── build.pkrvars.hcl.sample
│   ├── common.pkrvars.hcl.sample
│   ├── linux-storage.pkrvars.hcl.sample
│   ├── network.pkrvars.hcl.sample
│   ├── proxy.pkrvars.hcl.sample
│   └── linux
│       └── <distribution>
│           └── <version>
│               ├── *.pkr.hcl
│               ├── *.pkrvars.hcl.sample
│               └── data
│                   ├── ks.pkrtpl.hcl
│                   ├── network.pkrtpl.hcl
│                   └── storage.pkrtpl.hcl
├── docs
│   ├── index.md
│   └── getting-started
│       ├── build.md
│       ├── config.md
│       ├── directory_structure.md
│       ├── download.md
│       ├── privileges.md
│       └── requirements.md
├── http
├── iso
├── manifests
└── scripts
    └── linux
        ├── common
        └── <distribution>
```

The following table describes the directory structure.

| Directory       | Description                                                                                                                                         |
| :---            | :---                                                                                                                                                |
| **`artifacts`** | OVF artifacts exported by the builds, if enabled.                                                                                                   |
| **`builds`**    | Packer templates, variables, and configuration files for the machine image builds.                                                                  |
| **`docs`**      | Project documents in Markdown format.                                                                                                               |
| **`http`**      | Directory to serve by Packer HTTP server. The files in this directory, created during builds, will be available over HTTP from the virtual machine. |
| **`iso`**       | Directory to store downloaded guest operating system ISO files during builds (by downloads.sh script).                                              |
| **`manifests`** | Manifests created after the completion of the machine image builds, if enabled.                                                                     |
| **`scripts`**   | Scripts to initialize and prepare image builds.                                                                                                     |
