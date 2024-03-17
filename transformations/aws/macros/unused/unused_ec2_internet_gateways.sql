{% macro unused_ec2_internet_gateways(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_internet_gateways')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_internet_gateways(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_internet_gateways(framework, check_id) %}
select 
       ig.account_id,
       ig.arn                       as resource_id,
       rbc.cost,
       'ec2_internet_gateways' as resource_type
from aws_ec2_internet_gateways ig
JOIN {{ ref('aws_cost__by_resources') }} rbc ON ig.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(ig.attachments), 0) = 0
{% endmacro %}

{% macro snowflake__unused_ec2_internet_gateways(framework, check_id) %}

{% endmacro %}