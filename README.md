# ☁️ Terraform module for Spacelift on Azure

> [!IMPORTANT]
> ## Upgrading to v4.0.0 - azurerm provider 5.x
>
> The module now requires the `azurerm` provider `~>5.0`. **Bump the `azurerm`
> version constraint in your root module** and run `tofu init -upgrade`. Other
> `azurerm` resources in your configuration may need changes too - see the
> [5.0 upgrade guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/5.0-upgrade-guide).
>
> Expect one in-place change in the plan: `allow_nested_items_to_be_public` on the
> storage account goes to `false`, the new provider default. All containers are
> private already, so nothing changes for Spacelift.
>
> azurerm 5.x no longer registers Azure Resource Providers by default. On a fresh
> subscription, set `resource_provider_registrations = "legacy"` in your
> `provider "azurerm"` block, or register the providers yourself.

> [!IMPORTANT]
> ## Upgrading to v3.0.0 - standalone scheduler removed
>
> The cron scheduler runs inside the drain, and the `spacelift-self-hosted` Helm
> chart no longer deploys the scheduler Deployment. **Requires Self-Hosted v6.4.0
> or newer**, the first release whose drain always runs the cron scheduler.
> Nothing has to be configured for it - the generated `spacelift-drain` secret
> carries no scheduler key at all.

---

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
  source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=v4.0.0"

  app_domain          = "spacelift.mycompany.com"
  location            = "polandcentral"
  resource_group_name = "spacelift-rg"
  postgres_version    = "17"
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

### With VCS Gateway

To enable the [VCS Gateway](https://docs.spacelift.io/concepts/vcs-agent-pools.html) for connecting remote VCS agents, provide the `vcs_gateway_domain` variable.

See a full example in the [examples/with-vcs-gateway](examples/with-vcs-gateway) directory.

## Module registries

The module is also available [on the OpenTofu registry](https://search.opentofu.org/module/spacelift-io/spacelift-selfhosted/azure/latest) where you can browse the input and output variables.

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the
version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull
request. Once the pull request is merged, the workflow will create a new release.