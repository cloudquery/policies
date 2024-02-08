{% macro under_utilized_ec2_instances_multi_metric() %}
  {{ return(adapter.dispatch('under_utilized_ec2_instances_multi__metric')()) }}
{% endmacro %}

{% macro default__under_utilized_ec2_instances_multi__metric() %}{% endmacro %}
{% macro postgres__under_utilized_ec2_instances_multi__metric() %}

{% set metric_labels = var('metric_labels', 'CPUUtilization, cpu_usage_user, mem_used_percent, disk_used_percent, cpu_usage_system').split(',') %}

with ec2_instance_resource_utilization AS (
    SELECT
        (SELECT value->>'Value' FROM jsonb_array_elements(cws.input_json->'Dimensions') AS elem WHERE elem->>'Name' = 'InstanceId') AS instance_id,
        cws.label,
        max(cws.maximum) as max_usage,
        avg(cws.average) as mean_usage,
        min(cws.minimum) as min_usage
    FROM
        aws_cloudwatch_metric_statistics cws
    WHERE
        cws.label IN ({{ metric_labels | join(", ") | sqlsafe }})
    GROUP BY 1, 2
)
SELECT cw_usage.isntance_id as arn, cost.cost
FROM ec2_instance_reousrce_utilization cw_usage
LEFT JOIN {{ ref('aws_cost__by_resources') }} cost 
    ON cw_usage.instance_id = cost.line_item_resource_id
WHERE
(cw_usage.label IN ({{ metric_labels | join(", ") | sqlsafe }}) and cw_usage.mean_usage > 50)
{% endmacro %}