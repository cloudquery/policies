{ % macro under_utilized_rds_clusters_and_instances_default() % } { { return(
    adapter.dispatch('under_utilized_rds_clusters_and_instances_default')()
) } } { % endmacro % }
{ % macro default__under_utilized_rds_clusters_and_instances_default() % } { % endmacro % } 
{ % macro postgres__under_utilized_rds_clusters_and_instances_default() % }
WITH rds_cluster_resource_utilization AS (
    SELECT
        'arn:aws:rds:' || cws.region::text || ':' || cws.account_id::text || ':cluster:' || (elem.value ->> 'Value')::text AS arn,
        elem.value ->> 'Value' AS rds_id,
        cws.region,
        cws.label,
        MAX(cws.maximum) AS max_usage,
        AVG(cws.average) AS mean_usage
    FROM
        aws_cloudwatch_metric_statistics cws,
        jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
    WHERE
        cws.label = 'CPUUtilization'
        AND cws.input_json ->> 'Namespace' = 'AWS/RDS'
        AND cws.input_json::text LIKE '%DBClusterIdentifier%'
        AND elem ->> 'Name' = 'DBClusterIdentifier'
    GROUP BY
        1, 2, 3, 4
),
rds_instance_resource_utilization AS (
    SELECT
        'arn:aws:rds:' || cws.region::text || ':' || cws.account_id::text || ':db:' || (elem.value ->> 'Value')::text AS arn,
        elem.value ->> 'Value' AS rds_id,
        cws.region,
        cws.label,
        MAX(cws.maximum) AS max_usage,
        AVG(cws.average) AS mean_usage
    FROM
        aws_cloudwatch_metric_statistics cws
        jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
    WHERE
        cws.label = 'CPUUtilization'
        AND cws.input_json ->> 'Namespace' = 'AWS/RDS'
        AND cws.input_json::text LIKE '%DBInstanceIdentifier%'
        AND elem ->> 'Name' = 'DBInstanceIdentifier'
    GROUP BY
        1, 2, 3, 4
),
rds_resource_utilization AS (
    SELECT
        rcu.*,
        'RDS Cluster' AS service,
        rc.db_cluster_instance_class AS instance_type
    FROM
        rds_cluster_resource_utilization rcu
        LEFT JOIN aws_rds_clusters rc ON rcu.arn = rc.arn OR (rcu.rds_id = rc.db_cluster_identifier AND rcu.region = rc.region)

    UNION ALL

    SELECT
        riu.*,
        'RDS Instance' AS service,
        ri.db_instance_class AS instance_type
    FROM
        rds_instance_resource_utilization riu
        LEFT JOIN aws_rds_instances ri ON riu.arn = ri.arn OR (riu.rds_id = ri.db_instance_identifier AND riu.region = ri.region)
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
        AND line_item_product_code = 'AmazonRDS'
    GROUP BY
        1, 2
    ORDER BY
        cost DESC
)
SELECT
    cw_usage.arn,
    cw_usage.instance_type,
    cw_usage.service,
    cw_usage.label as metric,
    cw_usage.mean_usage as mean_usage,
    cw_usage.max_usage as max_usage,
    cost.cost
FROM
    rds_resource_utilization cw_usage
    LEFT JOIN cost_by_region_resource cost ON (
        (
            cw_usage.rds_id = cost.line_item_resource_id
            and cw_usage.region = cost.product_region
        )
        or cw_usage.arn = cost.line_item_resource_id
    )
WHERE
    (
        cw_usage.label = 'CPUUtilization'
        and cw_usage.mean_usage < 50
    )
    and cost > 0 
{ % endmacro % }