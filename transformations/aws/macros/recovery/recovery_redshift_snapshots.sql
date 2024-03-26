{% macro recovery_redshift_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_redshift_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_redshift_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_redshift_snapshots(framework, check_id) %}
with redshift_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon Redshift'
GROUP BY line_item_resource_id
) 
SELECT
		account_id,
    arn as resource_id,
    unblended_cost as cost,
    'redshift_snapshots' as resource_type
from aws_redshift_snapshots as ars
inner join redshift_snapshots_cost as rsc
on ars.arn = rsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_redshift_snapshots(framework, check_id) %}

{% endmacro %}