{% macro s3_version_lifecycle_policy_check(framework, check_id) %}
  {{ return(adapter.dispatch('s3_version_lifecycle_policy_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_version_lifecycle_policy_check(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_version_lifecycle_policy_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets with versioning enabled should have lifecycle policies configured' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
        WHEN l.STATUS = 'Enabled' THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets AS b
LEFT JOIN
    aws_s3_bucket_versionings AS bv
    ON
    b.arn = bv.bucket_arn
LEFT JOIN
    aws_s3_bucket_lifecycles AS l
    ON
    b.arn = l.bucket_arn
where bv.status = 'Enabled'
{% endmacro %}

{% macro snowflake__s3_version_lifecycle_policy_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets with versioning enabled should have lifecycle policies configured' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
        WHEN l.STATUS = 'Enabled' THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets AS b
LEFT JOIN
    aws_s3_bucket_versionings AS bv
    ON
    b.arn = bv.bucket_arn
LEFT JOIN
    aws_s3_bucket_lifecycles AS l
    ON
    b.arn = l.bucket_arn
where bv.status = 'Enabled'
{% endmacro %}