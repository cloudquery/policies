{ % macro under_utilized_dynamodb_tables_default() % } { { return(
    adapter.dispatch('under_utilized_dynamodb_tables_default')()
) } } { % endmacro % } 

{ % macro default__under_utilized_dynamodb_tables_default() % } { % endmacro % }

{ % macro postgres__under_utilized_dynamodb_tables_default() % } 
WITH dynamodb_tables_metrics AS (
    SELECT
        'arn:aws:dynamodb:' || cws.region::text || ':' || cws.account_id::text || ':table/' || (elem.value ->> 'Value')::text AS arn,
        elem.value ->> 'Value' AS tablename,
        cws.region,
        cws.label as metric,
        MAX(cws.maximum) AS max_usage,
        AVG(cws.average) AS mean_usage
    FROM
        aws_cloudwatch_metric_statistics cws,
        jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
    WHERE
         cws.input_json ->> 'Namespace' = 'AWS/DynamoDB'
        AND elem ->> 'Name' = 'TableName'
    GROUP BY
        1, 2, 3, 4
),
dynamodb_tables_utilization AS (
SELECT cr.arn, cr.tablename, cr.region, 
cr.mean_usage as mean_consumed_read, cr.max_usage as max_consumed_read,
pr.mean_usage as mean_provisioned_read, pr.max_usage as max_provisioned_read,
cw.mean_usage as mean_consumed_write, cw.max_usage as max_consumed_write,
pw.mean_usage as mean_provisioned_write, pw.max_usage as max_provisioned_write,
cr.mean_usage /  pr.mean_usage as  read_utilization_rate,
cw.mean_usage /  pw.mean_usage as  write_utilization_rate

FROM
  (SELECT arn, tablename, region, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ConsumedReadCapacityUnits') cr
JOIN
  (SELECT arn, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ProvisionedReadCapacityUnits') pr
USING(arn)
JOIN
  (SELECT arn, tablename, region, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ConsumedWriteCapacityUnits') cw
USING(arn)
JOIN
  (SELECT arn, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ProvisionedWriteCapacityUnits') pw
USING(arn)
),

cost_by_region_resource AS (
    SELECT
        product_region,
        line_item_resource_id,
        SUM(line_item_blended_cost) AS cost
    FROM
        john_cost_00001_snappy
    WHERE
        line_item_resource_id != ''
        AND line_item_product_code = 'AmazonDynamoDB'
    GROUP BY
        1, 2
    ORDER BY
        cost DESC
)

SELECT arn, tablename, region, read_utilization_rate, write_utilization_rate
FROM dynamodb_tables_utilization
WHERE read_utilization_rate < 0.5 OR write_utilization_rate < 0.5
{ % endmacro % }