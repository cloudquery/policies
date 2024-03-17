{% macro recovery_dynamodb_backups_cur_2(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_dynamodb_backups_cur_2')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_dynamodb_backups_cur_2(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_dynamodb_backups_cur_2(framework, check_id) %}
with dynamodb_backups_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon DynamoDB'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'dynamodb_backups' as resource_type
from aws_dynamodb_backups as adb
inner join dynamodb_backups_cost as dbc
on adb.arn = dbc.resource_id
{% endmacro %}

{% macro snowflake__recovery_dynamodb_backups_cur_2(framework, check_id) %}

{% endmacro %}