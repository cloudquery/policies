{% macro sagemaker_notebook_instance_direct_internet_access_disabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon SageMaker notebook instances should not have direct internet access' as title,
    account_id,
    arn as resource_id,
    case when
        direct_internet_access = 'Enabled'
    then 'fail' else 'pass' end as status
from aws_sagemaker_notebook_instances
{% endmacro %}