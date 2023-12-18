{% macro unused_ec2_images(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_images')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_images(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_images(framework, check_id) %}
select 
       i.account_id,
       i.arn                    as resource_id,
       rbc.cost
from aws_ec2_images i
JOIN {{ ref('aws_cost__by_resources') }} rbc ON i.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(i.block_device_mappings), 0) = 0
{% endmacro %}

{% macro snowflake__unused_ec2_images(framework, check_id) %}

{% endmacro %}