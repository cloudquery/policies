{% macro instances_should_be_configured_to_copy_tags_to_snapshots(framework, check_id) %}
  {{ return(adapter.dispatch('instances_should_be_configured_to_copy_tags_to_snapshots')(framework, check_id)) }}
{% endmacro %}

{% macro default__instances_should_be_configured_to_copy_tags_to_snapshots(framework, check_id) %}{% endmacro %}

{% macro postgres__instances_should_be_configured_to_copy_tags_to_snapshots(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should be configured to copy tags to snapshots' as title,
    account_id,
    arn AS resource_id,
    case when copy_tags_to_snapshot != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro snowflake__instances_should_be_configured_to_copy_tags_to_snapshots(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should be configured to copy tags to snapshots' as title,
    account_id,
    arn AS resource_id,
    case when copy_tags_to_snapshot != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}