{% macro s3_bucket_level_public_access_prohibited(framework, check_id) %}
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