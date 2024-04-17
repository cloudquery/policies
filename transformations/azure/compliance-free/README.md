# CloudQuery &times; dbt: Azure Compliance Package

## Overview

This package contains dbt models (views) that gives compliance insights from CloudQuery [Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure) data.

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure)
- [dbt](https://docs.getdbt.com/docs/core/installation)

#### dbt Installation

- [DBT + Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [DBT + Postgres](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- [DBT + BigQuery](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup)

An example of how to install dbt to work with the destination of your choice.

First, install `dbt` for the destination of your choice:

An example installation of dbt-postgres:

```bash
pip install dbt-postgres
```

An example installation of dbt-snowflake:

```bash
pip install dbt-snowflake
```

These commands will also install install dbt-core and any other dependencies.

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
azure_compliance: # This should match the name in your dbt_project.yml
  target: dev
  outputs:
    dev:
      type: postgres
      host: 127.0.0.1
      user: postgres
      pass: pass
      port: 5432
      dbname: azure
      schema: public # default schema where dbt will build the models
      threads: 1 # number of threads to use when running in parallel
```

Test the Connection:

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly:

```bash
dbt debug
```

This command will tell you if dbt can successfully connect to your destination database.

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides.

Before executing the `dbt run` command, it might be useful to check for any potential issues:

```bash
dbt compile
```

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)

### What's in the pack

The pack contains the premium version.

#### Models

- **azure_compliance\_\_cis_v1_3_0.sql**: Azure Compliance CIS V1.3.0, available for PostgreSQL and Snowflake.

The free version contains 10% of the full pack's queries.

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `cis_v1.3.0`

- ✅ `1.21`: `iam_custom_subscription_owner_roles`
- ✅ `2.1`: `security_defender_on_for_servers`
- ✅ `2.2`: `security_defender_on_for_app_service`
- ✅ `2.3`: `security_defender_on_for_sql_servers`
- ✅ `2.4`: `security_defender_on_for_sql_servers_on_machines`
- ✅ `2.5`: `security_defender_on_for_storage`
- ✅ `2.6`: `security_defender_on_for_k8s`
- ✅ `2.7`: `security_defender_on_for_container_registeries`
- ✅ `2.8`: `security_defender_on_for_key_vault`

##### `cis_v2.0.0`

- ✅ `1.23`: `iam_custom_subscription_owner_roles`
- ✅ `2.1.1`: `security_defender_on_for_servers`
- ✅ `2.1.2`: `security_defender_on_for_app_service`
- ✅ `2.1.4`: `security_defender_on_for_sql_servers`
- ✅ `2.1.5`: `security_defender_on_for_sql_servers_on_machines`
- ✅ `2.1.7`: `security_defender_on_for_storage`
- ✅ `2.1.8`: `security_defender_on_for_container_registeries`
- ✅ `2.1.10`: `security_defender_on_for_key_vault`

##### `hipaa_hitrust_v9.2`

- ✅ `0806.01m2Organizational.12356 - 01.m - 3`: `cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 4`: `eventhub_event_hub_should_use_a_virtual_network_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 6`: `compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups`
- ✅ `0806.01m2Organizational.12356 - 01.m - 7`: `keyvault_vaults_with_no_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 10`: `network_subnets_without_nsg_associated`
- ✅ `0806.01m2Organizational.12356 - 01.m - 11`: `compute_vms_without_approved_networks`
- ✅ `1116_01j1organizational_145_01_j`: `security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription`
- ✅ `1117_01j1organizational_23_01_j`: `security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription`
- ✅ `1118_01j2organizational_124_01_j`: `security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription`
- ✅ `1119_01j2organizational_3_01_j`: `compute_virtual_machines_without_jit_network_access_policy`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->