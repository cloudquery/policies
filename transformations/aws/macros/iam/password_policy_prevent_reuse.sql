{% macro password_policy_prevent_reuse(framework, check_id) %}
  {{ return(adapter.dispatch('password_policy_prevent_reuse')(framework, check_id)) }}
{% endmacro %}

{% macro default__password_policy_prevent_reuse(framework, check_id) %}{% endmacro %}

{% macro postgres__password_policy_prevent_reuse(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure IAM password policy prevents password reuse' as title,
  account_id,
  account_id,
  case when
    password_reuse_prevention is distinct from 24
    then 'fail'
    else 'pass'
  end
from
    aws_iam_password_policies
{% endmacro %}
