{% macro s3_event_notifications_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('s3_event_notifications_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_event_notifications_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_event_notifications_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should have event notifications enabled' AS title,
    account_id,
    bucket_arn AS resource_id,  
    CASE WHEN
        (EVENT_BRIDGE_CONFIGURATION::text IS NULL OR jsonb_array_length(EVENT_BRIDGE_CONFIGURATION) = 0)
        AND (LAMBDA_FUNCTION_CONFIGURATIONS::text IS NULL OR jsonb_array_length(LAMBDA_FUNCTION_CONFIGURATIONS) = 0)
        AND (QUEUE_CONFIGURATIONS::text IS NULL OR jsonb_array_length(QUEUE_CONFIGURATIONS) = 0)
        AND (TOPIC_CONFIGURATIONS::text IS NULL OR jsonb_array_length(TOPIC_CONFIGURATIONS) = 0)
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    aws_s3_bucket_notification_configurations
{% endmacro %}

{% macro snowflake__s3_event_notifications_enabled(framework, check_id) %}
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

{% macro bigquery__s3_event_notifications_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should have event notifications enabled' AS title,
    account_id,
    bucket_arn AS resource_id,    
    CASE WHEN
        (CAST(JSON_VALUE(EVENT_BRIDGE_CONFIGURATION) AS STRING) IS NULL OR ARRAY_LENGTH(JSON_QUERY_ARRAY(EVENT_BRIDGE_CONFIGURATION)) = 0)
        AND (CAST(JSON_VALUE(LAMBDA_FUNCTION_CONFIGURATIONS) AS STRING) IS NULL OR ARRAY_LENGTH(JSON_QUERY_ARRAY(LAMBDA_FUNCTION_CONFIGURATIONS)) = 0)
        AND (CAST(JSON_VALUE(QUEUE_CONFIGURATIONS) AS STRING) IS NULL OR ARRAY_LENGTH(JSON_QUERY_ARRAY(QUEUE_CONFIGURATIONS)) = 0)
        AND (CAST(JSON_VALUE(TOPIC_CONFIGURATIONS) AS STRING) IS NULL OR ARRAY_LENGTH(JSON_QUERY_ARRAY(TOPIC_CONFIGURATIONS)) = 0)
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    {{ full_table_name("aws_s3_bucket_notification_configurations") }}
{% endmacro %}

{% macro athena__s3_event_notifications_enabled(framework, check_id) %}
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'S3 buckets should have event notifications enabled' AS title,
    account_id,
    bucket_arn AS resource_id,    
    CASE WHEN
        (event_bridge_configuration is null or event_bridge_configuration = '[]' or json_array_length(json_parse(event_bridge_configuration)) = 0)
        AND (lambda_function_configurations is null or lambda_function_configurations = '[]' or json_array_length(json_parse(lambda_function_configurations)) = 0)
        AND (queue_configurations is null or queue_configurations = '[]' or json_array_length(json_parse(queue_configurations)) = 0)
        AND (topic_configurations is null or topic_configurations = '[]' or json_array_length(json_parse(topic_configurations)) = 0)
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    aws_s3_bucket_notification_configurations
{% endmacro %}