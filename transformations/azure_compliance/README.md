# CloudQuery &times; dbt: Azure Compliance Package

## Overview

This package contains dbt models (views) that gives compliance insights from CloudQuery [Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure) data.

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure)
- [dbt](https://docs.getdbt.com/docs/installation)

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
- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql/v6.1.3/docs)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake/v3.3.3/docs)

### What's in the pack

The pack contains a free version and a full (paid) version.

#### Models

- **azure_compliance__cis_v1_3_0.sql**: Azure Compliance CIS V1.3.0, available for PostgreSQL.
- **azure_compliance_hipaa_hitrust_v9_2.sql**: Azure Compliance HIPPA HITRUST V9.2, available for PostgreSQL.

The free version contains 10% of the full pack's queries.