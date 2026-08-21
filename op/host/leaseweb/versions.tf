terraform {
  required_providers {
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source = "1Password/onepassword"
    }
    # Remerge fork of https://registry.terraform.io/providers/LeaseWeb/leaseweb
    # published to the HCP Terraform private registry: tolerates the broken
    # DHCP leases endpoint (503) on private rack servers.
    # https://github.com/remerge/terraform-provider-leaseweb
    leaseweb = {
      source = "app.terraform.io/remerge/leaseweb"
    }
  }
}
