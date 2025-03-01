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

### Inputs

| Name                  | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Default        | Required |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|----------|
| location              | The location in which the resources will be created.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | string                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | -              | yes      |
| resource_group_name   | The resource group name that will used for the created resources.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | string                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | -              | yes      | 
| app_domain            | The domain under which the Spacelift instance will be hosted. This is used for the CORS rules of one of the buckets.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | string                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | -              | yes      |
| k8s_namespace         | The namespace in which the Spacelift backend service will be deployed.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | string                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | spacelift      | no       |
| k8s_default_node_pool | {<br/>    name : "The name of the default k8s node pool"<br/>    temporary\_name\_for\_rotation : "Specifies the name of the temporary node pool used to cycle the default node pool for VM resizing"<br/>    min\_count : "The minimum number of nodes which should exist in this Node Pool"<br/>    max\_count : "The maximum number of nodes which should exist in this Node Pool"<br/>    max\_pods: "The maximum number of pods that can run on each node"<br/>    vm\_size : "The size of the Virtual Machine"<br/>   upgrade\_settings\_max\_surge : "The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade"<br/>} | <pre>object({<br/>    name                        = optional(string, "default")<br/>    temporary_name_for_rotation = optional(string)<br/>    min_count                   = optional(number, 1)<br/>    max_count                   = optional(number, 3)<br/>    max_pods                    = optional(number)<br/>    vm_size                     = optional(string, "Standard_A2_v2")<br/>    upgrade_settings_max_surge  = optional(string, "10")<br/>  })</pre> | {}             | no       |
| db_sku_name           | The SKU name of the postgres flexible server.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | string                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | B_Standard_B2s | no       |

### Outputs

| Name                            | Description                                                                                               |
|---------------------------------|-----------------------------------------------------------------------------------------------------------|
| location                        | The location the Spacelift infrastructure is deployed in                                                  |
| resource_group_name             | The resource group the Spacelift infrastructure is deployed in                                            |
| virtual_network_id              | ID of the virtual network that is used to deploy Spacelift                                                |
| subnet_id                       | ID of the subnet that is used for the Spacelift AKS cluster                                               |
| aks_cluster_name                | Name of the AKS cluster.                                                                                  |
| aks_public_v4_address           | Public IPv4 address of the GKE cluster.                                                                   |
| public_container_registry_name  | Name of the public container registry.                                                                    |
| private_container_registry_name | Name of the private container registry.                                                                   |
| db_root_password                | The database root password.                                                                               |
| db_name                         | The name of the postgres server                                                                           |
| large_queue_messages_bucket     | Name of the bucket used for storing large queue messages.                                                 |
| metadata_bucket                 | Name of the bucket used for storing run metadata.                                                         |
| modules_bucket                  | Name of the bucket used for storing Spacelift modules.                                                    |
| policy_inputs_bucket            | Name of the bucket used for storing policy inputs.                                                        |
| run_logs_bucket                 | Name of the bucket used for storing run logs.                                                             |
| states_bucket                   | Name of the bucket used for storing stack states.                                                         |
| uploads_bucket                  | Name of the bucket used for storing user uploads.                                                         |
| user_uploaded_workspaces_bucket | Name of the bucket used for storing user uploaded workspaces. This is used for the local preview feature. |
| workspace_bucket                | Name of the bucket used for storing stack workspace data.                                                 |
| deliveries_bucket               | Name of the bucket used for storing audit trail delivery data.                                            |
| shell                           | A list of shell variables to export to continue with the install process.                                 |

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the
version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull
request. Once the pull request is merged, the workflow will create a new release.