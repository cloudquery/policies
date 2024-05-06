{% macro users_with_two_active_access_keys(framework, check_id) %}
  {{ return(adapter.dispatch('users_with_two_active_access_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__users_with_two_active_access_keys(framework, check_id) %}{% endmacro %}

{% macro postgres__users_with_two_active_access_keys(framework, check_id) %}
select
       '{{framework}}' as framework,
       '{{check_id}}' as check_id,
       'Ensure there is only one active access key available for any single IAM user (Automated)' as title,
       account_id,
       user_arn,
       case
           when
                   count(*) > 1
               then 'fail'
           else 'pass'
           end
from aws_iam_user_access_keys
where status = 'Active'
group by account_id, user_arn{% endmacro %}

{% macro snowflake__users_with_two_active_access_keys(framework, check_id) %}
select
       '{{framework}}' as framework,
       '{{check_id}}' as check_id,
       'Ensure there is only one active access key available for any single IAM user (Automated)' as title,
       account_id,
       user_arn,
       case
           when
                   count(*) > 1
               then 'fail'
           else 'pass'
           end
from aws_iam_user_access_keys
where status = 'Active'
group by account_id, user_arn
{% endmacro %}

{% macro bigquery__users_with_two_active_access_keys(framework, check_id) %}
select
       '{{framework}}' as framework,
       '{{check_id}}' as check_id,
       'Ensure there is only one active access key available for any single IAM user (Automated)' as title,
       account_id,
       user_arn,
       case
           when
                   count(*) > 1
               then 'fail'
           else 'pass'
           end
from {{ full_table_name("aws_iam_user_access_keys") }}
where status = 'Active'
group by account_id, user_arn
{% endmacro %}

{% macro athena__users_with_two_active_access_keys(framework, check_id) %}
select
       '{{framework}}' as framework,
       '{{check_id}}' as check_id,
       'Ensure there is only one active access key available for any single IAM user (Automated)' as title,
       account_id,
       user_arn,
       case
           when
                   count(*) > 1
               then 'fail'
           else 'pass'
           end
from aws_iam_user_access_keys
where status = 'Active'
group by account_id, user_arn
{% endmacro %}