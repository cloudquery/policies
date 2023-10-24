{% macro s3_event_notifications_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should have event notifications enabled' AS title,
    account_id,
    bucket_arn AS resource_id,    
    CASE WHEN
        (EVENT_BRIDGE_CONFIGURATION::String IS NULL OR ARRAY_SIZE(EVENT_BRIDGE_CONFIGURATION) = 0)
        AND (LAMBDA_FUNCTION_CONFIGURATIONS::String IS NULL OR ARRAY_SIZE(LAMBDA_FUNCTION_CONFIGURATIONS) = 0)
        AND (QUEUE_CONFIGURATIONS::String IS NULL OR ARRAY_SIZE(QUEUE_CONFIGURATIONS) = 0)
        AND (TOPIC_CONFIGURATIONS::String IS NULL OR ARRAY_SIZE(TOPIC_CONFIGURATIONS) = 0)
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    aws_s3_bucket_notification_configurations
{% endmacro %}