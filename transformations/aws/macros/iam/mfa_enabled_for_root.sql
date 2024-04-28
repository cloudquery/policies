{% macro mfa_enabled_for_root(framework, check_id) %}
  {{ return(adapter.dispatch('mfa_enabled_for_root')(framework, check_id)) }}
{% endmacro %}

{% macro default__mfa_enabled_for_root(framework, check_id) %}{% endmacro %}

{% macro postgres__mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure MFA is enabled for the "root" account' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case
    when user = '<root_account>' and not mfa_active then 'fail' -- TODO check
    when user = '<root_account>' and mfa_active then 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}

{% macro bigquery__mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure MFA is enabled for the "root" account' as title,
  SPLIT(arn, ':')[SAFE_OFFSET(4)] AS account_id,
  arn as resource_id,
  case
    when user = '<root_account>' and not mfa_active then 'fail' -- TODO check
    when user = '<root_account>' and mfa_active then 'pass'
  end as status
from {{ full_table_name("aws_iam_credential_reports") }}
{% endmacro %}

{% macro snowflake__mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure MFA is enabled for the "root" account' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case
    when user = '<root_account>' and not mfa_active then 'fail' -- TODO check
    when user = '<root_account>' and mfa_active then 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}

{% macro athena__mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure MFA is enabled for the "root" account' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case
    when user = '<root_account>' and not mfa_active then 'fail' -- TODO check
    when user = '<root_account>' and mfa_active then 'pass'
  end as status
from aws_iam_credential_reports
{% endmacro %}