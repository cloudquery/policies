{% macro rds_sg_event_notifications_configured(framework, check_id) %}
  {{ return(adapter.dispatch('rds_sg_event_notifications_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_sg_event_notifications_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_sg_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database security group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            'configuration change' = any(EVENT_CATEGORIES) AND
			'failure' = any(EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-security-group'
{% endmacro %}

{% macro snowflake__rds_sg_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database security group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('failure'::variant, EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-security-group'
{% endmacro %}

{% macro bigquery__rds_sg_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database security group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            'configuration' IN UNNEST(EVENT_CATEGORIES) AND
            'failure' IN UNNEST(EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    {{ full_table_name("aws_rds_events") }}
where source_type = 'db-security-group'
{% endmacro %}

{% macro athena__rds_sg_event_notifications_configured(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'An RDS event notifications subscription should be configured for critical database security group events' AS title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            contains(cast(EVENT_CATEGORIES as array(varchar)), 'configuration change') AND
            contains(cast(EVENT_CATEGORIES as array(varchar)), 'failure')
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM aws_rds_events
WHERE source_type = 'db-security-group'
{% endmacro %}