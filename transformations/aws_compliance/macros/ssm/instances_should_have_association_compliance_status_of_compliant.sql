{% macro instances_should_have_association_compliance_status_of_compliant(framework, check_id) %}
  {{ return(adapter.dispatch('instances_should_have_association_compliance_status_of_compliant')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__instances_should_have_association_compliance_status_of_compliant(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 instances managed by Systems Manager should have an association compliance status of COMPLIANT' as title,
    aws_ssm_instances.account_id,
    aws_ssm_instances.arn,
    case when
        aws_ssm_instance_compliance_items.compliance_type = 'Association'
        and aws_ssm_instance_compliance_items.status is distinct from 'COMPLIANT'
    then 'fail' else 'pass' end as status
from
    aws_ssm_instances
inner join aws_ssm_instance_compliance_items on aws_ssm_instances.arn = aws_ssm_instance_compliance_items.instance_arn
{% endmacro %}

{% macro postgres__instances_should_have_association_compliance_status_of_compliant(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon EC2 instances managed by Systems Manager should have an association compliance status of COMPLIANT' as title,
    aws_ssm_instances.account_id,
    aws_ssm_instances.arn,
    case when
        aws_ssm_instance_compliance_items.compliance_type = 'Association'
        and aws_ssm_instance_compliance_items.status is distinct from 'COMPLIANT'
    then 'fail' else 'pass' end as status
from
    aws_ssm_instances
inner join aws_ssm_instance_compliance_items on aws_ssm_instances.arn = aws_ssm_instance_compliance_items.instance_arn
{% endmacro %}
