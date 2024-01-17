{% macro enhanced_monitoring_should_be_configured_for_instances_and_clusters(framework, check_id) %}
  {{ return(adapter.dispatch('enhanced_monitoring_should_be_configured_for_instances_and_clusters')(framework, check_id)) }}
{% endmacro %}

{% macro default__enhanced_monitoring_should_be_configured_for_instances_and_clusters(framework, check_id) %}{% endmacro %}

{% macro postgres__enhanced_monitoring_should_be_configured_for_instances_and_clusters(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Enhanced monitoring should be configured for RDS DB instances and clusters' as title,
    account_id,
    arn AS resource_id,
    case when enhanced_monitoring_resource_arn is null then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro snowflake__enhanced_monitoring_should_be_configured_for_instances_and_clusters(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Enhanced monitoring should be configured for RDS DB instances and clusters' as title,
    account_id,
    arn AS resource_id,
    case when enhanced_monitoring_resource_arn is null then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}