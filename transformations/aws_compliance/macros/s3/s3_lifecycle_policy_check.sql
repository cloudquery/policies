{% macro s3_lifecycle_policy_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should have lifecycle policies configured' AS title,
    b.account_id,
    b.arn AS resource_id,
    CASE
        WHEN l.STATUS = 'Enabled' THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_s3_buckets AS b
LEFT JOIN
    aws_s3_bucket_lifecycles AS l
ON
    b.arn = l.bucket_arn
{% endmacro %}