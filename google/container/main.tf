module "vm" {
  source = "../vm"

  name    = var.name
  project = var.project
  zone    = var.zone

  template     = var.template
  machine_type = var.machine_type
  volumes      = var.volumes

  # Container Optimized OS
  disk_image = "cos-cloud/cos-stable"

  metadata = {
    # no need to login to this container vm
    block-project-ssh-keys = true
    # enable logging for container vm
    google-logging-enabled = "true"
    # enable monitoring for container vm
    google-monitoring-enabled = "true"
    # run tfc-agent container automatically
    gce-container-declaration = yamlencode({
      spec = {
        containers = [{
          name  = var.name
          image = var.image
          stdin = false
          tty   = false
          env = [for name, value in var.env : {
            name  = name
            value = value
          }]
          volumeMounts = [for name, value in var.volumes : {
            name      = name
            mountPath = value.path
          }]
        }]
        volumes = [for name, value in var.volumes : {
          name = name
          gcePersistentDisk = {
            pdName = name
            fsType = "ext4"
          }
        }]
        restartPolicy = "Always"
      }
    })
  }
}
