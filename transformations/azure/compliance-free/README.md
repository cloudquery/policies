# CloudQuery &times; dbt: Azure Compliance Package (Free)

## Overview

Welcome to Azure Compliance Package (Free), a compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various Azure services, following benchmarks such as CIS and HIPPA.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by CIS and HIPPA.

This package is a free version of the more comprehensive [Azure Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/azure-compliance-premium/latest/docs)

### Examples

How many checks did I fail in the CIS 2.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM azure_compliance__cis_v2_0_0_free
WHERE status = 'fail'
```

Which resource failed the most tests in the HIPPA HITRUST benchmark? (PostgreSQL)
```sql
SELECT resource_id, count(*) as failed_count
FROM azure_compliance__hipaa_hitrust_v9_2_free
WHERE status = 'fail'
GROUP BY resource_id
ORDER BY count(*) DESC
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

10% of the Automated compliance checks following CIS and HIPPA availble in the [Azure Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/azure-compliance-premium/latest/docs)

## To run this package you need to complete the following steps

### Setting up the DBT profile
First, [install `dbt`](https://docs.getdbt.com/docs/core/installation-overview):
```bash
pip install dbt-postgres
```

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
      dbname: postgres
      schema: public # default schema where dbt will build the models
      threads: 1 # number of threads to use when running in parallel
```

Test the Connection:

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly:

```bash
dbt debug
```

This command will tell you if dbt can successfully connect to your PostgreSQL instance.

### Login to CloudQuery
Because this policy uses premium features and tables you must login to your cloudquery account using
`cloudquery login` in your terminal

### Syncing Azure data
Based on the models you are interested in running you need to sync the relevant tables
this is an example sync for the relevant tables for all the models (views) in the policy and with a postgres destination, this package also supports snowflake.



 ```yml
kind: source
spec:
  name: azure # The source type, in this case, Azure.
  path: cloudquery/azure # The plugin path for handling Azure sources.
  registry: cloudquery # The registry from which the Azure plugin is sourced.
  version: "12.1.2" # The version of the Azure plugin.
  tables: ["azure_security_assessments","azure_network_interfaces","azure_network_virtual_networks","azure_cosmos_database_accounts","azure_eventhub_namespace_network_rule_sets","azure_network_security_groups","azure_keyvault_keyvault","azure_eventhub_namespaces","azure_authorization_role_definitions","azure_security_jit_network_access_policies","azure_compute_virtual_machines","azure_security_pricings"]
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  spec:

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v7.3.5" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"

 ```

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your snowflake connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

To select a specific model and the dependencies in the dependency graph:

```bash
dbt run --select +<model_name>
```

For a specific model and the dependencies in the dependency graph:

```bash
dbt run --models +<model_name>
```

#### Models

- **azure_compliance\_\_cis_v1_3_0.sql**: Azure Compliance CIS V1.3.0, available for PostgreSQL and Snowflake.
- **azure_compliance\_\_cis_v2_0_0.sql**: Azure Compliance CIS V2.0.0, available for PostgreSQL and Snowflake.
- **azure_compliance\_\_hippa_hitrust_9_2.sql**: Azure Compliance HIPPA HITRUST V9.2, available for PostgreSQL.

The Free version contains 10% of the queries avaiable in the [Azure Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/azure-compliance-premium/latest/docs).

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and number).
- **title**: The name/title of the check.
- **resource_id**: The azure resource id.
- **subscription_id**: The azure subscription id.
- **status**: The status of the check (fail / pass).


### Required tables
- **azure_compliance\_\_cis_v1_3_0.sql**:
```yaml
"azure_authorization_role_definitions",
"azure_security_pricings"
```
- **azure_compliance\_\_cis_v2_0_0.sql**:
```yaml
"azure_authorization_role_definitions",
"azure_security_pricings"
```
- **azure_compliance\_\_hippa_hitrust_9_2.sql**:
```yaml
"azure_security_assessments",
"azure_network_virtual_networks",
"azure_cosmos_database_accounts",
"azure_keyvault_keyvault",
"azure_eventhub_namespaces",
"azure_network_interfaces",
"azure_compute_virtual_machines",
"azure_eventhub_namespace_network_rule_sets",
"azure_network_security_groups",
"azure_security_jit_network_access_policies"
```
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