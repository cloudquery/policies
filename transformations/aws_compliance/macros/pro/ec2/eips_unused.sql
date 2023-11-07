{% macro eips_unused(framework, check_id) %}
  {{ return(adapter.dispatch('eips_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__eips_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__eips_unused(framework, check_id) %}
select
       '{{framework}}'      as framework,
       '{{check_id}}'       as check_id,
       'Unused EC2 EIP'  as title,
       account_id,
       allocation_id     as resource_id,
       'fail'            as status
from aws_ec2_eips
where association_id is null
{% endmacro %}
