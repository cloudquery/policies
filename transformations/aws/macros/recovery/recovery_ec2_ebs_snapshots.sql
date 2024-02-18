{% macro recovery_ec2_ebs_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('recovery_ec2_ebs_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__recovery_ec2_ebs_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__recovery_ec2_ebs_snapshots(framework, check_id) %}
with ec2_ebs_snapshots_cost as (
SELECT line_item_resource_id as resource_id, SUM(line_item_unblended_cost) as unblended_cost
FROM {{ var('cost_usage_table') }}
WHERE product_product_name = 'Amazon Elastic Block Store'
GROUP BY line_item_resource_id
) 
SELECT
    account_id,
    arn as resource_id,
    unblended_cost as cost,
    'ec2_ebs_snapshots' as resource_type
from aws_ec2_ebs_snapshots as aees
inner join ec2_ebs_snapshots_cost as eesc
on aees.arn = eesc.resource_id
{% endmacro %}

{% macro snowflake__recovery_ec2_ebs_snapshots(framework, check_id) %}

{% endmacro %}