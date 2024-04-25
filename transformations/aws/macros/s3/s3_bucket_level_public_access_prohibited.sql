{% macro s3_bucket_level_public_access_prohibited(framework, check_id) %}
  {{ return(adapter.dispatch('s3_bucket_level_public_access_prohibited')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_bucket_level_public_access_prohibited(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_bucket_level_public_access_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
    when (pab.public_access_block_configuration -> 'block_public_acls')::boolean
    and (pab.public_access_block_configuration -> 'block_public_policy')::boolean
    and (pab.public_access_block_configuration -> 'ignore_public_acls')::boolean
    and (pab.public_access_block_configuration -> 'restrict_public_buckets')::boolean
	THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets as b
LEFT JOIN
    aws_s3_bucket_public_access_blocks as pab on pab.bucket_arn = b.arn
{% endmacro %}

{% macro snowflake__s3_bucket_level_public_access_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
    when pab.public_access_block_configuration:block_public_acls
    and pab.public_access_block_configuration:block_public_policy
    and pab.public_access_block_configuration:ignore_public_acls
    and pab.public_access_block_configuration:restrict_public_buckets THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets as b
LEFT JOIN
    aws_s3_bucket_public_access_blocks as pab on pab.bucket_arn = b.arn
{% endmacro %}

{% macro bigquery__s3_bucket_level_public_access_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
    when CAST( JSON_VALUE(pab.public_access_block_configuration.block_public_acls) AS BOOL)
    and CAST( JSON_VALUE(pab.public_access_block_configuration.block_public_policy) AS BOOL)
    and CAST( JSON_VALUE(pab.public_access_block_configuration.ignore_public_acls) AS BOOL)
    and CAST( JSON_VALUE(pab.public_access_block_configuration.restrict_public_buckets) AS BOOL)
    THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    {{ full_table_name("aws_s3_buckets") }}
 as b
LEFT JOIN
    {{ full_table_name("aws_s3_bucket_public_access_blocks") }}
 as pab on pab.bucket_arn = b.arn
{% endmacro %}

{% macro athena__s3_bucket_level_public_access_prohibited(framework, check_id) %}
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 Block Public Access setting should be enabled at the bucket-level' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
    when json_extract_scalar(pab.public_access_block_configuration, '$.block_public_acls')
    and json_extract_scalar(pab.public_access_block_configuration, '$.block_public_policy')
    and json_extract_scalar(pab.public_access_block_configuration, '$.ignore_public_acls')
    and json_extract_scalar(pab.public_access_block_configuration, '$.restrict_public_buckets') THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets as b
LEFT JOIN
    aws_s3_bucket_public_access_blocks as pab on pab.bucket_arn = b.arn
{% endmacro %}