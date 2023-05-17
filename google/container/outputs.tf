output "instance" {
  value = module.vm.instance
}

output "interface" {
  value = module.vm.instance.network_interface[0]
}
