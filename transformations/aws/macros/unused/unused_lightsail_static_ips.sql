{% macro unused_lightsail_static_ips(framework, check_id) %}
  {{ return(adapter.dispatch('unused_lightsail_static_ips')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_lightsail_static_ips(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_lightsail_static_ips(framework, check_id) %}
select 
       si.account_id,
       si.arn                           as resource_id,
       rbc.cost
from aws_lightsail_static_ips si
JOIN {{ ref('aws_cost__by_resources') }} rbc ON si.arn = rbc.line_item_resource_id
where si.is_attached = false
{% endmacro %}

{% macro snowflake__unused_lightsail_static_ips(framework, check_id) %}
{% endmacro %}