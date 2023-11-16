# CloudQuery + dbt AWS Data Resilience (AWS Backup)

## Overview

This pack contains set of dbt models to gain insight to AWS Backup posture.

#### Models

- **aws_data_resilience__overview**: AWS Backup overview for `aws_dynamodb_tables`, `aws_ec2_instances` and `aws_s3_buckets`, available for PostgreSQL.

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
  - [AWS Plugin](https://www.cloudquery.io/docs/plugins/sources/aws/overview)
  - [PostgreSQL Plugin](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
  - [dbt + PostgreSQL](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

### Running

#### Requirements

Make sure to install all the requirements.

#### Create a profile for dbt:

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`) to configure dbt to which database it should connect (the same one you used to sync AWS/PostgreSQL plugin with CloudQuery):

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

#### Test the Connection

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly:

```bash
dbt debug
```

#### Run

```dbt run```

This command will run your `dbt` models and create tables/views in your PostgreSQL database as defined in your models.
