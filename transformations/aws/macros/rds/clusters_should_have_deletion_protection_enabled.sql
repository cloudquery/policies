{% macro clusters_should_have_deletion_protection_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_have_deletion_protection_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__clusters_should_have_deletion_protection_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__clusters_should_have_deletion_protection_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}

{% macro snowflake__clusters_should_have_deletion_protection_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}

{% macro bigquery__clusters_should_have_deletion_protection_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_clusters") }}
{% endmacro %}