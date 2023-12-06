# CloudQuery &times; dbt: GCP Compliance Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql/v6.1.3/docs)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake/v3.3.3/docs)

### What's in the pack

- [DBT + Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [DBT + Postgres](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- [DBT + BigQuery](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup)

An example of how to install dbt to work with the destination of your choice.

First, install `dbt` for the destination of your choice:

The pack contains the premium version.
The premium version contains all queries.

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

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

For a specific model and the models in the dependency graph:

```bash
dbt run --select +"<model_name>"
```

For a specific folder and the models in the dependency graph:

```bash
dbt run --models +pro
```

More information can be found [here.](https://docs.getdbt.com/reference/node-selection/syntax)

### Usage

- Sync your data from GCP to destination (Postgres Example): `cloudquery sync gcp.yml postgres.yml`

- Run dbt: `dbt run`


