# Terraform Modules

These modules allow you to conveniently provision and manage your cloud
resources on Google Cloud Platform (GCP), manage DNS records, document virtual
machines, and more.

You can use the modules by referencing them directly from our GitHub repository
[remerge/terraform-modules](https://github.com/remerge/terraform-modules) in
your Terraform files. Here's a general example:

```hcl
module "<module_name>" {
  source = "github.com/remerge/terraform-modules//<module_path>"

  // Insert necessary variables here
}
```

Now let's delve into the individual modules:

## consul/dns

This module sets up a DNS forwarding zone for Consul in Google Cloud.

## domain/delegation

This module allows you to create a public DNS zone for a subdomain delegated
from `remerge/domains`.

## google/compute

With this module, you can create an instance on Google Compute Engine from a
template.

## google/compute/container

This module allows you to run a container on Google Compute Engine using
Container OS.

## google/compute/template

With this module, you can create a default Compute Instance template.

## google/kubernetes

This module allows you to create a private Kubernetes cluster on Google Cloud.

## google/redis

This module enables you to create a Redis instance using Google Cloud
Memorystore.

## google/sql/database

This module allows you to create a database, user, and password for Google Cloud
SQL.

## google/sql/postgresql

With this module, you can create a PostgreSQL instance using Google Cloud SQL.

## netbox/cluster

This module helps you document a cluster in Netbox and create a corresponding
private Google Cloud DNS zone.

## netbox/vm

This module assists you in documenting a virtual machine in Netbox and creating
a corresponding DNS record in Google Cloud DNS.

## nomad/dns

This module allows you to create apex and wildcard DNS records for Nomad
clients.

## okta/pam/project

This module lets you create an enrollment token and group assignments for Okta
Advanced Server Access (ScaleFT).

## sendgrid

With this module, you can create a SendGrid API token for SMTP relay access.
