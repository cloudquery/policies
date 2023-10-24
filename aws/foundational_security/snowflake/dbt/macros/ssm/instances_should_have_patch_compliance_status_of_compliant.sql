{% macro instances_should_have_patch_compliance_status_of_compliant(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 instances managed by Systems Manager should have a patch compliance status of COMPLIANT after a patch installation' as title,
    aws_ssm_instances.account_id,
    aws_ssm_instances.arn,
    case when
        aws_ssm_instance_compliance_items.compliance_type = 'Patch'
        and aws_ssm_instance_compliance_items.status is distinct from 'COMPLIANT'
    then 'fail' else 'pass' end as status
from
    aws_ssm_instances
inner join aws_ssm_instance_compliance_items on aws_ssm_instances.arn = aws_ssm_instance_compliance_items.instance_arn
{% endmacro %}