resource "random_password" "main" {
  length           = 16
  special          = true
  override_special = "@,.^%-_~"
}

resource "leaseweb_dedicated_server_installation" "main" {
  dedicated_server_id = var.server_id
  operating_system_id = "ALMALINUX_9_64BIT"

  hostname = var.hostname
  password = random_password.main.result
  timezone = "UTC"

  post_install_script = <<-EOT
#!/bin/bash
set -ex

dnf install -y yum-utils
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf install -y systemd-networkd

mkdir -p /var/lib/sftd
chmod 700 /var/lib/sftd
echo "${var.enrollment_token}" > /var/lib/sftd/enrollment.token
chmod 0600 /var/lib/sftd/enrollment.token

mkdir -p /etc/sft
chmod 700 /etc/sft
cat > /etc/sft/sftd.yaml <<EOF
---
EnrollmentTokenFile: /var/lib/sftd/enrollment.token
AccessAddress: "${var.internal_ip}"
CanonicalName: "${var.hostname}"
EOF

cat > /etc/yum.repos.d/scaleft_yum.repo <<EOF
[scaleft]
async = 1
baseurl = https://dist.scaleft.com/repos/rpm/stable/alma/9/x86_64/
gpgcheck=1
gpgkey = https://dist.scaleft.com/GPG-KEY-OktaPAM-2023
name = ScaleFT
repo_gpgcheck = 1
EOF

dnf makecache -y
update-crypto-policies --set LEGACY
dnf install -y scaleft-server-tools
systemctl enable sftd

cat > /etc/udev/rules.d/10-shared.rules <<EOR
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${lower(var.internal_mac)}", ATTR{addr_assign_type}=="0", NAME="shared"
EOR

mkdir -p /etc/systemd/network
cat > /etc/systemd/network/shared.network <<EOR
[Match]
MACAddress=${var.internal_mac}

[Network]
Address=${var.internal_ip}/16
Gateway=10.32.0.1
DNS=10.164.15.230
EOR

systemctl disable NetworkManager
systemctl enable systemd-networkd

cat > /etc/resolv.conf <<EOR
nameserver 10.164.15.230
EOR

sgdisk -n 4:0:0 -t 4:8300 -c 4:data /dev/sda

reboot
EOT

  raid {
    type            = "HW"
    level           = 1
    number_of_disks = 2
  }

  device = "SATA_SAS"

  partition {
    mountpoint = "/boot"
    filesystem = "ext2"
    size       = 1024
  }

  partition {
    mountpoint = "/"
    filesystem = "ext4"
    size       = 20480
  }

  timeouts {
    create = "30m"
  }

  lifecycle {
    ignore_changes = [
      random_password.main,
      post_install_script,
    ]
    prevent_destroy = true
  }
}
