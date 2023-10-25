{% macro s3_bucket_logging_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 bucket server access logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE
        when logging_target_bucket IS NOT NULL
        THEN 'pass' ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets
{% endmacro %}