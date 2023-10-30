{% macro target_groups_unused(framework, check_id) %}
  {{ return(adapter.dispatch('target_groups_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__target_groups_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__target_groups_unused(framework, check_id) %}
select
       '{{framework}}'              as framework,
       '{{check_id}}'               as check_id,
       'Unused ELB target group' as title,
       account_id,
       arn                       as resource_id,
       'fail'                    as status
from aws_elbv2_target_groups
where COALESCE(array_length(load_balancer_arns, 1), 0) = 0{% endmacro %}
