# CloudQuery + dbt AWS Data Resilience (AWS Backup)

## Overview

This AWS Data Resilience package works on top of the CloudQuery framework. This package offers automated insight into your AWS Backup posture in your AWS environment. This package supports PostgreSQL database only.

We recommend using this transformation with our [AWS Data Resilience Dashboard](https://hub.cloudquery.io/addons/visualization/cloudquery/aws-data-resilience/latest/docs)

![AWS Data Resilience Dashboard](./images/aws_resiliency_dash.png)

### Requirements

- [CloudQuery](https://docs.cloudquery.io/docs/quickstart/)
- [CloudQuery AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)

### Models Included

- **aws_data_resilience\_\_overview**: AWS Backup overview for `aws_dynamodb_tables`, `aws_ec2_instances` and `aws_s3_buckets`, available for PostgreSQL.

#### Columns Included

- `account_id`
- `resource_arn`
- `tags`
- `last_backup_time`
- `resource_type`

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
aws_data_resilience: # This should match the name in your dbt_project.yml
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

### 4. Sync AWS data

This is an example sync config with the minimum set of tables for this transformation. Save this to a file named `aws.yaml`.
For detailed AWS authentication and configuration options and additional tables to add to the sync config, see the [AWS plugin documentation](https://hub.cloudquery.io/plugins/source/cloudquery/aws/latest/docs).

```yml
kind: source
spec:
  name: aws # The source type, in this case, AWS.
  path: cloudquery/aws # The plugin path for handling AWS sources.
  registry: cloudquery # The registry from which the AWS plugin is sourced.
  version: "v32.38.0" # The version of the AWS plugin.
  tables: ["aws_dynamodb_tables", "aws_ec2_instances", "aws_s3_buckets"] # Include any tables that meet your requirements, separated by commas
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  spec:

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
cloudquery sync aws.yaml
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

Connect to your PostgreSQL database and start exploring the data

```sql
select * from aws_data_resilience__overview limit 10
```

### 7. Set up Grafana dashboard (Optional)

Follow the instructions in [AWS Data Resilience Dashboard](https://hub.cloudquery.io/addons/visualization/cloudquery/aws-data-resilience/latest/docs) to set up a dashboard in Grafana. Note the visualization supports PostgreSQL database only.

### 8. Production deployment

This transformation creates a view on top of the database tables synced by CloudQuery CLI. You need to re-run the transformation (using the `dbt run` command) only if you add or remove tables from the sync.
