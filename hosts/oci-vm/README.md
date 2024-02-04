# Oracle Cloud Infrastructure (OCI) Virtual Machine (VM)

This is an installation guide for NixOS on an [Oracle Cloud Infrastructure (OCI)][1] Virtual Machine (VM).

## Installation

### Prerequisites

### Installing NixOS

SSH into the VM using the SSH key downloaded from the OCI console:

```bash
ssh -i ssh-key-yyyy-mm-dd.key ubuntu@<public-ip>
```

Allow `root` to SSH into the VM:

```bash
sudo su
nano ~/.ssh/authorized_keys
```

[1]: https://www.oracle.com/cloud/