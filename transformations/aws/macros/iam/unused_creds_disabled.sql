{% macro unused_creds_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('unused_creds_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_creds_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_creds_disabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure credentials unused for 90 days or greater are disabled (Scored)' as title,
  split_part(r.arn, ':', 5) as account_id,
  r.arn,
  case when
      (r.password_status IN ('TRUE', 'true') and r.password_last_used < (now() - '90 days'::INTERVAL)
        or (k.last_used < (now() - '90 days'::INTERVAL)))
      then 'fail'
      else 'pass'
  end
from aws_iam_credential_reports r
left join aws_iam_user_access_keys k on k.user_arn = r.arn
{% endmacro %}

{% macro bigquery__unused_creds_disabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure credentials unused for 90 days or greater are disabled (Scored)' as title,
  SPLIT(arn, ':')[SAFE_OFFSET(4)] AS account_id,
  r.arn,
  case when 
      (r.password_status IN ('TRUE', 'true') and r.password_last_used < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
        or (k.last_used < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)))
      then 'fail'
      else 'pass'
  end
from {{ full_table_name("aws_iam_credential_reports") }} r
left join {{ full_table_name("aws_iam_user_access_keys") }} k on k.user_arn = r.arn
{% endmacro %}

{% macro snowflake__unused_creds_disabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure credentials unused for 90 days or greater are disabled (Scored)' as title,
  split_part(r.arn, ':', 5) as account_id,
  r.arn,
  case when
      (r.password_status IN ('TRUE', 'true') and r.password_last_used < (CURRENT_TIMESTAMP() - INTERVAL '90 DAY')
        or (k.last_used < (CURRENT_TIMESTAMP() - INTERVAL '90 DAY')))
      then 'fail'
      else 'pass'
  end
from aws_iam_credential_reports r
left join aws_iam_user_access_keys k on k.user_arn = r.arn
{% endmacro %}

{% macro athena__unused_creds_disabled(framework, check_id) %}
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure credentials unused for 90 days or greater are disabled (Scored)' AS title,
  split_part(r.arn, ':', 5) AS account_id,
  r.arn AS resource_id,
  CASE 
    WHEN 
      (lower(r.password_status) = 'true' AND date_diff('day', r.password_last_used, current_timestamp) > 90)
      OR (date_diff('day', k.last_used, current_timestamp) > 90)
    THEN 'fail'
    ELSE 'pass'
  END AS status
FROM 
  aws_iam_credential_reports r
LEFT JOIN 
  aws_iam_user_access_keys k ON k.user_arn = r.arn
{% endmacro %}
