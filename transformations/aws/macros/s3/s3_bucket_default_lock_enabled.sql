{% macro s3_bucket_default_lock_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('s3_bucket_default_lock_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_bucket_default_lock_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_bucket_default_lock_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should be configured to use Object Lock' AS title,
    a.account_id,
    a.arn AS resource_id,
    CASE WHEN b.object_lock_enabled = 'Enabled' THEN 'pass' ELSE 'fail' END AS status
FROM
    aws_s3_buckets a
LEFT JOIN
    aws_s3_bucket_object_lock_configurations b
ON
    a.arn = b.bucket_arn
GROUP BY
    a.account_id,
    a.arn,
    status
{% endmacro %}

{% macro snowflake__s3_bucket_default_lock_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should be configured to use Object Lock' AS title,
    a.account_id,
    a.arn AS resource_id,
    CASE WHEN b.object_lock_enabled = 'Enabled' THEN 'pass' ELSE 'fail' END AS status
FROM
    aws_s3_buckets a
LEFT JOIN
    aws_s3_bucket_object_lock_configurations b
ON
    a.arn = b.bucket_arn
GROUP BY
    a.account_id,
    a.arn,
    status
{% endmacro %}

{% macro bigquery__s3_bucket_default_lock_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should be configured to use Object Lock' AS title,
    a.account_id,
    a.arn AS resource_id,
    CASE WHEN b.object_lock_enabled = 'Enabled' THEN 'pass' ELSE 'fail' END AS status
FROM
    {{ full_table_name("aws_s3_buckets") }} a
LEFT JOIN
    {{ full_table_name("aws_s3_bucket_object_lock_configurations") }} b
ON
    a.arn = b.bucket_arn
GROUP BY
    a.account_id,
    a.arn,
    status
{% endmacro %}

{% macro athena__s3_bucket_default_lock_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should be configured to use Object Lock' AS title,
    a.account_id,
    a.arn AS resource_id,
    CASE WHEN b.object_lock_enabled = 'Enabled' THEN 'pass' ELSE 'fail' END AS status
FROM
    aws_s3_buckets a
LEFT JOIN
    aws_s3_bucket_object_lock_configurations b
ON
    a.arn = b.bucket_arn
GROUP BY
    a.account_id,
    a.arn,
    b.object_lock_enabled
{% endmacro %}