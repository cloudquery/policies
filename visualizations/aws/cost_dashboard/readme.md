# CloudQuery AWS Cost Dashboard for Grafana

## Overview

This contains an AWS Cost Dashboard for Grafana on top of CloudQuery [AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws), [File plugin](https://hub.cloudquery.io/plugins/source/cloudquery/file) and [AWS cost pack](https://hub.cloudquery.io/addons/transformation/cloudquery/cost/).

## Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
  - [AWS Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
  - [PostgreSQL Plugin](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
  - [File Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/file)
  - [AWS Cost Pack](https://hub.cloudquery.io/addons/transformation/cloudquery/cost/)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
  - [dbt + PostgreSQL](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

### Running

1. Install the requirements listed above.
2. Run `cloudquery sync` with the File, AWS, PostgreSQL plugins.

Reommendations:
```yml
kind: source
spec:
  name: file
  path: cloudquery/file
  registry: cloudquery
  version: "v1.2.1"
  tables: ["*"]
  destinations: ["postgresql"]

  spec:
    files_dir: "/path/to/cost_and_usage_reports" # Update this value to the local directory with your AWS Cost and Usage Reports
---
kind: source
spec:
  name: "aws"

  path: "cloudquery/aws"

  version: "v25.4.0"
  tables: ["aws_ec2_instances", "aws_ec2_instance_statuses", "aws_computeoptimizer_ec2_instance_recommendations", "aws_support_trusted_advisor_checks", "aws_cloudwatch_metrics", "aws_cloudwatch_metric_statistics", "aws_support_trusted_advisor_checks", "aws_support_trusted_advisor_check_results"]
  destinations: ["postgresql"]
  skip_dependent_tables: true
  spec:
    use_paid_apis: true
    table_options:
     aws_cloudwatch_metrics:
       - list_metrics:
           namespace: AWS/RDS 
         get_metric_statistics:
           - period: 300 
             start_time: <YOUR_START_TIME> # The starting point for the data collection. example: 2024-01-01T00:00:01Z
             end_time: <YOUR END TIME> # The ending point for the data collection. example: 2024-01-30T23:59:59Z
             statistics: ["Average", "Maximum", "Minimum"] 
       - list_metrics:
           namespace: AWS/EC2 
         get_metric_statistics:
           - period: 300 
             start_time: <YOUR_START_TIME> # The starting point for the data collection. example: 2024-01-01T00:00:01Z
             end_time: <YOUR END TIME> # The ending point for the data collection. example: 2024-01-30T23:59:59Z
             statistics: ["Average", "Maximum", "Minimum"]
---
kind: destination
spec:
  name: "postgresql"
  path: "cloudquery/postgresql"
  version: "v7.3.5"
  write_mode: "overwrite-delete-stale" # overwrite-delete-stale, overwrite, append
  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
            # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
            # You can also specify the connection string in DSN format, which allows for special characters in the password:
            # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"
```

3. Run `dbt run --vars '{"cost_usage_table": "<cost_and_usage_report>"}' --select tag:dashboard` <br>to build the models that relevant to the dashboard. 
4. Import the Grafana dashboard in this package.
    - Information about importing Grafana dashboards can be found [here](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/)
    - Note: If you have installed Postgres via Docker, ensure that Grafana is also installed via Docker. Once installed, you can use the IP address of your postgres container found by running `docker inspect container <container name>` along with the port as your host connection.

### Example dashboard

Once you have connected Grafana to your Postgres database and have imported the AWS Cost template, you will see a dashboard similar to this one:

![AWS General Dashboard](/images/general.png)
![AWS EC2 Dashboard](/images/ec2.png)