{% macro bucket_level_public_access_blocks(framework, check_id) %}
  {{ return(adapter.dispatch('bucket_level_public_access_blocks')(framework, check_id)) }}
{% endmacro %}

{% macro default__bucket_level_public_access_blocks(framework, check_id) %}{% endmacro %}

{% macro postgres__bucket_level_public_access_blocks(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' as title,
    account_id,
    arn AS resource_id,
    case when
        block_public_acls is not TRUE
        or block_public_policy is not TRUE
        or ignore_public_acls is not TRUE
        or restrict_public_buckets is not TRUE
    then 'fail' else 'pass' end as status
from
    aws_s3_buckets
{% endmacro %}
