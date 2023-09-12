#sagemaker.1
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

#sagemaker.2
SAGEMAKER_NOTEBOOK_INSTANCE_INSIDE_VPC = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'SageMaker notebook instances should be launched in a custom VPC' as title,
    account_id,
    arn as resource_id,
    case when
        subnet_id is not null
        then 'pass' else 'fail' end as status
from aws_sagemaker_notebook_instances
"""

#sagemaker.3
SAGEMAKER_NOTEBOOK_INSTANCE_ROOT_ACCESS_CHECK = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Users should not have root access to SageMaker notebook instances' as title,
    account_id,
    arn as resource_id,
    case when
        root_access = 'Disabled'
        then 'pass' else 'fail' end as status
from aws_sagemaker_notebook_instances
"""