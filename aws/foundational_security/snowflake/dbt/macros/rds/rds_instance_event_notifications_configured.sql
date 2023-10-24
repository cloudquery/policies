{% macro rds_instance_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database instance events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN   
            ARRAY_CONTAINS('maintenance'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('failure'::variant, EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
WHERE
    source_type = 'db-instance'
{% endmacro %}