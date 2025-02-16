{
  "ignition": {
    "version": "3.5.0"
  },
  "passwd": {
    "users": [
      {
        "groups": [
          "wheel",
          "sudo",
          "systemd-journal",
          "docker"
        ],
        "name": "${build_username}",
        "passwordHash": "${build_password_encrypted}",
        "sshAuthorizedKeys": [
          "${build_public_key}",
          "${build_public_key_additional}"
        ],
        "system": ${build_system_user}
      }
    ]
  },
  "storage": {
    "files": [
      {
        "group": {
          "id": 0
        },
        "path": "/etc/fstab",
        "user": {
          "id": 0
        },
        "contents": {
          "compression": "",
          "source": "data:,"
        },
        "mode": 272
      },
      {
        "group": {
          "id": 0
        },
        "path": "/etc/sysctl.d/60-kernel-hardening.conf",
        "user": {
          "id": 0
        },
        "contents": {
          "compression": "",
          "source": "data:,kernel.kptr_restrict%20%3D%201"
        },
        "mode": 420
      },
      {
        "group": {
          "id": 0
        },
        "path": "/etc/sysctl.d/70-magic-sysrq.conf",
        "user": {
          "id": 0
        },
        "contents": {
          "compression": "",
          "source": "data:,kernel.sysrq%20%3D%200"
        },
        "mode": 420
      },
      {
        "group": {
          "id": 0
        },
        "path": "/etc/sysctl.d/80-console-messages.conf",
        "user": {
          "id": 0
        },
        "contents": {
          "compression": "",
          "source": "data:,kernel.printk%20%3D%204%204%201%207"
        },
        "mode": 420
      },
      {
        "group": {
          "id": 0
        },
        "path": "/etc/zincati/config.d/51-rollout_wariness.toml",
        "user": {
          "id": 0
        },
        "contents": {
          "compression": "",
          "source": "data:,%5Bidentity%5D%0Arollout_wariness%20%3D%200.5%0A"
        },
        "mode": 420
      },
      {
        "group": {
          "id": 0
        },
        "path": "/etc/zincati/config.d/55-updates-strategy.toml",
        "user": {
          "id": 0
        },
        "contents": {
          "compression": "",
          "source": "data:;base64,W3VwZGF0ZXNdCnN0cmF0ZWd5ID0gInBlcmlvZGljIgoKW3VwZGF0ZXMucGVyaW9kaWNdCmludGVydmFsID0gIjI0aCIK"
        },
        "mode": 420
      }
    ]
  }
}
