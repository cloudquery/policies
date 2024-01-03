{% macro redshift_cluster_kms_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('redshift_cluster_kms_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__redshift_cluster_kms_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__redshift_cluster_kms_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Redshift clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN encrypted AND kms_key_id is not null THEN 'pass'
    ELSE 'fail'
    END AS status
from aws_redshift_clusters
{% endmacro %}

{% macro snowflake__redshift_cluster_kms_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Redshift clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN encrypted AND kms_key_id is not null THEN 'pass'
    ELSE 'fail'
    END AS status
from aws_redshift_clusters
{% endmacro %}