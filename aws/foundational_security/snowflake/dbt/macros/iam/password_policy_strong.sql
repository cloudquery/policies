{% macro password_policy_strong(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
  'Password policies for IAM users should have strong configurations' AS title,
  account_id,
  account_id AS resource_id,
  CASE 
    WHEN (
        require_uppercase_characters != TRUE
        OR require_lowercase_characters != TRUE
        OR require_numbers != TRUE
        OR minimum_password_length < 14
        OR password_reuse_prevention IS NULL
        OR max_password_age IS NULL
        OR policy_exists != TRUE
    )
    THEN 'fail' 
    ELSE 'pass' 
  END AS status
FROM aws_iam_password_policies
{% endmacro %}