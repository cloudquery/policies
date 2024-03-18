{% macro recovery_elasticache_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_elasticache_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_elasticache_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_elasticache_snapshots(framework, check_id) %}
with elasticache_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon ElastiCache'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'elasticache_snapshots' as resource_type
from aws_elasticache_snapshots as aecs
inner join elasticache_snapshots_cost as ecsc
on aecs.arn = ecsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_elasticache_snapshots(framework, check_id) %}

{% endmacro %}