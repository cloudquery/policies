{% macro mfa_delete(framework, check_id) %}
  {{ return(adapter.dispatch('mfa_delete')(framework, check_id)) }}
{% endmacro %}

{% macro default__mfa_delete(framework, check_id) %}{% endmacro %}

{% macro postgres__mfa_delete(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure MFA Delete is enabled on S3 buckets (Automated)' as title,
    account_id,
    arn AS resource_id,
    case when
        versioning_status is distinct from 'Enabled'
        or versioning_mfa_delete is distinct from 'Enabled'
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
{% endmacro %}
