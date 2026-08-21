terraform {
  required_providers {
    # Remerge fork of https://registry.terraform.io/providers/LeaseWeb/leaseweb
    # published to the HCP Terraform private registry: tolerates the broken
    # DHCP leases endpoint (503) on private rack servers.
    # https://github.com/remerge/terraform-provider-leaseweb
    leaseweb = {
      source = "app.terraform.io/remerge/leaseweb"
    }
  }
}
