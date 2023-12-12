{% macro password_policy_min_length(framework, check_id) %}
  {{ return(adapter.dispatch('password_policy_min_length')(framework, check_id)) }}
{% endmacro %}

{% macro default__password_policy_min_length(framework, check_id) %}{% endmacro %}

{% macro postgres__password_policy_min_length(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires minimum length of 14 or greater' as title,
  account_id,
  account_id,
  case when
    (minimum_password_length < 14) or policy_exists = FALSE
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}

{% macro bigquery__password_policy_min_length(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires minimum length of 14 or greater' as title,
  account_id,
  account_id,
  case when
    (minimum_password_length < 14) or policy_exists = FALSE
    then 'fail'
    else 'pass'
  end
from
    {{ full_table_name("aws_iam_password_policies") }}
{% endmacro %}

{% macro snowflake__password_policy_min_length(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires minimum length of 14 or greater' as title,
  account_id,
  account_id,
  case when
    (minimum_password_length < 14) or policy_exists = FALSE
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}