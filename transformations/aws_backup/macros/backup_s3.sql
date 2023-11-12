{% macro backup_s3() %}
    SELECT aws_s3_buckets.account_id, aws_s3_buckets.arn as resource_arn, tags, last_backup_time, 'S3' as resource_type
    FROM aws_s3_buckets
    LEFT JOIN aws_backup_protected_resources
    ON aws_backup_protected_resources.resource_arn = aws_s3_buckets.arn
{% endmacro %}



