WITH ec2_instance_resource_utilization AS (
    SELECT
        'arn:aws:ec2:' || cws.region::text || ':' || cws.account_id::text || ':instance/' || (elem.value ->> 'Value')::text AS arn,
        elem.value ->> 'Value' AS instance_id,
        cws.region,
        cws.label,
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
        product_region_code,
        line_item_resource_id,
        SUM(line_item_unblended_cost) AS cost
    FROM
        {{ adapter.quote(var('cost_usage_table')) }}
    WHERE
        line_item_resource_id != ''
        AND line_item_product_code = 'AmazonEC2'
    GROUP BY
        1, 2
    ORDER BY
        cost DESC
)
SELECT
    cw_usage.arn,
    ec2.instance_type,
    cw_usage.mean_usage as mean_usage,
    cost.cost
FROM
    ec2_instance_resource_utilization cw_usage
    LEFT JOIN aws_ec2_instances ec2 ON (
        (
            cw_usage.instance_id = ec2.instance_id
            and cw_usage.region = ec2.region
        )
        or cw_usage.arn = ec2.arn
    )
    LEFT JOIN cost_by_region_resource cost ON (
        (
            cw_usage.instance_id = cost.line_item_resource_id
            and cw_usage.region = cost.product_region_code
        )
        or cw_usage.arn = cost.line_item_resource_id
    )
WHERE
    cw_usage.label = 'CPUUtilization'
    and cost > 0 