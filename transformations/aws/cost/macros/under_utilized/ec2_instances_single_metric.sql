{% macro under_utilized_ec2_instances_single_metric() %}
  {{ return(adapter.dispatch('under_utilized_ec2_instances_single_metric')()) }}
{% endmacro %}

{% macro default__under_utilized_ec2_instances_single_metric() %}{% endmacro %}
{% macro postgres__under_utilized_ec2_instances_single_metric() %}
{% set metric = var('metric', 'CPUUtilization') %}
{% set namespace = var('namespace', 'AWS/EC2') %}
with ec2_instance_resource_utilization AS (
    SELECT
        (SELECT value->>'Value' FROM jsonb_array_elements(cws.input_json->'Dimensions') AS elem WHERE elem->>'Name' = 'InstanceId') AS instance_id,
        cws.label,
        max(cws.maximum) as max_usage,
        avg(cws.average) as mean_usage,
        min(cws.minimum) as min_usage
    FROM
        aws_cloudwatch_metric_statistics cws
    INNER JOIN aws_cloudwatch_metrics cm
        ON cws._cq_parent_id = cm._cq_id
    WHERE
        cws.label '{{metric}}'
        AND
        cm.namespace = '{{namespace}}'
    GROUP BY 1, 2
)
-- combining with cost
SELECT cw_usage.isntance_id as arn, cost.cost
FROM ec2_instance_reousrce_utilization cw_usage
LEFT JOIN {{ ref('aws_cost__by_resources') }} cost 
    ON cw_usage.instance_id = cost.line_item_resource_id
WHERE
(cw_usage.label = '{{metric}}' and cw_usage.mean_usage > 50)
{% endmacro %}