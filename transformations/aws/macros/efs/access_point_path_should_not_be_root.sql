{% macro access_point_path_should_not_be_root(framework, check_id) %}
  {{ return(adapter.dispatch('access_point_path_should_not_be_root')(framework, check_id)) }}
{% endmacro %}

{% macro default__access_point_path_should_not_be_root(framework, check_id) %}{% endmacro %}

{% macro postgres__access_point_path_should_not_be_root(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EFS access points should enforce a root directory' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN root_directory->>'Path' = '/' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_efs_access_points
{% endmacro %}

{% macro snowflake__access_point_path_should_not_be_root(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EFS access points should enforce a root directory' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN root_directory:Path::STRING = '/' THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    aws_efs_access_points
{% endmacro %}