{% macro ec2_instances_should_be_managed_by_ssm(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 instances should be managed by AWS Systems Manager' as title,
    aws_ec2_instances.account_id,
    aws_ec2_instances.arn as resource_id,
    case when
        aws_ssm_instances.instance_id is null
    then 'fail' else 'pass' end as status
from
    aws_ec2_instances
left outer join aws_ssm_instances on aws_ec2_instances.instance_id = aws_ssm_instances.instance_id
{% endmacro %}