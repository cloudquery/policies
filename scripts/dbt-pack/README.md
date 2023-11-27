# dbt-pack

A utility to pack a dbt project into a single zip file.

## Prerequisites

- [Node.js LTS](https://nodejs.org/en/)

## Setup

```bash
npm ci
```

## Usage

```bash
node index.js dbt-pack --project-dir=../../transformations/azure/compliance-free
node index.js dbt-pack --project-dir=../../transformations/azure/compliance-premium

node index.js dbt-pack --project-dir=../../transformations/k8s/compliance-free
node index.js dbt-pack --project-dir=../../transformations/k8s/compliance-premium

node index.js dbt-pack --project-dir=../../transformations/gcp/compliance-free
node index.js dbt-pack --project-dir=../../transformations/gcp/compliance-premium

node index.js dbt-pack --project-dir=../../transformations/aws/compliance-free
node index.js dbt-pack --project-dir=../../transformations/aws/compliance-premium
node index.js dbt-pack --project-dir=../../transformations/aws/data-resilience
```
