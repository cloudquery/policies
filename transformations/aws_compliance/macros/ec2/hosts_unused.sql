{% macro hosts_unused(framework, check_id) %}
  {{ return(adapter.dispatch('hosts_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__hosts_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__hosts_unused(framework, check_id) %}
select
       '{{framework}}'            as framework,
       '{{check_id}}'             as check_id,
       'Unused dedicated host' as title,
       account_id,
       arn                     as resource_id,
       'fail'                  as status
from aws_ec2_hosts
where coalesce(jsonb_array_length(instances), 0) = 0
{% endmacro %}
