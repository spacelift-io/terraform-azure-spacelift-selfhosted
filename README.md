# ☁️ Terraform module for Spacelift on Azure

> [!IMPORTANT]
> ## 🔄 Upgrading to v2.0.0 - Breaking changes
>
> Click below to see the full upgrade guide with breaking changes.

<details>
<summary><h3>📋 Full v2.0.0 Upgrade Guide</h3></summary>

### Breaking Changes

#### Mandatory Version Parameter

The following parameter is now **required** and has no default value:

- **`postgres_version`** - The PostgreSQL version for the flexible server (previously hardcoded to `"14"`)

**Why this change?** Hardcoded defaults prevent us from ever updating them without causing unexpected infrastructure changes for existing users. Explicit version specification is simpler and gives you full control.

**Action Required:** You must explicitly set this value in your module configuration:

### Example Migration

```diff
module "spacelift" {
-  source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=v1.0.0"
+  source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=v2.0.0"

  app_domain          = "spacelift.mycompany.com"
  location            = "polandcentral"
  resource_group_name = "spacelift-rg"

+  postgres_version = "14"  # Now required
}
```

> [!WARNING]
> **Major PostgreSQL version upgrades** are offline operations that cause downtime (typically under 15 minutes, depending on database size). See the [Azure documentation](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-major-version-upgrade) for full details.

</details>

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
  source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=v2.0.0"

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