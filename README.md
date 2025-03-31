# ☁️ Terraform module for Spacelift on Azure

This module creates a base infrastructure for a self-hosted Spacelift instance on Azure.

## State storage

Check out the [Terraform](https://developer.hashicorp.com/terraform/language/backend) or
the [OpenTofu](https://opentofu.org/docs/language/settings/backends/configuration/) backend documentation for more
information on how to configure the state storage.

> ⚠️ Do **not** import the state into Spacelift after the installation: that would cause circular dependencies, and in
> case you accidentally break the Spacelift installation, you wouldn't be able to fix it.

## ✨ Usage

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=main"

  app_domain          = "spacelift.mycompany.com"
  location            = "polandcentral"
  resource_group_name = "testgrouptocreate"
  subscription_id     = "00000000-0000-0000-0000-000000000000"
}
```

The module creates:

- Network resources
    - a virtual network for the infrastructure
    - a subnetwork for the AKS cluster
- Container repositories
    - Azure Container registries for storing Docker images
- Database resources
    - a Postgres Flexible Server instance
- Storage resources
    - various containers for storing run metadata, run logs, workspaces, stack states etc.
- AKS cluster
    - a Kubernetes auto-scaled cluster to install Spacelift on

## Module registries

The module is also available [on the OpenTofu registry](https://search.opentofu.org/module/spacelift-io/spacelift-selfhosted/azure/latest) where you can browse the input and output variables.

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the
version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull
request. Once the pull request is merged, the workflow will create a new release.