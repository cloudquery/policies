{% macro unused_ec2_hosts(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_hosts')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_hosts(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_hosts(framework, check_id) %}
select 
       h.account_id,
       h.arn                     as resource_id,
       rbc.cost,
       'ec2_hosts' as resource_type
from aws_ec2_hosts h
JOIN {{ ref('aws_cost__by_resources') }} rbc ON h.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(h.instances), 0) = 0
{% endmacro %}

{% macro snowflake__unused_ec2_hosts(framework, check_id) %}

{% endmacro %}