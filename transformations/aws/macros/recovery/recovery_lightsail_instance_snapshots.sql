{% macro recovery_lightsail_instance_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_lightsail_instance_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_lightsail_instance_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_lightsail_instance_snapshots(framework, check_id) %}
with instance_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE product_product_name = 'Amazon Lightsail'
GROUP BY line_item_resource_id
)
select
		account_id,
    arn as resource_id,
    unblended_cost as cost,
    'lightsail_instance_snapshots' as resource_type
from aws_lightsail_instance_snapshots as lis
inner join instance_snapshots_cost as isc
on lis.arn = isc.resource_id
{% endmacro %}

{% macro snowflake__recovery_lightsail_instance_snapshots(framework, check_id) %}

{% endmacro %}