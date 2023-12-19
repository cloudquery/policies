# CloudQuery &times; dbt: AWS Asset Inventory Package
## Overview

This package contains dbt models (views) that aggregates AWS Resources for AWS Asset Inventory.  This currently only supports PostgreSQL as a destination.


### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
- [dbt](https://docs.getdbt.com/docs/installation)
 
One of the below databases:

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)

#### dbt Installation

- [DBT + Postgres](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

An example of how to install dbt to work with the destination of your choice.

First, install `dbt` for the destination of your choice:

An example installation of dbt-postgres:

```bash
pip install dbt-postgres
```

These commands will also install install dbt-core and any other dependencies.

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
aws_asset_inventory: # This should match the name in your dbt_project.yml
  target: dev
  outputs:
    dev:
      type: postgres
      host: 127.0.0.1
      user: postgres
      pass: pass
      port: 5432
      dbname: aws
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

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

For a specific model and the models in the dependency graph:

```bash
dbt run --select +<model_name>
```

For a specific folder and the models in the dependency graph:

```bash
dbt run --models +<model_name>
```

#### Models

- **aws\_\_\aws_resources.sql**: AWS Resources View, available for PostgreSQL.
