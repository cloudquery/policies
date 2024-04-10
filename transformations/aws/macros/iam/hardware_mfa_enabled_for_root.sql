{% macro hardware_mfa_enabled_for_root(framework, check_id) %}
  {{ return(adapter.dispatch('hardware_mfa_enabled_for_root')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__hardware_mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure hardware MFA is enabled for the "root" account (Scored)' as title,
  split_part(cr.arn, ':', 5) as account_id,
  cr.arn as resource_id,
  case
    when cr.mfa_active = FALSE or mfa.serial_number like 'arn%' or mfa.serial_number is null then 'fail'
    when mfa.serial_number not like 'arn%' and mfa.serial_number is not null and cr.mfa_active = TRUE then 'pass'
  end as status
from aws_iam_credential_reports cr
left join
    aws_iam_virtual_mfa_devices mfa on
        mfa.user:Arn = cr.arn
where cr.user = '<root_account>'
group by mfa.serial_number, cr.mfa_active, cr.arn
{% endmacro %}

{% macro postgres__hardware_mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure hardware MFA is enabled for the "root" account (Scored)' as title,
  split_part(cr.arn, ':', 5) as account_id,
  cr.arn as resource_id,
  case
    when cr.mfa_active = FALSE or mfa.serial_number like 'arn%' or mfa.serial_number is null then 'fail'
    when mfa.serial_number not like 'arn%' and mfa.serial_number is not null and cr.mfa_active = TRUE then 'pass'
  end as status
from aws_iam_credential_reports cr
left join
    aws_iam_virtual_mfa_devices mfa on
        mfa.user->>'Arn' = cr.arn
where cr.user = '<root_account>'
group by mfa.serial_number, cr.mfa_active, cr.arn
{% endmacro %}

{% macro bigquery__hardware_mfa_enabled_for_root(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure hardware MFA is enabled for the "root" account (Scored)' as title,
  SPLIT(cr.arn, ':')[SAFE_OFFSET(4)] AS account_id,
  cr.arn as resource_id,
  case
    when cr.mfa_active = FALSE or mfa.serial_number like 'arn%' or mfa.serial_number is null then 'fail'
    when mfa.serial_number not like 'arn%' and mfa.serial_number is not null and cr.mfa_active = TRUE then 'pass'
  end as status
from {{ full_table_name("aws_iam_credential_reports") }} cr
left join
    {{ full_table_name("aws_iam_virtual_mfa_devices") }} mfa on
        JSON_VALUE(mfa.user.Arn) = cr.arn
where cr.user = '<root_account>'
group by mfa.serial_number, cr.mfa_active, cr.arn
{% endmacro %}
