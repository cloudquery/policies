{% macro disks_unused(framework, check_id) %}
  {{ return(adapter.dispatch('disks_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__disks_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__disks_unused(framework, check_id) %}
select
       '{{framework}}'             as framework,
       '{{check_id}}'              as check_id,
       'Unused Lightsail disks' as title,
       account_id,
       arn                      as resource_id,
       'fail'                   as status
from aws_lightsail_disks
where is_attached = false{% endmacro %}
