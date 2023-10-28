{% macro security_groups_unused(framework, check_id) %}
  {{ return(adapter.dispatch('security_groups_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_groups_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__security_groups_unused(framework, check_id) %}
with interface_groups as (
    select distinct a->>'GroupId' as group_id from aws_ec2_instances, jsonb_array_elements(security_groups) as a
)
select
       '{{framework}}'                as framework,
       '{{check_id}}'                 as check_id,
       'Unused EC2 security group' as title,
       sg.account_id,
       sg.arn                      as resource_id,
       'fail'                      as status
from aws_ec2_security_groups sg
         left join interface_groups on interface_groups.group_id = sg.group_id
where interface_groups.group_id is null;
{% endmacro %}
