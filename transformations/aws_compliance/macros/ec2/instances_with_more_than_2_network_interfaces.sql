{% macro instances_with_more_than_2_network_interfaces(framework, check_id) %}
  {{ return(adapter.dispatch('instances_with_more_than_2_network_interfaces')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__instances_with_more_than_2_network_interfaces(framework, check_id) %}
with data as (
    select account_id, instance_id, COUNT(nics.value:Status) as cnt
    from aws_ec2_instances, lateral flatten(input => parse_json(aws_ec2_instances.network_interfaces), OUTER => TRUE) as nics
    group by account_id, instance_id
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EC2 instances should not use multiple ENIs' as title,
    account_id,
    instance_id as resource_id,
    case when cnt > 1 then 'fail' else 'pass' end as status
from data
{% endmacro %}

{% macro postgres__instances_with_more_than_2_network_interfaces(framework, check_id) %}
with data as (
    select account_id, instance_id, COUNT(nics->>'Status') as cnt
    from aws_ec2_instances left join jsonb_array_elements(aws_ec2_instances.network_interfaces) as nics on true
group by account_id, instance_id
)
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'EC2 instances should not use multiple ENIs' as title,
    account_id,
    instance_id as resource_id,
    case when cnt > 1 then 'fail' else 'pass' end as status
from data
{% endmacro %}
