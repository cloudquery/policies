{% macro under_utilized_dynamodb_tables_default() %}
  {{ return(adapter.dispatch('under_utilized_dynamodb_tables_default')()) }}
{% endmacro %}

{% macro default__under_utilized_dynamodb_tables_default() %}{% endmacro %}

{% macro postgres__under_utilized_dynamodb_tables_default() %}
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
(
SELECT c.arn, c.tablename, c.region,
'ReadCapacityUtilizationRate' as metric,
c.mean_usage / r.mean_usage as mean_usage,
c.max_usage / r.max_usage as max_usage
FROM
     (SELECT arn, tablename, region, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ConsumedReadCapacityUnits') c
JOIN
    (SELECT arn, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ProvisionedReadCapacityUnits') r
USING(arn)

)
UNION
(
SELECT c.arn, c.tablename, c.region,
'WriteCapacityUtilizationRate' as metric,
c.mean_usage / r.mean_usage as mean_usage,
c.max_usage / r.max_usage as max_usage
FROM
     (SELECT arn, tablename, region, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ConsumedWriteCapacityUnits') c
JOIN
    (SELECT arn, mean_usage, max_usage
   FROM dynamodb_tables_metrics
   WHERE metric = 'ProvisionedWriteCapacityUnits') r
USING(arn)
)
),

cost_by_region_resource AS (
    SELECT
        product_region_code,
        line_item_resource_id,
        SUM(line_item_unblended_cost) AS cost
    FROM
        {{ var('cost_usage_table') }}
    WHERE
        line_item_resource_id != ''
        AND line_item_product_code = 'AmazonDynamoDB'
    GROUP BY
        1, 2
    ORDER BY
        cost DESC
)

SELECT 
    cw_usage.arn,
    NULL::text as instance_type,
    'DynamoDB' as service,
    cw_usage.metric as metric,
    cw_usage.mean_usage as mean_usage,
    cw_usage.max_usage as max_usage,
    cost.cost

FROM dynamodb_tables_utilization cw_usage
LEFT JOIN cost_by_region_resource cost ON (
        (
            cw_usage.tablename = cost.line_item_resource_id
            and cw_usage.region = cost.product_region_code
        )
        or cw_usage.arn = cost.line_item_resource_id
    )
WHERE mean_usage < 0.5
and cost > 0
{% endmacro %}
