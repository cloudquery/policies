{% macro recovery_cloudhsmv2_backups_cur_2() %}
  {{ return(adapter.dispatch('recovery_cloudhsmv2_backups_cur_2')()) }}
{% endmacro %}

{% macro default__recovery_cloudhsmv2_backups_cur_2() %}{% endmacro %}

{% macro postgres__recovery_cloudhsmv2_backups_cur_2() %}
with cloudhsmv2_backups_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'AWS CloudHSM'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'cloudhsmv2_backups' as resource_type
from aws_cloudhsmv2_backups as acb
inner join cloudhsmv2_backups_cost as cbc
on acb.arn = cbc.resource_id
{% endmacro %}

{% macro snowflake__recovery_cloudhsmv2_backups_cur_2() %}

{% endmacro %}