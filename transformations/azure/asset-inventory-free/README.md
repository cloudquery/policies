# CloudQuery &times; dbt: Azure Asset Inventory Package
## Overview

Welcome to our free edition of the Azure Asset Inventory package, a solution that works on top of the CloudQuery framework. This package offers automated line-item listing of all active resources in your Azure environment. Currently, this package supports usage with PostgreSQL, Snowflake, and BigQuery databases. 

### Coming soon
- Azure Asset Inventory Dashboard

### Example Queries

How many resources are there per subscription? (PostgreSQL)

```sql
select subscription_id, count(*)
from azure_resources
group by subscription_id
order by count(*) desc
```

Resources by id and location (PostgreSQL)

```sql
select id, location, count(*)
from azure_resources
group by id, location
order by count(*) desc
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/core/pip-install)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [CloudQuery Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure)
 
One of the below databases:

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

#### Models Included

- **azure_resources**: Azure Resources View, available for PostgreSQL.
  - Required tables: This model has no specific table dependencies, other than requiring a single CloudQuery table from the Azure plugin that has a subscription id. 

#### Columns Included

- `_cq_id`
- `_cq_source_name`
- `_cq_sync_time`
- `subscription_id`
- `id`
- `location`
- `name`
- `kind`
- `_cq_table`

## To run this package you need to complete the following steps

### Setting up the DBT profile
First, [install `dbt`](https://docs.getdbt.com/docs/core/pip-install):
```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
azure_asset_inventory: # This should match the name in your dbt_project.yml
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
`cloudquery login` in your terminal.

### Syncing Azure data
Based on the models you are interested in running you need to sync the relevant tables.
This is an example sync for the relevant tables for all the models (views) in the policy and with a PostgreSQL destination.

 ```yml
kind: source
spec:
  name: "azure" # The source type, in this case, Azure.
  path: "cloudquery/azure" # The plugin path for handling Azure sources.
  registry: "cloudquery" # The registry from which the Azure plugin is sourced.
  version: "v12.1.2" # The version of the Azure plugin.
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  tables: ["azure_compute_virtual_machines"] # Include any tables that meet your requirements, separated by commas
  spec: 

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v8.0.1" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"

 ```

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

**Note:** If running locally, ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication.

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

For a specific model and the models in the dependency graph:

```bash
dbt run --select +<model_name>
```

For a specific folder and the models in the dependency graph:

```bash
dbt run --models +<model_name>
```

