{% macro recovery_lightsail_database_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_lightsail_database_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_lightsail_database_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_lightsail_database_snapshots(framework, check_id) %}
with db_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ adapter.quote(var('cost_usage_table')) }}
WHERE line_item_product_code = 'Amazon Lightsail'
GROUP BY line_item_resource_id
)
select 
		account_id,
    arn as resource_id,
    unblended_cost as cost,
    'lightsail_database_snapshots' as resource_type
from aws_lightsail_database_snapshots as ldbs
inner join db_snapshots_cost as dbsc
on ldbs.arn = dbsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_lightsail_database_snapshots(framework, check_id) %}

{% endmacro %}