{% macro network_acls_unused(framework, check_id) %}
  {{ return(adapter.dispatch('network_acls_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__network_acls_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__network_acls_unused(framework, check_id) %}
select
       '{{framework}}'                         as framework,
       '{{check_id}}'                          as check_id,
       'Unused network access control list' as title,
       account_id,
       arn                                  as resource_id,
       'fail'                               as status
from aws_ec2_network_acls
where coalesce(jsonb_array_length(associations), 0) = 0
{% endmacro %}
