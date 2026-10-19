#!/usr/bin/env bash
set -euo pipefail

DATABASE="athena_integration"
DATA_LOCATION="s3://cq-integration-tests/aws-compliance-athena/data"
OUTPUT_LOCATION="s3://cq-integration-tests/dbt/"

run_query() {
  local query="$1"
  local execution_id
  execution_id=$(aws athena start-query-execution \
    --query-string "$query" \
    --query-execution-context Database="$DATABASE" \
    --result-configuration OutputLocation="$OUTPUT_LOCATION" \
    --output text --query QueryExecutionId)

  while true; do
    local state
    state=$(aws athena get-query-execution --query-execution-id "$execution_id" --output text --query QueryExecution.Status.State)
    case "$state" in
      SUCCEEDED) return 0 ;;
      FAILED | CANCELLED)
        aws athena get-query-execution --query-execution-id "$execution_id" --output text --query QueryExecution.Status.StateChangeReason >&2
        return 1
        ;;
    esac
    sleep 2
  done
}

run_query "CREATE EXTERNAL TABLE IF NOT EXISTS aws_cloudwatch_metric_alarms (
  account_id string,
  region string,
  arn string,
  alarm_name string,
  actions_enabled boolean,
  alarm_actions array<string>,
  metrics string
)
STORED AS PARQUET
LOCATION '${DATA_LOCATION}/aws_cloudwatch_metric_alarms/'"
