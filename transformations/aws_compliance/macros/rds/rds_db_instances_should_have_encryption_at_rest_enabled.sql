{% macro rds_db_instances_should_have_encryption_at_rest_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('rds_db_instances_should_have_encryption_at_rest_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_db_instances_should_have_encryption_at_rest_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_db_instances_should_have_encryption_at_rest_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS DB instances should have encryption at rest enabled' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted is not TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}
