{% macro old_access_keys(framework, check_id) %}
  {{ return(adapter.dispatch('old_access_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__old_access_keys(framework, check_id) %}{% endmacro %}

{% macro postgres__old_access_keys(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access keys are rotated every 90 days or less' as title,
  account_id,
  user_arn,
  case when
    last_rotated < (now() - '90 days'::INTERVAL)
    then 'fail'
    else 'pass'
  end
from aws_iam_user_access_keys
{% endmacro %}
