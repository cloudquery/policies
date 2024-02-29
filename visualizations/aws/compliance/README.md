# CloudQuery AWS Compliance Dashboard for Grafana

## Overview

This contains an AWS Compliance Dashboard for Grafana on top of CloudQuery [AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws) and [AWS Compliance pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-compliance-free).

## Postgres Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
  - [AWS Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
  - [PostgreSQL Plugin](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql) or [Snowflake Plugin](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake/)
  - [AWS Compliance Pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-compliance-free/)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
  - [dbt + PostgreSQL](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

### Running

1. Install the requirements
2. Run `cloudquery sync` with the aws and postgresql or snowflake plugins.
3. Run `dbt run` to build the models.
4. [Import](https://github.com/cloudquery/cloudquery/blob/main/plugins/source/aws/dashboards/grafana/compliance.json) the Grafana dashboard JSON in this repository.
    - Information about importing Grafana dashboards can be found [here](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/)
    - Note: If you have installed Postgres via Docker, ensure that Grafana is also installed via Docker. Once installed, you can use the IP address of your postgres container found by running `docker inspect container <container name>` along with the port as your host connection.
5. Update Grafana variables as needed for Data Source and Frameworks.

### Example dashboard

Once you have connected Grafana to your Postgres database and have imported the AWS Asset Inventory template, you will see a dashboard similar to this one:

![AWS Compliance Dashboard](/images/aws_compliance_dash.png)
