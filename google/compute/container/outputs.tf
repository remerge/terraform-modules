output "instance" {
  value = module.compute.instance
}

output "interface" {
  value = module.compute.instance.network_interface[0]
}
