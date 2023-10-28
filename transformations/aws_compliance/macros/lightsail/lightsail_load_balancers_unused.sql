{% macro lightsail_load_balancers_unused(framework, check_id) %}
  {{ return(adapter.dispatch('lightsail_load_balancers_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__lightsail_load_balancers_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__lightsail_load_balancers_unused(framework, check_id) %}
select
       '{{framework}}'                      as framework,
       '{{check_id}}'                       as check_id,
       'Unused Lightsail load balancers' as title,
       account_id,
       arn                               as resource_id,
       'fail'                            as status
from aws_lightsail_load_balancers
where coalesce(jsonb_array_length(instance_health_summary), 0) = 0
{% endmacro %}
