
SAGEMAKER_NOTEBOOK_INSTANCE_DIRECT_INTERNET_ACCESS_DISABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon SageMaker notebook instances should not have direct internet access' as title,
    account_id,
    arn as resource_id,
    case when
        direct_internet_access = 'Enabled'
    then 'fail' else 'pass' end as status
from aws_sagemaker_notebook_instances
"""