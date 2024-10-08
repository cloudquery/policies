{% macro clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_be_configured_for_multiple_availability_zones')(framework, check_id)) }}
{% endmacro %}

{% macro default__clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}{% endmacro %}

{% macro postgres__clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}

{% macro snowflake__clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}

{% macro bigquery__clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_clusters") }}
{% endmacro %}

{% macro athena__clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN multi_az = TRUE THEN 'pass' 
        ELSE 'fail' 
    END AS status
FROM aws_rds_clusters
{% endmacro %}