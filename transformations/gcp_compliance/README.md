# CloudQuery &times; dbt: GCP Compliance Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [PostgreSQL](https://www.postgresql.org/download/) or any other mutually supported destination
- [CloudQuery](https://www.cloudquery.io/docs/quickstart) with [GCP](https://www.cloudquery.io/docs/plugins/sources/gcp/overview) and [PostgreSQL](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview)

[Quick guide](https://www.cloudquery.io/integrations/gcp/postgresql) for GCP-Postgres integration.

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


Another option:

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

This command will tell you if dbt can successfully connect to your destination database.

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
