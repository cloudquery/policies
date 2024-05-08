{% macro password_policy_min_uppercase(framework, check_id) %}
  {{ return(adapter.dispatch('password_policy_min_uppercase')(framework, check_id)) }}
{% endmacro %}

{% macro default__password_policy_min_uppercase(framework, check_id) %}{% endmacro %}

{% macro postgres__password_policy_min_uppercase(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires at least one uppercase letter' as title,
  account_id,
  account_id,
  case when
    require_uppercase_characters is not true or policy_exists is not true
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}

{% macro bigquery__password_policy_min_uppercase(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires at least one uppercase letter' as title,
  account_id,
  account_id,
  case when
    require_uppercase_characters is not true or policy_exists is not true
    then 'fail'
    else 'pass'
  end
from
    {{ full_table_name("aws_iam_password_policies") }}
{% endmacro %}

{% macro snowflake__password_policy_min_uppercase(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires at least one uppercase letter' as title,
  account_id,
  account_id,
  case when
    not require_uppercase_characters or not policy_exists
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}

{% macro athena__password_policy_min_uppercase(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Ensure IAM password policy requires at least one uppercase letter' AS title,
    account_id,
    account_id AS resource_id,
    CASE 
        WHEN require_uppercase_characters = FALSE OR policy_exists = FALSE
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_password_policies
{% endmacro %}
