# CloudQuery &times; dbt: GCP Compliance Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

- [DBT + Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [DBT + Postgres](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- [DBT + BigQuery](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup)

An example of how to install dbt to work with the destination of your choice.

First, install `dbt` for the destination of your choice:

The pack contains the free version.
The free version contains 10% of the full pack's queries.

#### Models

- **gcp_compliance\_\_cis_v1.2.0**: GCP CIS V1.2.0 benchmarks, available for PostgreSQL

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides.

Before executing the `dbt run` command, it might be useful to check for any potential issues:

```bash
dbt compile
```

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run your `dbt` models and create tables/views in your destination database as defined in your models.

### Usage

- Sync your data from GCP to destination (Postgres Example): `cloudquery sync gcp.yml postgres.yml`

- Run dbt: `dbt run`

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
- ✅ `1.4`: `iam_managed_service_account_keys`
- ✅ `1.5`: `iam_service_account_admin_priv`
- ✅ `1.6`: `iam_users_with_service_account_token_creator_role`
- ✅ `1.7`: `iam_service_account_keys_not_rotated`
- ✅ `1.8`: `iam_separation_of_duties`
- ✅ `1.9`: `kms_publicly_accessible`
- ✅ `1.10`: `kms_keys_not_rotated_within_90_days`
- ✅ `1.11`: `kms_separation_of_duties`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->