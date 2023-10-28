{% macro static_ips_unused(framework, check_id) %}
  {{ return(adapter.dispatch('static_ips_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__static_ips_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__static_ips_unused(framework, check_id) %}
select
       '{{framework}}'                  as framework,
       '{{check_id}}'                   as check_id,
       'Unused Lightsail static IPs' as title,
       account_id,
       arn                           as resource_id,
       'fail'                        as status
from aws_lightsail_static_ips
where is_attached = false{% endmacro %}
