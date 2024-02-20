{ % macro under_utilized_ec2_instances_default() % } 
{{ return(adapter.dispatch('under_utilized_ec2_instances_default')()) }} {% endmacro %} 

{% macro default__under_utilized_ec2_instances_default() %} {% endmacro %}

{ % macro postgres__under_utilized_ec2_instances_default() % }
WITH ec2_instance_resource_utilization AS (
    SELECT
        'arn:aws:ec2:' || cws.region::text || ':' || cws.account_id::text || ':instance/' || (elem.value ->> 'Value')::text AS arn,
        elem.value ->> 'Value' AS instance_id,
        cws.region,
        cws.label,
        MAX(cws.maximum) AS max_usage,
        AVG(cws.average) AS mean_usage
    FROM
        aws_cloudwatch_metric_statistics cws,
        jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
    WHERE
        cws.label = 'CPUUtilization'
        AND cws.input_json ->> 'Namespace' = 'AWS/EC2'
        AND elem ->> 'Name' = 'InstanceId'
    GROUP BY
        1, 2, 3, 4
),
cost_by_region_resource AS (
    SELECT
        product_region,
        line_item_resource_id,
        SUM(line_item_blended_cost) AS cost
    FROM
        {{ var('cost_usage_table') }}
    WHERE
        line_item_resource_id != ''
        AND line_item_product_code = 'AmazonEC2'
    GROUP BY
        1, 2
    ORDER BY
        cost DESC
)
SELECT
    eu.arn,
    ec2.instance_type,
    'EC2' AS service,
    eu.label AS metric,
    eu.mean_usage,
    eu.max_usage,
    c.cost
FROM
    ec2_instance_resource_utilization eu
    LEFT JOIN aws_ec2_instances ec2 ON eu.instance_id = ec2.instance_id AND eu.region = ec2.region
    LEFT JOIN cost_by_region_resource c ON eu.instance_id = c.line_item_resource_id AND eu.region = c.product_region
WHERE
    eu.label = 'CPUUtilization'
    AND eu.mean_usage < 50
    AND c.cost > 0
{ % endmacro % }