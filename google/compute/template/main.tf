data "google_compute_default_service_account" "default" {
  count   = var.service_account == null ? 1 : 0
  project = var.project
}

locals {
  service_account = coalesce(var.service_account, try(data.google_compute_default_service_account.default[0].email, null))
}

resource "google_compute_instance_template" "default" {
  project = var.project
  name    = "default"

  machine_type = "n2d-standard-2"

  metadata = {
    # we use okta advanced server access exclusively
    block-project-ssh-keys = true
    # enable serial port for troubleshooting issues
    serial-port-enable = true
    # setup okta server access during instance startup
    startup-script = <<-EOT
    set -ex

    metadata() {
        curl -s -H "Metadata-Flavor: Google" \
            "http://metadata.google.internal/computeMetadata/v1/instance/$${1}"
    }

    if [[ ! -e /var/lib/sftd/device.token ]]; then
        mkdir -p /var/lib/sftd
        gcloud secrets versions access latest \
            --secret=okta-enrollment-token \
            >/var/lib/sftd/enrollment.token
        chmod 0600 /var/lib/sftd/enrollment.token
    fi

    if [[ ! -e /etc/sft/sftd.yaml ]]; then
        mkdir -p /etc/sft
        cat >/etc/sft/sftd.yaml <<EOF
    ---
    EnrollmentTokenFile: /var/lib/sftd/enrollment.token
    AccessAddress: "$(metadata network-interfaces/0/ip)"
    CanonicalName: "$(metadata hostname)"
    EOF
    fi

    if [[ ! -e /etc/yum.repos.d/scaleft_yum.repo ]]; then
        dnf config-manager --add-repo https://pkg.scaleft.com/scaleft_yum.repo
    fi

    if [[ ! -e /usr/sbin/sftd ]]; then
        update-crypto-policies --set LEGACY
        dnf install -y scaleft-server-tools
    fi

    systemctl enable --now sftd
    EOT
  }

  disk {
    boot         = true
    device_name  = "boot"
    disk_type    = "pd-ssd"
    source_image = "almalinux-cloud/almalinux-9"
  }

  network_interface {
    subnetwork = var.subnetwork
    # shared vpc provides subnetwork
    subnetwork_project = var.subnetwork_project
  }

  service_account {
    email  = local.service_account
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
    # secure boot conflicts with ZFS kernel modules
    enable_secure_boot = false
  }
}

resource "google_project_iam_member" "compute_metric_writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.service_account}"
}
