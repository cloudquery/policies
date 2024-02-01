{% macro iam_root_last_used(framework, check_id) %}
  {{ return(adapter.dispatch('iam_root_last_used')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_root_last_used(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_root_last_used(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Eliminate use of the ''root'' user for administrative and daily tasks' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case 
    when password_last_used <= (current_date - interval '90' day) then 'fail'
    when access_key_1_last_used_date <= (current_date - interval '90' day) then 'fail'
    when access_key_2_last_used_date <= (current_date - interval '90' day) then 'fail'
      else 'pass'
  end as status
  from aws_iam_credential_reports
{% endmacro %}

{% macro snowflake__iam_root_last_used(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Eliminate use of the ''root'' user for administrative and daily tasks' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case 
    when password_last_used <= (CURRENT_DATE() - INTERVAL '90 day') then 'fail'
    when access_key_1_last_used_date <= (CURRENT_DATE() - INTERVAL '90 day') then 'fail'
    when access_key_2_last_used_date <= (CURRENT_DATE() - INTERVAL '90 day') then 'fail'
      else 'pass'
  end as status
  from aws_iam_credential_reports
{% endmacro %}

{% macro bigquery__iam_root_last_used(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Eliminate use of the "root" user for administrative and daily tasks' as title,
  SPLIT(arn, ':')[offset(4)] as account_id,
  arn as resource_id,
  case 
    when password_last_used <= (CURRENT_TIMESTAMP() - INTERVAL 90 DAY) then 'fail'
    when access_key_1_last_used_date <= (CURRENT_TIMESTAMP() - INTERVAL 90 DAY) then 'fail'
    when access_key_2_last_used_date <= (CURRENT_TIMESTAMP() - INTERVAL 90 DAY) then 'fail'
      else 'pass'
  end as status
  from {{ full_table_name("aws_iam_credential_reports") }}
{% endmacro %}


