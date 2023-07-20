
SAGEMAKER_NOTEBOOK_INSTANCE_DIRECT_INTERNET_ACCESS_DISABLED = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'Amazon SageMaker notebook instances should not have direct internet access' as title,
    account_id,
    arn as resource_id,
    case when
        direct_internet_access = 'Enabled'
    then 'fail' else 'pass' end as status
from aws_sagemaker_notebook_instances
"""