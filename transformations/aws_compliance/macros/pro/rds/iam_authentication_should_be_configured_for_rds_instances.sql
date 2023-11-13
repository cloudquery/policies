{% macro iam_authentication_should_be_configured_for_rds_instances(framework, check_id) %}
  {{ return(adapter.dispatch('iam_authentication_should_be_configured_for_rds_instances')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__iam_authentication_should_be_configured_for_rds_instances(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM authentication should be configured for RDS instances' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro postgres__iam_authentication_should_be_configured_for_rds_instances(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM authentication should be configured for RDS instances' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled is not TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}
