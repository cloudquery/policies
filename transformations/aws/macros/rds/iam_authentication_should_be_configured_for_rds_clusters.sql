{% macro iam_authentication_should_be_configured_for_rds_clusters(framework, check_id) %}
  {{ return(adapter.dispatch('iam_authentication_should_be_configured_for_rds_clusters')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__iam_authentication_should_be_configured_for_rds_clusters(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM authentication should be configured for RDS clusters' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}

{% macro postgres__iam_authentication_should_be_configured_for_rds_clusters(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM authentication should be configured for RDS clusters' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled is not TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}

{% macro default__iam_authentication_should_be_configured_for_rds_clusters(framework, check_id) %}{% endmacro %}

{% macro bigquery__iam_authentication_should_be_configured_for_rds_clusters(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM authentication should be configured for RDS clusters' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_clusters") }}
{% endmacro %}

{% macro athena__iam_authentication_should_be_configured_for_rds_clusters(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM authentication should be configured for RDS clusters' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN iam_database_authentication_enabled = TRUE THEN 'pass'
        ELSE 'fail'
    END AS status
FROM aws_rds_clusters
{% endmacro %}