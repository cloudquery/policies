{% macro instances_should_have_patch_compliance_status_of_compliant(framework, check_id) %}
  {{ return(adapter.dispatch('instances_should_have_patch_compliance_status_of_compliant')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__instances_should_have_patch_compliance_status_of_compliant(framework, check_id) %}
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

{% macro postgres__instances_should_have_patch_compliance_status_of_compliant(framework, check_id) %}
with patch_compliance_status_groups as(
    select DISTINCT
        instance_arn,
        status
    from
        aws_ssm_instance_compliance_items
    where
        compliance_type = 'Patch'
)
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon EC2 instances managed by Systems Manager should have a patch compliance status of COMPLIANT after a patch installation' as title,
    aws_ssm_instances.account_id,
    aws_ssm_instances.arn,
    case when
        patch_compliance_status_groups.status is distinct from 'COMPLIANT'
     then 'fail' else 'pass' end as status
 from
     aws_ssm_instances
INNER join patch_compliance_status_groups 
    on aws_ssm_instances.arn = patch_compliance_status_groups.instance_arn{% endmacro %}
