{% macro recovery_lightsail_disk_snapshots_cur_2(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_lightsail_disk_snapshots_cur_2')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_lightsail_disk_snapshots_cur_2(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_lightsail_disk_snapshots_cur_2(framework, check_id) %}
with disk_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon Lightsail'
GROUP BY line_item_resource_id
)
select 
		account_id,
    arn as resource_id,
    unblended_cost as cost,
    'lightsail_disk_snapshots' as resource_type
from aws_lightsail_disk_snapshots as lds
inner join disk_snapshots_cost as dsc
on lds.arn = dsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_lightsail_disk_snapshots_cur_2(framework, check_id) %}

{% endmacro %}