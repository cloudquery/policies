{% macro mfa_enabled_for_console_access(framework, check_id) %}
  {{ return(adapter.dispatch('mfa_enabled_for_console_access')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__mfa_enabled_for_console_access(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure MFA is enabled for all IAM users that have a console password (Scored)' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case when
    password_status IN ('TRUE', 'true') and not mfa_active
    then 'fail'
    else 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}

{% macro postgres__mfa_enabled_for_console_access(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure MFA is enabled for all IAM users that have a console password (Scored)' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case when
    password_status IN ('TRUE', 'true') and not mfa_active
    then 'fail'
    else 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}
