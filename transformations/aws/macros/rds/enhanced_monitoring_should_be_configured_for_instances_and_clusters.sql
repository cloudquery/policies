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

{% macro bigquery__enhanced_monitoring_should_be_configured_for_instances_and_clusters(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Enhanced monitoring should be configured for RDS DB instances and clusters' as title,
    account_id,
    arn AS resource_id,
    case when enhanced_monitoring_resource_arn is null then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_instances") }}
{% endmacro %}

{% macro athena__enhanced_monitoring_should_be_configured_for_instances_and_clusters(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Enhanced monitoring should be configured for RDS DB instances and clusters' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN enhanced_monitoring_resource_arn IS NULL THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_rds_instances
{% endmacro %}