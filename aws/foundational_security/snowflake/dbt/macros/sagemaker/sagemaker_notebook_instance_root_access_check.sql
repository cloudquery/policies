{% macro sagemaker_notebook_instance_root_access_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Users should not have root access to SageMaker notebook instances' as title,
    account_id,
    arn as resource_id,
    case when
        root_access = 'Disabled'
        then 'pass' else 'fail' end as status
from aws_sagemaker_notebook_instances
{% endmacro %}