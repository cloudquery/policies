# CloudQuery AWS Asset Inventory Dashboard for Grafana

## Overview

This contains an AWS Asset Inventory Dashboard for Grafana on top of CloudQuery [AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws/v22.19.0/docs) and [AWS Asset Inventory pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-asset-inventory/).

## Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
  - [AWS Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
  - [PostgreSQL Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/postgresql)
  - [AWS Asset Inventory Pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-asset-inventory/)
- [dbt](https://docs.getdbt.com/docs/core/pip-install)
  - [dbt + PostgreSQL](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

### Running

1. Install the requirements listed above.
2. Run `cloudquery sync` with the aws and postgresql plugins.
3. Run `dbt run` to build the models.
4. [Import](https://grafana.com/docs/grafana/latest/dashboards/manage-dashboards/#export-and-import-dashboards) the Grafana dashboard in this package.
