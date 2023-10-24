{% macro rds_pg_event_notifications_configured(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database parameter group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-parameter-group'
{% endmacro %}