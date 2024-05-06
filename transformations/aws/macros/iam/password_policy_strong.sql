{% macro password_policy_strong(framework, check_id) %}
  {{ return(adapter.dispatch('password_policy_strong')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__password_policy_strong(framework, check_id) %}
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

{% macro postgres__password_policy_strong(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Password policies for IAM users should have strong configurations' as title,
    account_id,
    account_id AS resource_id,
    case when
        (
            require_uppercase_characters is not TRUE
            or require_lowercase_characters is not TRUE
            or require_numbers is not TRUE
            or minimum_password_length < 14
            or password_reuse_prevention is null
            or max_password_age is null
            or policy_exists is not TRUE
        )
    then 'fail' else 'pass' end as status
from aws_iam_password_policies
{% endmacro %}

{% macro default__password_policy_strong(framework, check_id) %}{% endmacro %}
                    
{% macro bigquery__password_policy_strong(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Password policies for IAM users should have strong configurations' as title,
    account_id,
    account_id AS resource_id,
    case when
        (
            require_uppercase_characters is not TRUE
            or require_lowercase_characters is not TRUE
            or require_numbers is not TRUE
            or minimum_password_length < 14
            or password_reuse_prevention is null
            or max_password_age is null
            or policy_exists is not TRUE
        )
    then 'fail' else 'pass' end as status
from {{ full_table_name("aws_iam_password_policies") }}
{% endmacro %}

{% macro athena__password_policy_strong(framework, check_id) %}
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
