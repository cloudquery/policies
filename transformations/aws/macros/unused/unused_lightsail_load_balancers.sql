{% macro unused_lightsail_load_balancers(framework, check_id) %}
  {{ return(adapter.dispatch('unused_lightsail_load_balancers')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_lightsail_load_balancers(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_lightsail_load_balancers(framework, check_id) %}
select 
       lb.account_id,
       lb.arn                               as resource_id,
       rbc.cost,
       'lightsail_load_balancers' as resource_type
from aws_lightsail_load_balancers lb
JOIN {{ ref('aws_cost__by_resources') }} rbc ON lb.arn = rbc.line_item_resource_id
where coalesce(jsonb_array_length(lb.instance_health_summary), 0) = 0
{% endmacro %}

{% macro snowflake__unused_lightsail_load_balancers(framework, check_id) %}
{% endmacro %}