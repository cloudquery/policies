# CloudQuery AWS Data Resilience and Backup Dashboard for Grafana

## Overview

This contains an AWS Resilience and Backup Dashboard for Grafana on top of CloudQuery [AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws) and [AWS Compliance pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-compliance-free).

## Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
  - [AWS Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
  - [PostgreSQL Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/postgresql) or [Snowflake Plugin](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake/)
  - [AWS Data Resilience Pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-compliance-free/)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
  - [dbt + PostgreSQL](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

### Running

1. Install the requirements
2. Run `cloudquery sync` with the aws and postgresql or snowflake plugins.
3. Run `dbt run` to build the models.
4. [Import](https://grafana.com/docs/grafana/latest/dashboards/manage-dashboards/#export-and-import-dashboards) the Grafana dashboard in this package.