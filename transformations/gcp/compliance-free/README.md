# CloudQuery &times; dbt: GCP Compliance Package (Free)

## Overview

Welcome to GCP Compliance Package (Free), a compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various GCP services, following benchmarks such as CIS 1.2 and CIS 2.0.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by CIS.

This package is a free version of the more comprehensive [GCP Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/gcp-compliance-premium/latest/docs)

### Examples

How many checks did I fail in the CIS 2.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM gcp_compliance__cis_v2_0_0_free
WHERE status = 'fail'
```

Which resource failed the most tests in the CIS 1.2 benchmark? (PostgreSQL)
```sql
SELECT resource_id, count(*) as failed_count
FROM gcp_compliance__cis_v1_2_0_free
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

10% of the automated compliance checks following CIS 1.2 and 2.0 available in the [GCP Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/gcp-compliance-premium/latest/docs)

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
gcp_compliance: # This should match the name in your dbt_project.yml
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

### Syncing GCP data
Based on the models you are interested in running you need to sync the relevant tables
this is an example sync for the relevant tables for all the models (views) in the policy and with a postgres destination, this package also supports snowflake.


```yml
kind: source
spec:
  name: gcp # The source type, in this case, GCP.
  path: cloudquery/gcp # The plugin path for handling GCP sources.
  registry: cloudquery # The registry from which the GCP plugin is sourced.
  version: "12.3.2" # The version of the GCP plugin.
  tables: ["gcp_resourcemanager_project_policies","gcp_iam_service_accounts","gcp_iam_service_account_keys","gcp_kms_crypto_keys"]
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

- **gcp_compliance\_\_cis_v1_2_0_free.sql**: GCP Compliance CIS V1.3.0, available for PostgreSQL, Snowflake and BigQuery.
- **gcp_compliance\_\_cis_v2_0_0_free.sql**: GCP Compliance CIS V2.0.0, available for PostgreSQL, Snowflake and BigQuery.

The Free version contains 10% of the queries avaiable in the [GCP Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/gcp-compliance-premium/latest/docs).

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and number).
- **title**: The name/title of the check.
- **resource_id**: The gcp resource id.
- **project_id**: The gcp project id.
- **status**: The status of the check (fail / pass).


### Required tables
- **gcp_compliance\_\_cis_v1_2_0_free.sql**:
```yaml
"gcp_iam_service_account_keys",
"gcp_resourcemanager_project_policies",
"gcp_iam_service_accounts",
"gcp_kms_crypto_keys"
```
- **gcp_compliance\_\_cis_v2_0_0.sql**:
```yaml
"gcp_iam_service_account_keys",
"gcp_resourcemanager_project_policies",
"gcp_iam_service_accounts",
"gcp_kms_crypto_keys"
```
<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `cis_v1.2.0`

- ✅ `1.4`: `iam_managed_service_account_keys`
- ✅ `1.5`: `iam_service_account_admin_priv`
- ✅ `1.6`: `iam_users_with_service_account_token_creator_role`
- ✅ `1.7`: `iam_service_account_keys_not_rotated`
- ✅ `1.8`: `iam_separation_of_duties`
- ✅ `1.9`: `kms_publicly_accessible`
- ✅ `1.10`: `kms_keys_not_rotated_within_90_days`
- ✅ `1.11`: `kms_separation_of_duties`

##### `cis_v2.0.0`

- ✅ `1.4`: `iam_managed_service_account_keys`
- ✅ `1.5`: `iam_service_account_admin_priv`
- ✅ `1.6`: `iam_users_with_service_account_token_creator_role`
- ✅ `1.7`: `iam_service_account_keys_not_rotated`
- ✅ `1.8`: `iam_separation_of_duties`
- ✅ `1.9`: `kms_publicly_accessible`
- ✅ `1.10`: `kms_keys_not_rotated_within_90_days`
- ✅ `1.11`: `kms_separation_of_duties`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->