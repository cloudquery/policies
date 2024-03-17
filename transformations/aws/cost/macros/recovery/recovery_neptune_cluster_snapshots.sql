{% macro recovery_neptune_cluster_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_neptune_cluster_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_neptune_cluster_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_neptune_cluster_snapshots(framework, check_id) %}
with neptune_cluster_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon Neptune'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'neptune_cluster_snapshots' as resource_type
from aws_neptune_cluster_snapshots as ancs
inner join neptune_cluster_snapshots_cost as ncsc
on ancs.arn = ncsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_neptune_cluster_snapshots(framework, check_id) %}

{% endmacro %}