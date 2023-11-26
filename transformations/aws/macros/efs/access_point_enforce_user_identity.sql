{% macro access_point_enforce_user_identity(framework, check_id) %}
  {{ return(adapter.dispatch('access_point_enforce_user_identity')(framework, check_id)) }}
{% endmacro %}

{% macro default__access_point_enforce_user_identity(framework, check_id) %}{% endmacro %}

{% macro snowflake__access_point_enforce_user_identity(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EFS access points should enforce a user identity' as title,
    account_id,
    arn as resource_id,
    CASE
      WHEN posix_user IS NULL 
        OR posix_user:uid::STRING IS NULL
        OR posix_user:gid::STRING IS NULL
      THEN 'fail'
      ELSE 'pass'
    END as status
FROM 
    aws_efs_access_points
{% endmacro %}

{% macro bigquery__(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EFS access points should enforce a user identity' as title,
    account_id,
    arn as resource_id,
    CASE
      WHEN posix_user IS NULL 
        OR CAST(JSON_VALUE(posix_user.uid) AS STRING) IS NULL
        OR CAST(JSON_VALUE(posix_user.gid) AS STRING) IS NULL
      THEN 'fail'
      ELSE 'pass'
    END as status
FROM 
    {{ full_table_name("aws_efs_access_points") }}
{% endmacro %}