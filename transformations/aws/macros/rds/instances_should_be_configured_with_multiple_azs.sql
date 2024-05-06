{% macro instances_should_be_configured_with_multiple_azs(framework, check_id) %}
  {{ return(adapter.dispatch('instances_should_be_configured_with_multiple_azs')(framework, check_id)) }}
{% endmacro %}

{% macro default__instances_should_be_configured_with_multiple_azs(framework, check_id) %}{% endmacro %}

{% macro postgres__instances_should_be_configured_with_multiple_azs(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should be configured with multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro snowflake__instances_should_be_configured_with_multiple_azs(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should be configured with multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro bigquery__instances_should_be_configured_with_multiple_azs(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should be configured with multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az != TRUE then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_instances") }}
{% endmacro %}

{% macro athena__instances_should_be_configured_with_multiple_azs(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'RDS DB instances should be configured with multiple Availability Zones' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN multi_az = TRUE THEN 'pass'
        ELSE 'fail'
    END AS status
FROM aws_rds_instances
{% endmacro %}