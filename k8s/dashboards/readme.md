# Kubernetes Dashboards - New Version

This directory contains pre-built dashboards. Currently those are available only for Grafana, but you can create them in any other BI platform:

Checkout those tutorials:   

* [Building Open Source Cloud Asset Inventory with CloudQuery and Grafana](https://www.cloudquery.io/blog/open-source-cloud-asset-inventory-with-cloudquery-and-grafana)
* [Building Open Source Cloud Asset Inventory with CloudQuery and Apache Superset](https://www.cloudquery.io/blog/cloud-asset-inventory-cloudquery-apache-superset)
* [Building Open Source Cloud Asset Inventory with CloudQuery and AWS QuickSight](https://www.cloudquery.io/blog/cloud-asset-inventory-cloudquery-aws-quicksight)
* [Building Open Source Cloud Asset Inventory with Metabase](https://www.cloudquery.io/blog/cloud-asset-inventory-cloudquery-metabase)

## What's inside?

### Kubernetes Compliance Dashboard - Summary

<img alt="Kubernetes Compliance Dashboard - Summary" src="../dashboards/grafana/Summary.png" width=50% height=50%>

#### Installing the Summary Dashboard

1. Execute one more of the Kubernetes policies.
2. Add the CloudQuery postgres database as a data source to Grafana (`Configuration -> Data Sources -> Add Data Source`)
3. Import [../dashboards/grafana/Summary.json](../dashboards/grafana/Summary.json) into Grafana (`Import -> Upload JSON File`).

### Kubernetes Compliance - In-Depth Analysis Dashboard

<img alt="Kubernetes Compliance Dashboard - In-Depth Analysis" src="../dashboards/grafana/in_depth_analysis.png" width=50% height=50%>

#### Installing the Summary Dashboard

1. Add the CloudQuery postgres database as a data source to Grafana (`Configuration -> Data Sources -> Add Data Source`)
2. Import [../dashboards/grafana/in_depth_analysis.json](../dashboards/grafana/in_depth_analysis.json) into Grafana (`Import -> Upload JSON File`).

### Kubernetes Compliance - Time-Based Status Dashboard

<img alt="Kubernetes Compliance Dashboard - Time-Based Status" src="../dashboards/grafana/time_based_status.png" width=50% height=50%>

#### Installing the Summary Dashboard

1. Add the CloudQuery postgres database as a data source to Grafana (`Configuration -> Data Sources -> Add Data Source`)
2. Import [../dashboards/grafana/time_based_status.json](../dashboards/grafana/time_based_status.json) into Grafana (`Import -> Upload JSON File`).