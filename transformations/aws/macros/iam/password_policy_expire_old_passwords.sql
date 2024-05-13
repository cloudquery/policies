{% macro password_policy_expire_old_passwords(framework, check_id) %}
  {{ return(adapter.dispatch('password_policy_expire_old_passwords')(framework, check_id)) }}
{% endmacro %}

{% macro default__password_policy_expire_old_passwords(framework, check_id) %}{% endmacro %}

{% macro postgres__password_policy_expire_old_passwords(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy expires passwords within 90 days or less' as title,
  account_id,
  account_id,
  case when
    (max_password_age is null or max_password_age > 90) or policy_exists = false
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}

{% macro bigquery__password_policy_expire_old_passwords(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy expires passwords within 90 days or less' as title,
  account_id,
  account_id,
  case when
    (max_password_age is null or max_password_age > 90) or policy_exists = false
    then 'fail'
    else 'pass'
  end
from
    {{ full_table_name("aws_iam_password_policies") }}
{% endmacro %}

{% macro snowflake__password_policy_expire_old_passwords(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy expires passwords within 90 days or less' as title,
  account_id,
  account_id,
  case when
    (max_password_age is null or max_password_age > 90) or policy_exists = false
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}

{% macro athena__password_policy_expire_old_passwords(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Ensure IAM password policy expires passwords within 90 days or less' AS title,
    account_id,
    account_id AS resource_id,
    CASE 
        WHEN max_password_age IS NULL OR max_password_age > 90 OR policy_exists = FALSE
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_password_policies
{% endmacro %}
