{ % macro under_utilized_rds_db_clusters_default() % } { { return(
    adapter.dispatch('under_utilized_rds_db_clusters_default')()
) } } { % endmacro % }
{ % macro default__under_utilized_rds_db_clusters_default() % } { % endmacro % } 
{ % macro postgres__under_utilized_rds_db_clusters_default() % } with rds_cluster_resource_utilization AS (
    SELECT
        'arn:aws:rds:' || region :: text || ':' || account_id :: text || ':cluster:' || (
            SELECT
                value ->> 'Value'
            FROM
                jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
            WHERE
                elem ->> 'Name' = 'DBClusterIdentifier'
        ) :: text AS arn,
        (
            SELECT
                value ->> 'Value'
            FROM
                jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
            WHERE
                elem ->> 'Name' = 'DBClusterIdentifier'
        ) AS rds_id,
        cws.region,
        cws.label,
        max(cws.maximum) as max_usage,
        avg(cws.average) as mean_usage
    FROM
        aws_cloudwatch_metric_statistics cws
    WHERE
        cws.label = 'CPUUtilization'
        AND cws.input_json ->> 'Namespace' = 'AWS/RDS' --AND
        --cws.input_json::text LIKE '%%DBClusterIdentifier%%'
    GROUP BY
        1,
        2,
        3,
        4
),
rds_instance_resource_utilization as (
    SELECT
        'arn:aws:rds:' || region :: text || ':' || account_id :: text || ':db:' || (
            SELECT
                value ->> 'Value'
            FROM
                jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
            WHERE
                elem ->> 'Name' = 'DBInstanceIdentifier'
        ) :: text AS arn,
        (
            SELECT
                value ->> 'Value'
            FROM
                jsonb_array_elements(cws.input_json -> 'Dimensions') AS elem
            WHERE
                elem ->> 'Name' = 'DBInstanceIdentifier'
        ) AS rds_id,
        cws.region,
        cws.label,
        max(cws.maximum) as max_usage,
        avg(cws.average) as mean_usage
    FROM
        aws_cloudwatch_metric_statistics cws
    WHERE
        cws.label = 'CPUUtilization'
        AND cws.input_json ->> 'Namespace' = 'AWS/RDS'
        AND cws.input_json :: text LIKE '%%DBInstanceIdentifier%%'
    GROUP BY
        1,
        2,
        3,
        4
),
rds_resource_utilization as (
    (
        SELECT
            rcu.*,
            'RDS Cluster' as service,
            rc.db_cluster_instance_class as instance_type
        FROM
            rds_cluster_resource_utilization rcu
            LEFT JOIN aws_rds_clusters rc ON (
                rcu.arn = rc.arn
                OR (
                    rcu.rds_id = rc.db_cluster_identifier
                    AND rcu.region = rc.region
                )
            )
    )
    UNION
    (
        SELECT
            riu.*,
            'RDS Instance' as service,
            ri.db_instance_class as instance_type
        FROM
            rds_instance_resource_utilization riu
            LEFT JOIN aws_rds_instances ri ON (
                riu.arn = ri.arn
                OR (
                    riu.rds_id = ri.db_instance_identifier
                    AND riu.region = ri.region
                )
            )
    )
),
cost_by_region_resource as (
    SELECT
        product_region,
        line_item_resource_id,
        sum(line_item_blended_cost) AS cost
    FROM
        {{ var('cost_usage_table') }}
    WHERE
        line_item_resource_id != ''
        AND
        line_item_product_code = 'AmazonRDS'
    GROUP BY
        1,
        2
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