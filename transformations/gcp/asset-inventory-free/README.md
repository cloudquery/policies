# CloudQuery &times; dbt: GCP Asset Inventory Package

## Overview

This GCP Asset Inventory package works on top of the CloudQuery framework. This package offers automated line-item listing of all active resources in your GCP environment. This package supports usage with PostgreSQL, BigQuery, and Snowflake databases.

### Example Queries

How many resources are there per project? (PostgreSQL)

```sql
select project_id, count(*)
from gcp_resources
group by project_id
order by count(*) desc
```

How many resources by project and region? (PostgreSQL)

```sql
select project_id, region, count(*)
from gcp_resources
group by project_id, region
order by count(*) desc
```

### Requirements

- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [CloudQuery](https://cloud.cloudquery.io/getting-started/)
- [CloudQuery GCP plugin](https://hub.cloudquery.io/plugins/source/cloudquery/gcp)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)

One of the below destination plugins based on your database:

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### Models Included

- **gcp_resources**: GCP Resources View, available for PostgreSQL.
  - Required tables: This model has no specific table dependencies, other than requiring a single CloudQuery table from the GCP plugin that has a project id.

#### Columns Included

- `_cq_id`
- `_cq_source_name`
- `_cq_sync_time`
- `project_id`
- `id`
- `region`
- `name`
- `description`
- `_cq_table`

## To run this package you need to complete the following steps

### 1. Download and extract this package.

Click the **Download now** button on the top. You may need to create a CloudQuery account first.

### 2. Install DBT and set up the DBT profile

[Install `dbt`](https://docs.getdbt.com/docs/core/pip-install):

```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
gcp_asset_inventory: # This should match the name in your dbt_project.yml
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

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly. First, switch to the directory where you extracted this package. Then run this command:

```bash
dbt debug
```

This command will tell you if dbt can successfully connect to your PostgreSQL instance:

```
...
09:37:00    retries: 1
09:37:00  Registered adapter: postgres=1.9.0
09:37:00    Connection test: [OK connection ok]

09:37:00  All checks passed!
```

### 3. Login to CloudQuery

To run a sync with CloudQuery, you will need to create an account and log in.

```
cloudquery login
```

### 4. Sync GCP data

This is an example sync config for the relevant tables for all the models (views) in this transformation. Save this to a file named `gcp.yaml`.
For detailed GCP authentication and configuration options and additional tables to add to the sync config, see the [GCP plugin documentation](https://hub.cloudquery.io/plugins/source/cloudquery/gcp/latest/docs).

```yml
kind: source
spec:
  name: "gcp" # The source type, in this case, GCP.
  path: "cloudquery/gcp" # The plugin path for handling GCP sources.
  registry: "cloudquery" # The registry from which the GCP plugin is sourced.
  version: "v19.1.0" # The version of the GCP plugin.
  tables: ["gcp_storage_buckets"] # Include any tables that meet your requirements, separated by commas
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  spec:
    # GCP Spec
    project_ids: ["my-project"] # The name of the GCP project you are working in

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v8.9.0" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}" # set the environment variable in a format like
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"
```

Run the sync:

```shell
cloudquery sync gcp.yaml
```

### 5. Create the views

Navigate to your dbt project directory, where you extracted this package.

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

### 6. Explore the data

Connect to your database and start exploring the data

```sql
select * from gcp_resources limit 10
```

### 7. Production deployment

This transformation creates a view on top of the database tables synced by CloudQuery CLI. You need to re-run the transformation (using the `dbt run` command) only if you add or remove tables from the sync.
