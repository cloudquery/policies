{% macro password_policy_min_number(framework, check_id) %}
  {{ return(adapter.dispatch('password_policy_min_number')(framework, check_id)) }}
{% endmacro %}

{% macro default__password_policy_min_number(framework, check_id) %}{% endmacro %}

{% macro postgres__password_policy_min_number(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy requires at least one number' as title,
  account_id,
  account_id,
  case when
    require_numbers = FALSE or policy_exists = FALSE
    then 'fail'
    else 'pass'
  end as status
from
    aws_iam_password_policies

{% endmacro %}
