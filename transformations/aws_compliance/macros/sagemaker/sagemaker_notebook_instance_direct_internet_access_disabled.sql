{% macro sagemaker_notebook_instance_direct_internet_access_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('sagemaker_notebook_instance_direct_internet_access_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__sagemaker_notebook_instance_direct_internet_access_disabled(framework, check_id) %}
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

{% macro postgres__sagemaker_notebook_instance_direct_internet_access_disabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon SageMaker notebook instances should not have direct internet access' as title,
    account_id,
    arn as resource_id,
    case when
        direct_internet_access = 'Enabled'
    then 'fail' else 'pass' end as status
from aws_sagemaker_notebook_instances
{% endmacro %}
