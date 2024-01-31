{% macro iam_user_access_keys_and_password_at_setup(framework, check_id) %}
  {{ return(adapter.dispatch('iam_user_access_keys_and_password_at_setup')(framework, check_id)) }}
{% endmacro %}

{% macro postgres__iam_user_access_keys_and_password_at_setup(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Do not setup access keys during initial user setup for all IAM
users that have a console password' as title,
  -- Failed when password is enabled and the key was created within 10 seconds of the user
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case when
    password_enabled = 'TRUE' 
    and
    (
        access_key_1_last_rotated - user_creation_time < '10 SECOND'::interval
        or 
        access_key_2_last_rotated - user_creation_time < '10 SECOND'::interval
    )
    then 'fail'
    else 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}

{% macro snowflake__iam_user_access_keys_and_password_at_setup(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Do not setup access keys during initial user setup for all IAM
users that have a console password' as title,
  -- Failed when password is enabled and the key was created within 10 seconds of the user
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case when
    password_enabled = 'TRUE' 
    and
    (
        TIMEDIFF(second, access_key_1_last_rotated,user_creation_time) < 10
        or 
        TIMEDIFF(second, access_key_2_last_rotated, user_creation_time) < 10
    )
    then 'fail'
    else 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}

{% macro bigquery__iam_user_access_keys_and_password_at_setup(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Do not setup access keys during initial user setup for all IAM users that have a console password' as title,
  -- Failed when password is enabled and the key was created within 10 seconds of the user
  SPLIT(arn, ':')[SAFE_OFFSET(4)] AS account_id,
  arn as resource_id,
  case when
    password_enabled = 'TRUE' 
    and
    (
        TIME_DIFF(TIME(access_key_1_last_rotated),TIME(user_creation_time), SECOND) < 10
        or 
        TIME_DIFF(TIME(access_key_2_last_rotated), TIME(user_creation_time), SECOND) < 10
    )
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_iam_credential_reports") }}
{% endmacro %}