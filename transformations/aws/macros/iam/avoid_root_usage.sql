{% macro avoid_root_usage(framework, check_id) %}
  {{ return(adapter.dispatch('avoid_root_usage')(framework, check_id)) }}
{% endmacro %}

{% macro default__avoid_root_usage(framework, check_id) %}{% endmacro %}

{% macro postgres__avoid_root_usage(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Avoid the use of "root" account. Show used in last 30 days (Scored)' as title,
  account_id,
  arn as resource_id,
  case when
    user_name = '<root_account>' and password_last_used > (now() - '30 days'::INTERVAL)
    then 'fail'
    else 'pass'
  end as status
from aws_iam_users
{% endmacro %}

{% macro bigquery__avoid_root_usage(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Avoid the use of "root" account. Show used in last 30 days (Scored)' as title,
  account_id,
  arn as resource_id,
  case when
    user_name = '<root_account>' and password_last_used > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_iam_users") }}
{% endmacro %}