# CloudQuery AWS Data Resilience and Backup Dashboard for Grafana

## Overview

This package contains an AWS Resilience and Backup Dashboard for Grafana on top of CloudQuery [AWS plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws) and [AWS Data Resilience transformation](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-data-resilience) with PostgreSQL database.

## Requirements

- [CloudQuery](https://cli-docs.cloudquery.io/docs/quickstart/)
- [AWS Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws)
- [PostgreSQL Plugin](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [AWS Data Resilience Pack](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-data-resilience/)

### Setting up the dashboard

1. Follow the instructions to set up the [AWS Data Resilience Transformation](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-data-resilience/)

2. In Grafana, make sure your PostgreSQL database is added as a data source.

3. Download this package (using the **Download now** button on top) and extract this package.
4. [Import](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/) the `backup-health.json` dashboard definition from this package.

   - Note: If you have installed Postgres via Docker, ensure that Grafana is also installed via Docker. Once installed, you can use the IP address of your postgres container found by running `docker inspect container <container name>` along with the port as your host connection.

5. Update Grafana variables as needed for Data Source and Frameworks.

### Example dashboard

Once you have connected Grafana to your Postgres database and have imported the AWS Asset Inventory template, you will see a dashboard similar to this one:

![AWS Data Resilience](/images/aws-resiliency-dash.png)
