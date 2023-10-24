{% macro instances_with_more_than_2_network_interfaces(framework, check_id) %}
insert into aws_policy_results
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