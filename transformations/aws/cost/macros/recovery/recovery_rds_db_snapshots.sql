{% macro recovery_rds_db_snapshots_cur_2() %}
  {{ return(adapter.dispatch('recovery_rds_db_snapshots_cur_2')()) }}
{% endmacro %}

{% macro default__recovery_rds_db_snapshots_cur_2() %}{% endmacro %}

{% macro postgres__recovery_rds_db_snapshots_cur_2() %}
with rds_db_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_product_code = 'Amazon RDS'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'rds_db_snapshots' as resource_type
from aws_rds_db_snapshots as ardbs
inner join rds_db_snapshots_cost as rdbsc
on ardbs.arn = rdbsc.resource_id
{% endmacro %}

{% macro snowflake__recovery_rds_db_snapshots_cur_2() %}

{% endmacro %}