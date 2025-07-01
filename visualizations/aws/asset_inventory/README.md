# CloudQuery AWS Asset Inventory Dashboard for Grafana

## Overview

This contains an AWS Asset Inventory Dashboard for Grafana on top of CloudQuery [AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws) and [AWS Asset Inventory pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-asset-inventory/).

## Requirements

- [CloudQuery](https://cli-docs.cloudquery.io/docs/quickstart/)
  - [AWS Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
  - [PostgreSQL Plugin](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
  - [AWS Asset Inventory Pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-asset-inventory/)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
  - [dbt + PostgreSQL](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

### Running

1. Install the requirements listed above.
2. Run `cloudquery sync` with the aws and postgresql plugins.
3. Run `dbt run` to build the models.
4. [Import](https://grafana.com/grafana/dashboards/16347-aws-asset-inventory/) the Grafana dashboard in this package.
    - Information about importing Grafana dashboards can be found [here](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/)
    - Note: If you have installed Postgres via Docker, ensure that Grafana is also installed via Docker. Once installed, you can use the IP address of your postgres container found by running `docker inspect container <container name>` along with the port as your host connection.

### Example dashboard

Once you have connected Grafana to your Postgres database and have imported the AWS Asset Inventory template, you will see a dashboard similar to this one:

![AWS Asset Inventory](/images/asset_inventory_dash.png)
