{% macro recovery_docdb_cluster_snapshots_cur_2(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_docdb_cluster_snapshots_cur_2')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_docdb_cluster_snapshots_cur_2(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_docdb_cluster_snapshots_cur_2(framework, check_id) %}
with docdb_cluster_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon DocumentDB'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'docdb_cluster_snapshots' as resource_type
from aws_docdb_cluster_snapshots as adcs
inner join docdb_cluster_snapshots_cost as dcsc
on adcs.arn = dcsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_docdb_cluster_snapshots_cur_2(framework, check_id) %}

{% endmacro %}