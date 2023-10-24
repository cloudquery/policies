{% macro sagemaker_notebook_instance_inside_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'SageMaker notebook instances should be launched in a custom VPC' as title,
    account_id,
    arn as resource_id,
    case when
        subnet_id is not null
        then 'pass' else 'fail' end as status
from aws_sagemaker_notebook_instances
{% endmacro %}