{% macro ec2_instances_should_be_managed_by_ssm(framework, check_id) %}
  {{ return(adapter.dispatch('ec2_instances_should_be_managed_by_ssm')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__ec2_instances_should_be_managed_by_ssm(framework, check_id) %}
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

{% macro postgres__ec2_instances_should_be_managed_by_ssm(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
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

{% macro default__ec2_instances_should_be_managed_by_ssm(framework, check_id) %}{% endmacro %}

{% macro bigquery__ec2_instances_should_be_managed_by_ssm(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon EC2 instances should be managed by AWS Systems Manager' as title,
    aws_ec2_instances.account_id,
    aws_ec2_instances.arn as resource_id,
    case when
        aws_ssm_instances.instance_id is null
    then 'fail' else 'pass' end as status
from
    {{ full_table_name("aws_ec2_instances") }}
left outer join {{ full_table_name("aws_ssm_instances") }} on aws_ec2_instances.instance_id = aws_ssm_instances.instance_id
{% endmacro %}

{% macro athena__ec2_instances_should_be_managed_by_ssm(framework, check_id) %}
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