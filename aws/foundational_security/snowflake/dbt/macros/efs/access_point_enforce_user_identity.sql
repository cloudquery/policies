{% macro access_point_enforce_user_identity(framework, check_id) %}
insert into aws_policy_results
SELECT 
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