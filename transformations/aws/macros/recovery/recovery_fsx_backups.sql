{% macro recovery_fsx_backups(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_fsx_backups')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_fsx_backups(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_fsx_backups(framework, check_id) %}
with fsx_backups_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ adapter.quote(var('cost_usage_table')) }}
WHERE line_item_product_code = 'Amazon FSx'
GROUP BY line_item_resource_id
) 
SELECT
	account_id,
    resource_arn as resource_id,
    unblended_cost as cost,
    'fsx_backups' as resource_type
from aws_fsx_backups as afb
inner join fsx_backups_cost as fbc
on afb.resource_arn = fbc.resource_id
{% endmacro %}

{% macro snowflake__recovery_fsx_backups(framework, check_id) %}

{% endmacro %}