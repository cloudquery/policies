# CloudQuery &times; dbt: AWS Resilience (AWS Backup)

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [PostgreSQL](https://www.postgresql.org/download/) or any other mutually supported destination
- [CloudQuery](https://www.cloudquery.io/docs/quickstart) with [AWS](https://www.cloudquery.io/docs/plugins/sources/aws/overview) and [PostgreSQL](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview)

[Quick guide](https://www.cloudquery.io/integrations/gcp/postgresql) for GCP-Postgres integration.

#### dbt Installation

An example of how to install dbt to work with Postgres.

First, install `dbt`:

```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
aws_encryption: # This should match the name in your dbt_project.yml
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

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides.

Before executing the `dbt run` command, it might be useful to check for any potential issues:

```dbt run```

This command will run your `dbt` models and create tables/views in your PostgreSQL database as defined in your models.

### Usage

### CloudQuery Sync

Make sure you synced your AWS metadata with CloudQuery [AWS source plugin](https://www.cloudquery.io/docs/plugins/sources/overview), and [PostgreSQL destination](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview).

- Run dbt: `dbt run`
