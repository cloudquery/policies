{% macro s3_bucket_level_public_access_prohibited(framework, check_id) %}
  {{ return(adapter.dispatch('s3_bucket_level_public_access_prohibited')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_bucket_level_public_access_prohibited(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_bucket_level_public_access_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    account_id,
    arn AS resource_id,
    CASE
    when block_public_acls
    and block_public_policy
    and ignore_public_acls
    and restrict_public_buckets THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets
{% endmacro %}

{% macro snowflake__s3_bucket_level_public_access_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    account_id,
    arn AS resource_id,
    CASE
    when block_public_acls
    and block_public_policy
    and ignore_public_acls
    and restrict_public_buckets THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets
{% endmacro %}