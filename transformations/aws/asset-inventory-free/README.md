# CloudQuery &times; dbt: AWS Asset Inventory Package
## Overview

Welcome to our free edition of the AWS Asset Inventory package, a solution that works on top of the CloudQuery framework. This package offers automated line-item listing of all active resources in your AWS environment. Currently, this package only supports usage with PostgreSQL databases. 

We recommend using this transformation with our [AWS Asset Inventory Dashboard](https://hub.cloudquery.io/addons/visualization/cloudquery/aws-asset-inventory/latest/docs)

![AWS Asset Inventory Dashboard](./images/asset_inventory_dash.png)

### Example Queries

Which accounts have the most resources? (PostgreSQL)
```sql
select account_id, count(*)
from aws_resources
group by account_id
order by count(*) desc
```

Which services are most used in each account? (PostgreSQL)
```sql
select account_id, service, count(*)
from aws_resources
group by account_id, service
order by count(*) desc;
```

Which resources are not tagged? (PostgreSQL)
```sql
select * from aws_resources
where tags is null or tags = '{}';
```

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
 
One of the below databases:

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)

#### Models Included

- **aws_resources**: AWS Resources View, available for PostgreSQL.
  - Required tables: This model has no specific table dependencies, other than requiring a single CloudQuery table from the AWS plugin that has an ARN. 

  #### Columns Included

- `_cq_id`
- `_cq_source_name`
- `_cq_sync_time`
- `account_id`
- `request_account_id`
- `type`
- `arn`
- `region`
- `tags`
- `partition`
- `service`
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
aws_asset_inventory: # This should match the name in your dbt_project.yml
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

### Syncing AWS data
Based on the models you are interested in running you need to sync the relevant tables.
This is an example sync for the relevant tables for all the models (views) in the policy and with a Postgres destination.

 ```yml
kind: source
spec:
  name: aws # The source type, in this case, AWS.
  path: cloudquery/aws # The plugin path for handling AWS sources.
  registry: cloudquery # The registry from which the AWS plugin is sourced.
  version: "v25.5.3" # The version of the AWS plugin.
  tables: ["aws_ec2_instances"] # Include any tables that meet your requirements, separated by commas
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
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
