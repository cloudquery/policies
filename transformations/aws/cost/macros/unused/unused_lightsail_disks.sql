{% macro unused_lightsail_disks(framework, check_id) %}
  {{ return(adapter.dispatch('unused_lightsail_disks')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_lightsail_disks(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_lightsail_disks(framework, check_id) %}
select 
       d.account_id,
       d.arn                      as resource_id,
       rbc.cost,
       'lightsail_disks' as resource_type
from aws_lightsail_disks d
JOIN {{ ref('aws_cost__by_resources') }} rbc ON d.arn = rbc.line_item_resource_id
where d.is_attached = false
{% endmacro %}

{% macro snowflake__unused_lightsail_disks(framework, check_id) %}
{% endmacro %}